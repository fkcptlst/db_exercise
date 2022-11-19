-- procedure for starring posts
drop procedure if exists star_post;
CREATE PROCEDURE star_post(IN post_id INT, IN user_id INT, IN field_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    -- add to user starred posts
    INSERT INTO "StackExchange".user_starred (fieldid, postid, userid)
    VALUES (field_id, post_id, user_id);

--     -- update the number of favorites in posts
--     UPDATE "StackExchange".posts
--     SET favoritecount = favoritecount + 1
--     WHERE id = post_id;
END;
$$;

-- procedure for un-starring posts
drop procedure if exists unstar_post;
CREATE PROCEDURE unstar_post(IN post_id INT, IN user_id INT, IN field_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    -- remove from user starred posts
    DELETE FROM "StackExchange".user_starred
    WHERE fieldid = field_id AND postid = post_id AND userid = user_id;
--     -- update the number of favorites in posts
--     UPDATE "StackExchange".posts
--     SET favoritecount = favoritecount - 1
--     WHERE id = post_id AND favoritecount > 0;
END;
$$;