CREATE OR REPLACE FUNCTION posts_profanity_trigger_proc() RETURNS trigger AS
$$
BEGIN
    IF ("Common".check_profanity(NEW.body) = false)
        OR ("Common".check_profanity(NEW.title) = false)
        OR ("Common".check_profanity(NEW.tags) = false) THEN
        -- if already banned, extend ban
        IF (check_banned(NEW.fieldid, NEW.owneruserid)) THEN
            UPDATE user_bans
            SET bandate     = extract(epoch from now()),
                baninterval = 24 * 3600
            WHERE user_bans.userid = NEW.owneruserid
              AND user_bans.fieldid = NEW.fieldid;
        ELSE
            INSERT INTO "StackExchange".user_bans(fieldid, userid, bandate, baninterval, banreason)
            VALUES (NEW.fieldid, NEW.owneruserid, extract(epoch from now()), 24 * 3600, 'Post Profanity');
        END IF;

        -- replace post body with profanity warning
        NEW.body = 'This post has been removed due to profanity.';
        NEW.title = 'Post Removed';
        NEW.tags = 'removed';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER posts_profanity_trigger
    BEFORE INSERT OR UPDATE
    ON "StackExchange".posts
    FOR EACH ROW
EXECUTE PROCEDURE posts_profanity_trigger_proc();


-- CREATE OR REPLACE FUNCTION users_profanity_trigger_proc() RETURNS trigger AS
-- $$
-- BEGIN
--     IF ("Common".check_profanity(NEW.displayname) = false) THEN
--         -- if already banned, extend ban
--         IF EXISTS(SELECT 1
--                   FROM "StackExchange".user_bans
--                   WHERE userid = NEW.id
--                     AND fieldid = NEW.fieldid) THEN
--             UPDATE "StackExchange".user_bans
--             SET bandate     = extract(epoch from now()),
--                 baninterval = 24 * 3600
--             WHERE userid = NEW.id
--               AND fieldid = NEW.fieldid;
--         ELSE
--             -- ban user for 1 day
--             INSERT INTO "StackExchange".user_bans(fieldid, userid, bandate, baninterval, banreason)
--             VALUES (NEW.fieldid, NEW.id, extract(epoch from now()), 24 * 3600, 'User Profanity');
--         END IF;
--         NEW.displayname = 'This user has been banned due to profanity.';
--     END IF;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;
--
-- -- users_profanity_trigger to prevent profanity in user names
-- CREATE OR REPLACE TRIGGER users_profanity_trigger
--     BEFORE INSERT OR UPDATE
--     ON "StackExchange".users
--     FOR EACH ROW
-- EXECUTE PROCEDURE users_profanity_trigger_proc();


CREATE OR REPLACE FUNCTION comments_profanity_trigger_proc() RETURNS trigger AS
$$
BEGIN
    IF ("Common".check_profanity(NEW.text) = false) THEN
        -- if already banned, extend ban
        IF check_banned(fieldid,userid) THEN
            UPDATE "StackExchange".user_bans
            SET bandate     = extract(epoch from now()),
                baninterval = 24 * 3600
            WHERE userid = NEW.userid
              AND fieldid = NEW.fieldid;
        ELSE
            -- ban user for 1 day
            INSERT INTO "StackExchange".user_bans(fieldid, userid, bandate, baninterval, banreason)
            VALUES (NEW.fieldid, NEW.userid, extract(epoch from now()), 24 * 3600, 'Comment Profanity');
        END IF;
        NEW.text = 'This comment has been removed due to profanity.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- comments_profanity_trigger to prevent profanity in comments
CREATE OR REPLACE TRIGGER comments_profanity_trigger
    BEFORE INSERT OR UPDATE
    ON "StackExchange".comments
    FOR EACH ROW
EXECUTE PROCEDURE comments_profanity_trigger_proc();