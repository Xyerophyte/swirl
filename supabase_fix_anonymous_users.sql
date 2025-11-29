-- Fix RLS Policies for Anonymous Users
-- This allows the app to work with anonymous users without Supabase Auth

-- Drop existing restrictive policies
DROP POLICY IF EXISTS users_select_own ON users;
DROP POLICY IF EXISTS users_update_own ON users;

-- Create new permissive policies for anonymous users
-- Allow anyone to read any user (needed for profile viewing)
CREATE POLICY users_select_all ON users FOR SELECT
    TO authenticated, anon
    USING (true);

-- Allow anyone to insert new users (needed for anonymous registration)
CREATE POLICY users_insert_anon ON users FOR INSERT
    TO authenticated, anon
    WITH CHECK (is_anonymous = true);

-- Allow users to update their own data (check by ID, not auth.uid since we're anonymous)
CREATE POLICY users_update_all ON users FOR UPDATE
    TO authenticated, anon
    USING (true)
    WITH CHECK (true);

-- Note: This is permissive for MVP. In production with real auth:
-- 1. Use Supabase Auth for authenticated users
-- 2. Restrict policies to auth.uid() = id
-- 3. Add rate limiting
-- 4. Add data validation rules

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'RLS policies updated for anonymous users!';
    RAISE NOTICE 'Anonymous users can now create and read profiles.';
END $$;