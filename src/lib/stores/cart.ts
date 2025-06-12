import { writable } from 'svelte/store';

type CartItem = {
  id: string;
  name: string;
  price: number;
  quantity: number;
  imageUrl?: string;
};

export const cart = writable<CartItem[]>([]);

// Helper functions for cart operations
export function addToCart(item: Omit<CartItem, 'quantity'>) {
  cart.update(items => {
    const existingItem = items.find(i => i.id === item.id);
    if (existingItem) {
      return items.map(i => 
        i.id === item.id ? { ...i, quantity: i.quantity + 1 } : i
      );
    }
    return [...items, { ...item, quantity: 1 }];
  });
}

export function removeFromCart(itemId: string) {
  cart.update(items => items.filter(i => i.id !== itemId));
}

export function updateQuantity(itemId: string, quantity: number) {
  if (quantity <= 0) {
    removeFromCart(itemId);
    return;
  }
  
  cart.update(items => 
    items.map(i => (i.id === itemId ? { ...i, quantity } : i))
  );
}

export function clearCart() {
  cart.set([]);
}
