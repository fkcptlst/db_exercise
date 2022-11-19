CREATE OR REPLACE FUNCTION check_banned(field_id int, user_id int)
    RETURNS boolean
    LANGUAGE plpgsql
AS $$
BEGIN
    RETURN EXISTS (SELECT 1 FROM "StackExchange".user_bans WHERE userid=user_id AND fieldid=field_id); -- True if banned
END;
$$;