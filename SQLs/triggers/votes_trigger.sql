-- CREATE OR REPLACE FUNCTION upvotes_trigger_proc() RETURNS trigger AS $upvotes_trigger_proc$
-- BEGIN
--     IF (TG_OP = 'INSERT') THEN
--         UPDATE "StackExchange".users
--         SET upvotes = CASE WHEN upvotes IS NULL THEN upvotes = 1 ELSE upvotes = upvotes + 1 END
--         WHERE id = NEW.user_id;
--     ELSIF (TG_OP = 'DELETE') THEN
--         UPDATE "StackExchange".users
--         SET upvotes = CASE WHEN upvotes IS NULL THEN upvotes = 0 ELSE upvotes = upvotes - 1 END
--         WHERE id = OLD.user_id;
--     END IF;
--     RETURN NULL;
-- END;
-- $upvotes_trigger_proc$ LANGUAGE plpgsql;
--
-- CREATE OR REPLACE FUNCTION downvotes_trigger_proc() RETURNS trigger AS $downvotes_trigger_proc$
-- BEGIN
--     IF (TG_OP = 'INSERT') THEN
--         UPDATE "StackExchange".users
--         SET downvotes = CASE WHEN downvotes IS NULL THEN downvotes = 1 ELSE downvotes = downvotes + 1 END
--         WHERE id = NEW.user_id;
--     ELSIF (TG_OP = 'DELETE') THEN
--         UPDATE "StackExchange".users
--         SET downvotes = CASE WHEN downvotes IS NULL THEN downvotes = 0 ELSE downvotes = downvotes - 1 END
--         WHERE id = OLD.user_id;
--     END IF;
--     RETURN NULL;
-- END;
-- $downvotes_trigger_proc$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION votes_trigger_proc() RETURNS trigger AS
$votes_trigger_proc$
BEGIN
    -- if is insert
    IF (TG_OP = 'INSERT') THEN
        -- if is upvote
        IF (NEW.votetypeid = 2) THEN
            UPDATE "StackExchange".users
            SET upvotes = CASE WHEN upvotes IS NULL THEN 1 ELSE upvotes + 1 END
            WHERE id IN (SELECT owneruserid
                        FROM "StackExchange".posts
                        WHERE posts.id = NEW.postid
                          AND posts.fieldid = NEW.fieldid
                        LIMIT 1);
        ELSE
            UPDATE "StackExchange".users
            SET downvotes = CASE WHEN downvotes IS NULL THEN 1 ELSE downvotes + 1 END
            WHERE id IN (SELECT owneruserid
                        FROM "StackExchange".posts
                        WHERE posts.id = NEW.postid
                          AND posts.fieldid = NEW.fieldid
                        LIMIT 1);
        END IF;
        -- if is delete
    ELSIF (TG_OP = 'DELETE') THEN
        -- if is upvote
        IF (OLD.votetypeid = 2) THEN
            UPDATE "StackExchange".users
            SET upvotes = CASE WHEN upvotes IS NULL THEN 0 ELSE upvotes - 1 END
            WHERE id IN (SELECT owneruserid
                        FROM "StackExchange".posts
                        WHERE posts.id = OLD.postid
                          AND posts.fieldid = OLD.fieldid
                        LIMIT 1);
        ELSE
            UPDATE "StackExchange".users
            SET downvotes = CASE WHEN downvotes IS NULL THEN 0 ELSE downvotes - 1 END
            WHERE id IN (SELECT owneruserid
                        FROM "StackExchange".posts
                        WHERE posts.id = OLD.postid
                          AND posts.fieldid = OLD.fieldid
                        LIMIT 1);
        END IF;
    END IF;
    RETURN NEW;
END;
$votes_trigger_proc$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER votes_trigger
    AFTER INSERT OR DELETE
    ON "StackExchange".votes
    FOR EACH ROW
EXECUTE PROCEDURE votes_trigger_proc();