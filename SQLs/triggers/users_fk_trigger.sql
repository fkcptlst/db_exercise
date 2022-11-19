CREATE
    OR REPLACE FUNCTION users_fk_trigger_proc() RETURNS trigger AS
$$
BEGIN
    -- update "StackExchange".posts table
    UPDATE "StackExchange".posts SET owneruserid = NULL WHERE owneruserid = OLD.id AND fieldid = OLD.fieldid;
    UPDATE "StackExchange".posts SET lasteditoruserid = NULL WHERE lasteditoruserid = OLD.id AND fieldid = OLD.fieldid;
    UPDATE "StackExchange".posts SET owneruserid = NULL WHERE owneruserid = OLD.id AND fieldid = OLD.fieldid;

    -- update comments table
    UPDATE "StackExchange".comments SET userid = NULL WHERE userid = OLD.id AND fieldid = OLD.fieldid;

    RETURN OLD;
END;
$$
    LANGUAGE plpgsql;

CREATE
    OR REPLACE TRIGGER users_fk_trigger
    BEFORE DELETE
    ON "StackExchange".users
    FOR EACH ROW
EXECUTE PROCEDURE users_fk_trigger_proc();