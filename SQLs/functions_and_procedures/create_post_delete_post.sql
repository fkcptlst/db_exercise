-- procedure for creating a new post
CREATE OR REPLACE PROCEDURE create_new_post(
    IN in_field_id INT,
    IN in_title TEXT,
    IN in_tags TEXT,
    IN in_body TEXT,
    IN in_author_id INT,
    IN in_date INT
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_post_id        INT;
    owner_display_name TEXT;
BEGIN
    IF NOT check_banned(in_field_id, in_author_id) THEN
        -- get the next post id
        SELECT max(id) + 1 INTO new_post_id FROM "StackExchange".posts;
        -- get the display name of the author
        SELECT displayname
        INTO owner_display_name
        FROM "StackExchange".users
        WHERE id = in_author_id
          AND fieldid = in_field_id;
        -- insert the new post
        INSERT INTO "StackExchange".posts (id, fieldid, title, tags, body, owneruserid, creationdate, ownerdisplayname,
                                           lasteditdate, lastactivitydate)
        VALUES (new_post_id, in_field_id, in_title, in_tags, in_body, in_author_id, in_date, owner_display_name,
                in_date, in_date);
    ELSE
        RAISE EXCEPTION 'User is banned from talking';
    END IF;
END;
$$;

-- procedure for answering a post
CREATE OR REPLACE PROCEDURE answer_post(
    IN in_field_id INT,
    IN in_post_id INT,
    IN in_body TEXT,
    IN in_author_id INT,
    IN in_date INT
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    new_answer_id      INT;
    owner_display_name TEXT;
BEGIN
    IF NOT check_banned(in_field_id, in_author_id) THEN
        -- get the next answer id
        SELECT max(id) + 1 INTO new_answer_id FROM "StackExchange".posts;
        -- get the display name of the author
        SELECT displayname
        INTO owner_display_name
        FROM "StackExchange".users
        WHERE id = in_author_id
          AND fieldid = in_field_id;
        -- insert the new answer
        INSERT INTO "StackExchange".posts (id, fieldid, parentid, body, owneruserid, creationdate, ownerdisplayname,
                                           lasteditdate, lastactivitydate)
        VALUES (new_answer_id, in_field_id, in_post_id, in_body, in_author_id, in_date, owner_display_name, in_date,
                in_date);
    ELSE
        RAISE EXCEPTION 'User is banned from talking';
    END IF;
END;
$$;

-- procedure for deleting a post
CREATE OR REPLACE PROCEDURE delete_post(
    IN in_field_id INT,
    IN in_post_id INT
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    -- delete the post
    DELETE
    FROM "StackExchange".posts
    WHERE id = in_post_id
      AND fieldid = in_field_id;
END;
$$;


-- procedure for altering a post
CREATE OR REPLACE PROCEDURE alter_post(
    IN in_field_id INT,
    IN in_post_id INT,
    IN in_title TEXT,
    IN in_tags TEXT,
    IN in_body TEXT,
    IN in_author_id INT,
    IN in_date INT
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    IF NOT check_banned(in_field_id, in_author_id) THEN
        -- insert the new answer
        UPDATE "StackExchange".posts
        SET body             = in_body,
            title            = in_title,
            tags             = in_tags,
            lasteditdate     = in_date,
            lastactivitydate = in_date
        WHERE id = in_post_id
          AND fieldid = in_field_id;
    ELSE
        RAISE EXCEPTION 'User is banned from talking';
    END IF;
END;
$$;
