-- Purpose: reusable stored functions.
-- set_updated_at(): keeps updated_at current on every UPDATE (used by triggers).
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
