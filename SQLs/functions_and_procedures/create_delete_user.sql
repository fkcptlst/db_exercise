-- procedure for create a new user
-- drop procedure if exists create_user;
CREATE OR REPLACE PROCEDURE create_user(IN in_field_id INT,
                                        IN in_creation_date INT,
                                        IN in_display_name TEXT,
                                        IN in_username TEXT,
                                        IN in_password TEXT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    user_id INT;
BEGIN
    -- get the largest user id
    SELECT MAX(id) INTO user_id FROM "StackExchange".users;
    user_id := user_id + 1;
    -- insert the new user
    INSERT INTO "StackExchange".users(id, fieldid, creationdate, displayname)
    VALUES (user_id, in_field_id, in_creation_date, in_display_name);
    -- insert the new user's credentials
    INSERT INTO "StackExchange".user_credentials(fieldid, userid, username, password)
    VALUES (in_field_id, user_id, in_username, in_password);

END;
$$;

-- procedure for deleting a user
-- drop procedure if exists delete_user;
CREATE OR REPLACE PROCEDURE delete_user(IN field_id INT,
                                        IN user_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    --     -- delete the user's credentials
-- Now implemented as a trigger
--     DELETE
--     FROM "StackExchange".user_credentials
--     WHERE fieldid = field_id
--       AND userid = user_id;
    -- delete the user
    DELETE
    FROM "StackExchange".users
    WHERE fieldid = field_id
      AND id = user_id;
END;
$$;