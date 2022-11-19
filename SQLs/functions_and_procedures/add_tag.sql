DROP PROCEDURE IF EXISTS add_tag;
CREATE PROCEDURE add_tag(IN field_id INT, IN post_id INT, IN tag TEXT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    tag_id INT;
BEGIN
    SELECT id INTO tag_id FROM "StackExchange".tags WHERE tags.tagname = tag;
    IF tag_id IS NULL THEN
        INSERT INTO "StackExchange".tags(fieldid, id, tagname, count)
        VALUES (field_id, (SELECT MAX(id) + 1 FROM "StackExchange".tags), tag, 1);
        SELECT id INTO tag_id FROM "StackExchange".tags WHERE tags.tagname = tag;
    END IF;
    INSERT INTO "StackExchange".post_tags(fieldid, postid, tagid)
    VALUES (field_id, post_id, tag_id);
    UPDATE "StackExchange".tags SET count = count + 1 WHERE id = tag_id;
END;
$$;


CREATE PROCEDURE remove_tag(IN field_id INT, IN post_id INT, IN tag TEXT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    tag_id INT;
BEGIN
    SELECT id INTO tag_id FROM "StackExchange".tags WHERE tags.tagname = tag;
    DELETE FROM "StackExchange".post_tags WHERE fieldid = field_id AND postid = post_id AND tagid = tag_id;
    UPDATE "StackExchange".tags SET count = count - 1 WHERE id = tag_id;
END;
$$;
