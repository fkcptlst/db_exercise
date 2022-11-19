-- procedure for upvoting posts
CREATE OR REPLACE PROCEDURE upvote(IN post_id INT, IN field_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    vote_id INT;
    now_time INT;
BEGIN
    SELECT max(id) + 1 INTO vote_id FROM votes;
    SELECT EXTRACT(EPOCH FROM now()) INTO now_time;
    INSERT INTO votes (fieldid, id, postid, votetypeid, creationdate, bountyamount)
    VALUES (field_id, vote_id, post_id, 2, now_time, 0);
END;
$$;

-- procedure for downvoting posts
CREATE OR REPLACE PROCEDURE downvote(IN post_id INT, IN field_id INT)
    LANGUAGE plpgsql
AS
$$
DECLARE
    vote_id INT;
    now_time INT;
BEGIN
    SELECT max(id) + 1 INTO vote_id FROM votes;
    SELECT EXTRACT(EPOCH FROM now()) INTO now_time;

    INSERT INTO votes (fieldid, id, postid, votetypeid, creationdate, bountyamount)
    VALUES (field_id, vote_id, post_id, 3, now_time, 0);
END;
$$;

-- procedure for deleting single upvote, order by creationdate desc
DROP PROCEDURE IF EXISTS delete_upvote;
CREATE PROCEDURE delete_upvote(IN post_id INT, IN field_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    WITH upvote AS (
        SELECT id
        FROM votes
        WHERE postid = post_id
        AND fieldid = field_id
        AND votetypeid = 2
        ORDER BY creationdate DESC
        LIMIT 1
    )
    DELETE FROM votes
    WHERE id = (SELECT id FROM upvote);
END;
$$;

-- procedure for deleting single downvote, order by creationdate desc
DROP PROCEDURE IF EXISTS delete_downvote;
CREATE PROCEDURE delete_downvote(IN post_id INT, IN field_id INT)
    LANGUAGE plpgsql
AS
$$
BEGIN
    WITH downvote AS (
        SELECT id
        FROM votes
        WHERE postid = post_id
        AND fieldid = field_id
        AND votetypeid = 3
        ORDER BY creationdate DESC
        LIMIT 1
    )
    DELETE FROM votes
    WHERE id = (SELECT id FROM downvote);
END;
$$;

