CREATE OR REPLACE FUNCTION check_profanity(body text)
    RETURNS boolean
    LANGUAGE plpgsql
AS $$
BEGIN
    RETURN NOT EXISTS (SELECT 1 FROM "Common".profanity WHERE body LIKE word); -- True if no profanity
END;
$$;