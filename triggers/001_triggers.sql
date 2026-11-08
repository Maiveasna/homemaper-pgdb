-- Purpose: attach set_updated_at() to every table that has updated_at.
-- Postgres has no "ON UPDATE CURRENT_TIMESTAMP", so triggers replace it.
DROP TRIGGER IF EXISTS trg_tenant_updated_at ON "Tenant";
CREATE TRIGGER trg_tenant_updated_at
  BEFORE UPDATE ON "Tenant"
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_user_updated_at ON "User";
CREATE TRIGGER trg_user_updated_at
  BEFORE UPDATE ON "User"
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS trg_order_updated_at ON "Order";
CREATE TRIGGER trg_order_updated_at
  BEFORE UPDATE ON "Order"
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
