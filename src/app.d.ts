// See https://svelte.dev/docs/kit/types#app.d.ts
// for information about these interfaces
declare global {
  namespace App {
    // interface Error {}
    // interface Locals {}
    // interface PageData {}
    // interface PageState {}
    // interface Platform {}
  }
}

// Health effect as stored in mmm_health_effects
export type HealthEffect = {
  id: number;
  key: string;
  label_en: string;
  label_ro: string;
  icon_name: string;
  description: string;
};

// Join table row for mmm_product_effects
export type ProductEffect = {
  product_id: string; // UUID
  effect_id: number;
};

// Product as returned from mmm_products, extended for new fields and health effects
export type Product = {
  id: string;
  created_at: string;
  name_en: string;
  name_ro: string;
  description_en: string;
  description_ro: string;
  application_description_en?: string;
  application_description_ro?: string;
  price: number;
  stock_quantity: number;
  image_path?: string;
  icon_path?: string;
  icon_title?: string;
  is_active: boolean;
  // New: joined health effects
  health_effects?: HealthEffect[];
};

export {};
