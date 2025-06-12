import { writable } from 'svelte/store';
import type { Session, User } from '@supabase/supabase-js';

export interface UserProfile extends User {
  full_name?: string;
  preferred_language?: string;
}

interface UserStore {
  session: Session | null;
  user: UserProfile | null;
  profileLoading: boolean;
}

const initialUserState: UserStore = {
  session: null,
  user: null,
  profileLoading: false,
};

export const userStore = writable<UserStore>(initialUserState);
