// src/routes/api/create-payment-intent/+server.ts
import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import Stripe from 'stripe';
import { env } from '$env/dynamic/private';

// Note: Using `env` from `$env/dynamic/private` is the SvelteKit way to access
// environment variables on the server-side, ensuring they are not exposed to the client.
// Your .env variable should NOT have the VITE_ prefix if it's only for the server.
// Let's assume you have STRIPE_SECRET_KEY in your .env file.
const STRIPE_SECRET_KEY = env.STRIPE_SECRET_KEY;

if (!STRIPE_SECRET_KEY) {
  console.error('Stripe secret key not found. Ensure STRIPE_SECRET_KEY is set in your .env file.');
}

const stripe = new Stripe(STRIPE_SECRET_KEY as string, {
  apiVersion: '2024-06-20',
  typescript: true,
});

export const POST: RequestHandler = async ({ request }) => {
  const { amount, currency = 'ron' } = await request.json();

  if (!amount || amount <= 0) {
    throw error(400, 'Invalid amount specified.');
  }

  if (!stripe) {
    throw error(500, 'Stripe service is not initialized.');
  }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Amount in smallest currency unit (e.g., bani for RON)
      currency: currency,
      payment_method_types: ['card'],
      // You can add metadata here, e.g., metadata: { order_id: 'some_order_id' }
    });

    return json({ clientSecret: paymentIntent.client_secret });

  } catch (e: any) {
    console.error('Error creating payment intent:', e.message);
    throw error(500, `Failed to create payment intent: ${e.message}`);
  }
};
