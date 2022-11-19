-- procedure for creating a comment
drop procedure if exists create_comment;
CREATE PROCEDURE create_comment(
    IN in_field_id INT,
    IN in_post_id INT,
    IN in_user_id INT,
    IN in_comment_text TEXT,
    IN in_comment_date INT
)
    LANGUAGE plpgsql
AS
$$
DECLARE
    comment_id        INT;
    user_display_name TEXT;
BEGIN
    -- get comment id
    SELECT max(id) + 1 INTO comment_id FROM "StackExchange".comments;
    IF comment_id IS NULL THEN
        comment_id := 1;
    END IF;
    -- get user display name
    SELECT displayname
    INTO user_display_name
    FROM "StackExchange".users
    WHERE id = in_user_id AND fieldid = in_field_id;

    -- insert comment
    INSERT INTO "StackExchange".comments(id,fieldid,postid,userid,text,creationdate,userdisplayname)
    VALUES(comment_id,in_field_id,in_post_id,in_user_id,in_comment_text,in_comment_date,user_display_name);
END;
$$;

-- procedure for deleting a comment
drop procedure if exists delete_comment;
CREATE PROCEDURE delete_comment(
    IN in_field_id INT,
    IN in_comment_id INT
)
    LANGUAGE plpgsql
AS
$$
BEGIN
    DELETE FROM "StackExchange".comments
    WHERE id = in_comment_id AND fieldid = in_field_id;
END;
$$;