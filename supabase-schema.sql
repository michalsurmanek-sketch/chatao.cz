-- CHATAO.cz Database Schema pro Supabase
-- Spusťte tento SQL v Supabase SQL editoru

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabulka pro chaty/chalupy
CREATE TABLE IF NOT EXISTS chaty (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Základní info
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  description TEXT,
  owner_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Lokace
  region VARCHAR(100),
  location_lat DECIMAL(10, 8),
  location_lng DECIMAL(11, 8),
  address TEXT,
  
  -- Kapacita a ceny
  capacity INTEGER DEFAULT 1,
  price_from INTEGER NOT NULL,
  price_per_night INTEGER,
  
  -- Vybavení (JSON pole)
  amenities JSONB DEFAULT '[]'::jsonb,
  
  -- Kontakt
  instagram_handle VARCHAR(255),
  contact_email VARCHAR(255),
  contact_phone VARCHAR(50),
  
  -- Obrázky (pole URL)
  images JSONB DEFAULT '[]'::jsonb,
  thumbnail_url TEXT,
  
  -- Hodnocení
  rating DECIMAL(3, 2) DEFAULT 0,
  reviews_count INTEGER DEFAULT 0,
  
  -- Status
  is_published BOOLEAN DEFAULT false,
  is_featured BOOLEAN DEFAULT false,
  
  -- Metadata
  views_count INTEGER DEFAULT 0,
  bookings_count INTEGER DEFAULT 0
);

-- Tabulka pro rezervace
CREATE TABLE IF NOT EXISTS reservations (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  chata_id UUID REFERENCES chaty(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Datumy
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  
  -- Info o rezervaci
  guests_count INTEGER DEFAULT 1,
  total_price INTEGER NOT NULL,
  
  -- Status
  status VARCHAR(50) DEFAULT 'pending', -- pending, confirmed, cancelled, completed
  
  -- Kontakt
  guest_name VARCHAR(255),
  guest_email VARCHAR(255),
  guest_phone VARCHAR(50),
  
  -- Poznámky
  notes TEXT,
  
  -- Instagram thread ID pro chat
  instagram_thread_id VARCHAR(255)
);

-- Tabulka pro oblíbené
CREATE TABLE IF NOT EXISTS favorites (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  chata_id UUID REFERENCES chaty(id) ON DELETE CASCADE,
  
  UNIQUE(user_id, chata_id)
);

-- Tabulka pro recenze
CREATE TABLE IF NOT EXISTS reviews (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  chata_id UUID REFERENCES chaty(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  reservation_id UUID REFERENCES reservations(id) ON DELETE SET NULL,
  
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title VARCHAR(255),
  comment TEXT,
  
  -- Hodnocení detailů
  cleanliness_rating INTEGER CHECK (cleanliness_rating >= 1 AND cleanliness_rating <= 5),
  location_rating INTEGER CHECK (location_rating >= 1 AND location_rating <= 5),
  value_rating INTEGER CHECK (value_rating >= 1 AND value_rating <= 5),
  
  is_verified BOOLEAN DEFAULT false
);

-- Indexy pro lepší výkon
CREATE INDEX IF NOT EXISTS idx_chaty_region ON chaty(region);
CREATE INDEX IF NOT EXISTS idx_chaty_price ON chaty(price_from);
CREATE INDEX IF NOT EXISTS idx_chaty_published ON chaty(is_published);
CREATE INDEX IF NOT EXISTS idx_chaty_owner ON chaty(owner_id);

CREATE INDEX IF NOT EXISTS idx_reservations_user ON reservations(user_id);
CREATE INDEX IF NOT EXISTS idx_reservations_chata ON reservations(chata_id);
CREATE INDEX IF NOT EXISTS idx_reservations_dates ON reservations(check_in, check_out);
CREATE INDEX IF NOT EXISTS idx_reservations_status ON reservations(status);

CREATE INDEX IF NOT EXISTS idx_favorites_user ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_chata ON favorites(chata_id);

CREATE INDEX IF NOT EXISTS idx_reviews_chata ON reviews(chata_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user ON reviews(user_id);

-- Row Level Security (RLS)
ALTER TABLE chaty ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Policies pro chaty
CREATE POLICY "Chaty jsou viditelné pro všechny" ON chaty
  FOR SELECT USING (is_published = true OR auth.uid() = owner_id);

CREATE POLICY "Majitelé mohou vytvářet chaty" ON chaty
  FOR INSERT WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Majitelé mohou upravovat své chaty" ON chaty
  FOR UPDATE USING (auth.uid() = owner_id);

CREATE POLICY "Majitelé mohou mazat své chaty" ON chaty
  FOR DELETE USING (auth.uid() = owner_id);

-- Policies pro rezervace
CREATE POLICY "Uživatelé vidí své rezervace" ON reservations
  FOR SELECT USING (auth.uid() = user_id OR auth.uid() IN (
    SELECT owner_id FROM chaty WHERE id = reservations.chata_id
  ));

CREATE POLICY "Uživatelé mohou vytvářet rezervace" ON reservations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Uživatelé mohou upravovat své rezervace" ON reservations
  FOR UPDATE USING (auth.uid() = user_id OR auth.uid() IN (
    SELECT owner_id FROM chaty WHERE id = reservations.chata_id
  ));

-- Policies pro oblíbené
CREATE POLICY "Uživatelé vidí své oblíbené" ON favorites
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Uživatelé mohou přidávat oblíbené" ON favorites
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Uživatelé mohou mazat své oblíbené" ON favorites
  FOR DELETE USING (auth.uid() = user_id);

-- Policies pro recenze
CREATE POLICY "Recenze jsou veřejné" ON reviews
  FOR SELECT USING (true);

CREATE POLICY "Uživatelé mohou vytvářet recenze" ON reviews
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Uživatelé mohou upravovat své recenze" ON reviews
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Uživatelé mohou mazat své recenze" ON reviews
  FOR DELETE USING (auth.uid() = user_id);

-- Funkce pro aktualizaci ratingu chaty
CREATE OR REPLACE FUNCTION update_chata_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE chaty
  SET 
    rating = (SELECT AVG(rating) FROM reviews WHERE chata_id = NEW.chata_id),
    reviews_count = (SELECT COUNT(*) FROM reviews WHERE chata_id = NEW.chata_id)
  WHERE id = NEW.chata_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pro automatickou aktualizaci ratingu
CREATE TRIGGER update_chata_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_chata_rating();

-- Funkce pro aktualizaci updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pro updated_at na všech tabulkách
CREATE TRIGGER update_chaty_updated_at BEFORE UPDATE ON chaty
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reservations_updated_at BEFORE UPDATE ON reservations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_reviews_updated_at BEFORE UPDATE ON reviews
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Storage buckets (spusťte v Supabase Dashboard)
-- 1. Vytvořte bucket 'chaty-images' (public)
-- 2. Vytvořte bucket 'user-avatars' (public)

-- Storage policies se nastavují v Supabase Dashboard
