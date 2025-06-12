-- Enable Row Level Security on all tables (if not already enabled at the instance level)
-- This command is typically run once by a superuser.
-- ALTER SYSTEM SET pgsodium.enabled = true;
-- You might need to restart PostgreSQL or reload config for this to take effect.
-- For Supabase hosted projects, pgsodium is usually enabled by default.

-- Create tables for m'mmiere app
CREATE TABLE IF NOT EXISTS mmm_products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  name_en TEXT NOT NULL,         -- Added for English name
  name_ro TEXT NOT NULL,         -- Added for Romanian name
  description_en TEXT,         -- Added for English description
  description_ro TEXT,         -- Added for Romanian description
  price NUMERIC(10, 2) NOT NULL,
  stock_quantity INTEGER NOT NULL DEFAULT 0,
  image_path TEXT,               -- Path within the mmm_product_images bucket
  is_active BOOLEAN DEFAULT true,
  -- Consider adding category, weight, or other honey-specific attributes
  positively_affects TEXT[] -- Array of strings for icons like 'overstrain', 'falling_asleep'
);

CREATE TABLE IF NOT EXISTS mmm_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE, -- Links to the global auth.users table
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  full_name TEXT,
  -- email is already in auth.users, typically not duplicated here unless for specific reasons
  preferred_language TEXT DEFAULT 'en' -- App-specific language preference
);

CREATE TABLE IF NOT EXISTS mmm_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  user_id UUID REFERENCES mmm_profiles(id) ON DELETE SET NULL, -- References mmm_profiles
  total_amount NUMERIC(10, 2) NOT NULL,
  currency TEXT DEFAULT 'RON', -- Added currency
  status TEXT NOT NULL DEFAULT 'pending', -- e.g., pending, processing, shipped, delivered, cancelled
  shipping_address JSONB,
  billing_address JSONB, -- Optional: if different from shipping
  payment_intent_id TEXT, -- For Stripe or other payment gateway reference
  payment_method TEXT
);

CREATE TABLE IF NOT EXISTS mmm_order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES mmm_orders(id) ON DELETE CASCADE,   -- References mmm_orders
  product_id UUID REFERENCES mmm_products(id) ON DELETE SET NULL, -- References mmm_products
  quantity INTEGER NOT NULL,
  price_at_purchase NUMERIC(10, 2) NOT NULL,
  product_name_snapshot_en TEXT, -- Snapshot of product name at time of purchase
  product_name_snapshot_ro TEXT  -- Snapshot of product name at time of purchase
);

-- Set up Row Level Security policies for m'mmiere tables
ALTER TABLE mmm_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE mmm_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE mmm_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE mmm_order_items ENABLE ROW LEVEL SECURITY;

-- mmm_products policies
CREATE POLICY "Enable read access for all users on mmm_products" ON mmm_products
  FOR SELECT USING (is_active = true); -- Only show active products to public

CREATE POLICY "Enable admin/staff insert for mmm_products" ON mmm_products
  FOR INSERT WITH CHECK (auth.role() = 'service_role' OR EXISTS (SELECT 1 FROM mmm_profiles WHERE mmm_profiles.id = auth.uid() AND /* add admin check here e.g., mmm_profiles.is_admin = true */ false)); -- Restrict inserts, placeholder for admin logic

CREATE POLICY "Enable admin/staff update for mmm_products" ON mmm_products
  FOR UPDATE USING (auth.role() = 'service_role' OR EXISTS (SELECT 1 FROM mmm_profiles WHERE mmm_profiles.id = auth.uid() AND /* add admin check here */ false)); -- Restrict updates

-- mmm_profiles policies
CREATE POLICY "Public mmm_profiles are viewable by everyone" ON mmm_profiles
  FOR SELECT USING (true); -- Or restrict if profile info should be private

CREATE POLICY "Users can update their own mmm_profile" ON mmm_profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own mmm_profile" ON mmm_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- mmm_orders policies
CREATE POLICY "Users can view their own mmm_orders" ON mmm_orders
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create mmm_orders for themselves" ON mmm_orders
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Admins can manage all mmm_orders" ON mmm_orders
  FOR ALL USING (auth.role() = 'service_role' OR EXISTS (SELECT 1 FROM mmm_profiles WHERE mmm_profiles.id = auth.uid() AND /* add admin check here */ false)); -- Admin override, placeholder

-- mmm_order_items policies
CREATE POLICY "Users can view their own mmm_order_items" ON mmm_order_items
  FOR SELECT USING (EXISTS (
    SELECT 1 FROM mmm_orders WHERE mmm_orders.id = mmm_order_items.order_id AND mmm_orders.user_id = auth.uid()
  ));

CREATE POLICY "Admins can manage all mmm_order_items" ON mmm_order_items
  FOR ALL USING (auth.role() = 'service_role' OR EXISTS (SELECT 1 FROM mmm_profiles mp JOIN mmm_orders mo ON mp.id = mo.user_id WHERE mo.id = mmm_order_items.order_id AND /* add admin check on mp */ false)); -- Admin override, placeholder

-- Create storage bucket for m'mmiere product images
-- Ensure this name is unique if the other app also uses storage.
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES ('mmm_product_images', 'mmm_product_images', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp'])
ON CONFLICT (id) DO NOTHING; -- Avoid error if bucket already exists

-- Set up storage policies for mmm_product_images bucket
CREATE POLICY "Product images in mmm_product_images are publicly accessible" ON storage.objects
  FOR SELECT USING (bucket_id = 'mmm_product_images');

-- Allowing authenticated users to upload might be too broad.
-- Typically, only admins or a service role should upload product images.
CREATE POLICY "Admin/staff can upload to mmm_product_images" ON storage.objects
  FOR INSERT TO authenticated -- Consider 'service_role' or specific role
  WITH CHECK (
    bucket_id = 'mmm_product_images' AND
    (auth.role() = 'service_role' OR EXISTS (SELECT 1 FROM mmm_profiles WHERE mmm_profiles.id = auth.uid() AND /* add admin check here */ false))
    -- AND owner = auth.uid() -- if users upload their own content, not applicable for product images
  );

CREATE POLICY "Admin/staff can update/delete images in mmm_product_images" ON storage.objects
    FOR UPDATE USING (
        bucket_id = 'mmm_product_images' AND
        (auth.role() = 'service_role' OR EXISTS (SELECT 1 FROM mmm_profiles WHERE mmm_profiles.id = auth.uid() AND /* add admin check here */ false))
    );

CREATE POLICY "Admin/staff can delete images in mmm_product_images" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'mmm_product_images' AND
        (auth.role() = 'service_role' OR EXISTS (SELECT 1 FROM mmm_profiles WHERE mmm_profiles.id = auth.uid() AND /* add admin check here */ false))
    );

-- Note on Admin Checks:
-- The placeholders "/* add admin check here */ false" need to be replaced with your actual admin role logic.
-- This might involve:
-- 1. Adding an `is_admin BOOLEAN DEFAULT false` column to `mmm_profiles`.
-- 2. Creating a custom PostgreSQL function `is_app_admin()` that checks this role.
-- 3. Or using Supabase custom claims if you manage roles that way.
-- Example for an `is_admin` column in `mmm_profiles`:
-- `EXISTS (SELECT 1 FROM mmm_profiles WHERE mmm_profiles.id = auth.uid() AND mmm_profiles.is_admin = true)`