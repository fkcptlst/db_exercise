CREATE
    OR REPLACE FUNCTION star_trigger_proc() RETURNS trigger AS
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE "StackExchange".posts
        SET favoritecount = CASE WHEN favoritecount ISNULL THEN 1 ELSE favoritecount + 1 END
        WHERE id = NEW.postid
          AND fieldid = NEW.fieldid;
    ELSEIF TG_OP = 'DELETE' THEN
        UPDATE "StackExchange".posts
        SET favoritecount = CASE WHEN favoritecount > 0 THEN favoritecount - 1 ELSE 0 END
        WHERE id = OLD.postid
          AND fieldid = OLD.fieldid;
    END IF;
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE
    OR REPLACE TRIGGER star_trigger
    AFTER INSERT OR DELETE
    ON "StackExchange".user_starred
    FOR EACH ROW
EXECUTE PROCEDURE star_trigger_proc();