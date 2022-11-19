CREATE OR REPLACE FUNCTION delete_user_credentials() RETURNS trigger AS $$
BEGIN
    DELETE FROM "StackExchange".user_credentials WHERE userid = OLD.id AND fieldid = OLD.fieldid;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER delete_user_credentials_trigger
    AFTER DELETE
    ON "StackExchange".users
    FOR EACH ROW
    EXECUTE PROCEDURE delete_user_credentials();