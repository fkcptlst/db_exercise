CREATE OR REPLACE FUNCTION verify_login(user_name text, pass_word text)
    RETURNS boolean
    LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN EXISTS(SELECT 1
                  FROM "StackExchange".user_credentials
                  WHERE user_credentials.username = user_name
                    AND user_credentials.password = pass_word);
END;
$$;