// Supabase Configuration
// Nahraďte svými skutečnými hodnotami z Supabase projektu

const SUPABASE_CONFIG = {
  url: 'https://your-project.supabase.co',
  anonKey: 'your-anon-key-here'
};

// Inicializace Supabase klienta
const supabase = window.supabase.createClient(SUPABASE_CONFIG.url, SUPABASE_CONFIG.anonKey);

// Helper funkce pro autentizaci
const Auth = {
  // Přihlášení přes email/heslo
  async signIn(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) throw error;
    return data;
  },

  // Registrace nového uživatele
  async signUp(email, password, metadata = {}) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: metadata }
    });
    if (error) throw error;
    return data;
  },

  // Odhlášení
  async signOut() {
    const { error } = await supabase.auth.signOut();
    if (error) throw error;
  },

  // Získání aktuálního uživatele
  async getUser() {
    const { data: { user }, error } = await supabase.auth.getUser();
    if (error) throw error;
    return user;
  },

  // Poslech změn autentizace
  onAuthStateChange(callback) {
    return supabase.auth.onAuthStateChange(callback);
  }
};

// Helper funkce pro databázové operace
const DB = {
  // Chaty
  async getChaty(filters = {}) {
    let query = supabase.from('chaty').select('*');
    
    if (filters.region) query = query.eq('region', filters.region);
    if (filters.minPrice) query = query.gte('price_from', filters.minPrice);
    if (filters.maxPrice) query = query.lte('price_from', filters.maxPrice);
    if (filters.capacity) query = query.gte('capacity', filters.capacity);
    
    const { data, error } = await query;
    if (error) throw error;
    return data;
  },

  async getChata(id) {
    const { data, error } = await supabase
      .from('chaty')
      .select('*')
      .eq('id', id)
      .single();
    if (error) throw error;
    return data;
  },

  async createChata(chataData) {
    const { data, error } = await supabase
      .from('chaty')
      .insert([chataData])
      .select()
      .single();
    if (error) throw error;
    return data;
  },

  async updateChata(id, updates) {
    const { data, error } = await supabase
      .from('chaty')
      .update(updates)
      .eq('id', id)
      .select()
      .single();
    if (error) throw error;
    return data;
  },

  // Rezervace
  async createReservation(reservationData) {
    const { data, error } = await supabase
      .from('reservations')
      .insert([reservationData])
      .select()
      .single();
    if (error) throw error;
    return data;
  },

  async getReservations(userId) {
    const { data, error } = await supabase
      .from('reservations')
      .select('*, chaty(*)')
      .eq('user_id', userId)
      .order('created_at', { ascending: false });
    if (error) throw error;
    return data;
  },

  // Oblíbené
  async addToFavorites(userId, chataId) {
    const { data, error } = await supabase
      .from('favorites')
      .insert([{ user_id: userId, chata_id: chataId }])
      .select()
      .single();
    if (error) throw error;
    return data;
  },

  async removeFromFavorites(userId, chataId) {
    const { error } = await supabase
      .from('favorites')
      .delete()
      .eq('user_id', userId)
      .eq('chata_id', chataId);
    if (error) throw error;
  },

  async getFavorites(userId) {
    const { data, error } = await supabase
      .from('favorites')
      .select('*, chaty(*)')
      .eq('user_id', userId);
    if (error) throw error;
    return data;
  }
};

// Helper funkce pro storage (obrázky)
const Storage = {
  async uploadImage(bucket, path, file) {
    const { data, error } = await supabase.storage
      .from(bucket)
      .upload(path, file, {
        cacheControl: '3600',
        upsert: false
      });
    if (error) throw error;
    return data;
  },

  getPublicUrl(bucket, path) {
    const { data } = supabase.storage
      .from(bucket)
      .getPublicUrl(path);
    return data.publicUrl;
  },

  async deleteImage(bucket, path) {
    const { error } = await supabase.storage
      .from(bucket)
      .remove([path]);
    if (error) throw error;
  }
};

// Real-time subscriptions
const Realtime = {
  subscribeToChaty(callback) {
    return supabase
      .channel('chaty-changes')
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'chaty'
      }, callback)
      .subscribe();
  },

  subscribeToReservations(userId, callback) {
    return supabase
      .channel(`reservations-${userId}`)
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'reservations',
        filter: `user_id=eq.${userId}`
      }, callback)
      .subscribe();
  }
};

// Export pro použití v jiných skriptech
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { supabase, Auth, DB, Storage, Realtime };
}
