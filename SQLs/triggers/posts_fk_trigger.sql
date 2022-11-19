CREATE
    OR REPLACE FUNCTION posts_fk_trigger_proc() RETURNS trigger AS
$$
BEGIN
    -- set acceptedanswerid to null if the post is deleted
    UPDATE "StackExchange".posts
    SET acceptedanswerid = NULL
    WHERE acceptedanswerid = OLD.id
      AND fieldid = OLD.fieldid;

    RETURN OLD;
END;
$$
    LANGUAGE plpgsql;

CREATE
    OR REPLACE TRIGGER posts_fk_trigger
    BEFORE DELETE
    ON "StackExchange".posts
    FOR EACH ROW
EXECUTE PROCEDURE posts_fk_trigger_proc();