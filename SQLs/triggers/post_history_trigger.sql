CREATE
    OR REPLACE FUNCTION post_history_trigger_proc() RETURNS trigger AS
$$
DECLARE
    post_history_id INT;
BEGIN
    SELECT MAX(id) + 1 INTO post_history_id FROM "StackExchange".posthistory;
    INSERT INTO "StackExchange".posthistory(fieldid, id, postid, creationdate, text, comment)
    VALUES (OLD.fieldid, post_history_id, OLD.id, extract(epoch from now()), OLD.body, 'altered post');

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;

CREATE
    OR REPLACE TRIGGER post_history_trigger
    AFTER UPDATE
    ON "StackExchange".posts
    FOR EACH ROW
EXECUTE PROCEDURE post_history_trigger_proc();