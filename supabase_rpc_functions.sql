-- RPC Functions for Atomic Operations
-- These functions prevent race conditions when updating user statistics

-- Function: Increment user swipes atomically
CREATE OR REPLACE FUNCTION increment_user_swipes(user_id_param UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE users
  SET 
    total_swipes = COALESCE(total_swipes, 0) + 1,
    updated_at = NOW()
  WHERE id = user_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Increment user swirls atomically
CREATE OR REPLACE FUNCTION increment_user_swirls(user_id_param UUID)
RETURNS VOID AS $$
BEGIN
  UPDATE users
  SET 
    total_swirls = COALESCE(total_swirls, 0) + 1,
    updated_at = NOW()
  WHERE id = user_id_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Increment days active (only if it's a new day)
CREATE OR REPLACE FUNCTION increment_days_active(user_id_param UUID)
RETURNS VOID AS $$
DECLARE
  last_seen_date DATE;
  today_date DATE;
BEGIN
  SELECT DATE(last_seen_at) INTO last_seen_date
  FROM users
  WHERE id = user_id_param;
  
  today_date := CURRENT_DATE;
  
  -- Only increment if last seen was a different day
  IF last_seen_date IS NULL OR last_seen_date < today_date THEN
    UPDATE users
    SET 
      days_active = COALESCE(days_active, 0) + 1,
      last_seen_at = NOW(),
      updated_at = NOW()
    WHERE id = user_id_param;
  ELSE
    -- Just update last_seen_at
    UPDATE users
    SET 
      last_seen_at = NOW(),
      updated_at = NOW()
    WHERE id = user_id_param;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Get personalized feed (with ML scoring in future)
-- Currently returns products based on user preferences
CREATE OR REPLACE FUNCTION get_personalized_feed(
  user_id_param UUID,
  style_filters TEXT[] DEFAULT '{}',
  limit_param INT DEFAULT 20,
  offset_param INT DEFAULT 0
)
RETURNS TABLE (
  id UUID,
  name TEXT,
  description TEXT,
  brand TEXT,
  category TEXT,
  gender TEXT,
  style_tags TEXT[],
  color_tags TEXT[],
  price DECIMAL,
  currency TEXT,
  original_price DECIMAL,
  discount_percentage INT,
  image_url TEXT,
  additional_image_urls TEXT[],
  product_url TEXT,
  affiliate_url TEXT,
  in_stock BOOLEAN,
  stock_quantity INT,
  popularity_score DECIMAL,
  rating DECIMAL,
  review_count INT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.name,
    p.description,
    p.brand,
    p.category,
    p.gender,
    p.style_tags,
    p.color_tags,
    p.price,
    p.currency,
    p.original_price,
    p.discount_percentage,
    p.image_url,
    p.additional_image_urls,
    p.product_url,
    p.affiliate_url,
    p.in_stock,
    p.stock_quantity,
    p.popularity_score,
    p.rating,
    p.review_count,
    p.created_at,
    p.updated_at
  FROM products p
  WHERE 
    p.in_stock = TRUE
    -- Apply style filters if provided
    AND (
      CARDINALITY(style_filters) = 0 
      OR p.style_tags && style_filters
    )
    -- Exclude products user already swiped (optional - can be added later)
  ORDER BY 
    p.popularity_score DESC,
    p.created_at DESC
  LIMIT limit_param
  OFFSET offset_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION increment_user_swipes TO authenticated;
GRANT EXECUTE ON FUNCTION increment_user_swirls TO authenticated;
GRANT EXECUTE ON FUNCTION increment_days_active TO authenticated;
GRANT EXECUTE ON FUNCTION get_personalized_feed TO authenticated;

-- Also grant to anon for anonymous users
GRANT EXECUTE ON FUNCTION increment_user_swipes TO anon;
GRANT EXECUTE ON FUNCTION increment_user_swirls TO anon;
GRANT EXECUTE ON FUNCTION increment_days_active TO anon;
GRANT EXECUTE ON FUNCTION get_personalized_feed TO anon;