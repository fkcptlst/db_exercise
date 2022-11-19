CREATE OR REPLACE FUNCTION assign_badges_proc() RETURNS trigger AS
$$
DECLARE
    new_badge_id integer;
    upvots_cnt   integer;
    downvots_cnt integer;
    now_time     integer;

BEGIN
    -- Get upvotes for the post
    SELECT upvotes
    INTO upvots_cnt
    FROM users
    WHERE id = NEW.id
      AND fieldid = NEW.fieldid;

    -- Get downvotes for the post
    SELECT downvotes
    INTO downvots_cnt
    FROM users
    WHERE id = NEW.id
      AND fieldid = NEW.fieldid;

    SELECT max(id) + 1 INTO new_badge_id FROM badges;

    -- Get current time
    SELECT EXTRACT(EPOCH FROM now())
    INTO now_time;

    IF upvots_cnt > 100 THEN
        -- Update the badge table
        INSERT INTO badges(fieldid, id, userid, name, date, class, tagbased)
        VALUES (NEW.fieldid, new_badge_id, NEW.id, 'Teacher', now_time, 1, 0);
    ELSEIF upvots_cnt > 500 THEN
        -- Update the badge table
        INSERT INTO badges(fieldid, id, userid, name, date, class, tagbased)
        VALUES (NEW.fieldid, new_badge_id, NEW.id, 'Master', now_time, 1, 0);
    -- And so on
    END IF;
END ;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER badges_trigger
    AFTER UPDATE
    ON "StackExchange".users
    FOR EACH ROW
EXECUTE PROCEDURE assign_badges_proc();