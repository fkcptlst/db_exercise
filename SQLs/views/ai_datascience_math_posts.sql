CREATE OR REPLACE VIEW ai_posts_view AS
SELECT fieldid,
       id,
       posttypeid,
       acceptedanswerid,
       creationdate,
       score,
       viewcount,
       body,
       owneruserid,
       lasteditoruserid,
       lasteditdate,
       lastactivitydate,
       title,
       tags,
       answercount,
       commentcount,
       favoritecount,
       contentlicense,
       parentid,
       closeddate,
       communityowneddate,
       lasteditordisplayname,
       ownerdisplayname
FROM "StackExchange".posts
WHERE fieldid = 1;

CREATE OR REPLACE VIEW datascience_posts_view AS
SELECT fieldid,
       id,
       posttypeid,
       acceptedanswerid,
       creationdate,
       score,
       viewcount,
       body,
       owneruserid,
       lasteditoruserid,
       lasteditdate,
       lastactivitydate,
       title,
       tags,
       answercount,
       commentcount,
       favoritecount,
       contentlicense,
       parentid,
       closeddate,
       communityowneddate,
       lasteditordisplayname,
       ownerdisplayname
FROM "StackExchange".posts
WHERE fieldid = 2;

CREATE OR REPLACE  VIEW math_posts_view AS
SELECT fieldid,
       id,
       posttypeid,
       acceptedanswerid,
       creationdate,
       score,
       viewcount,
       body,
       owneruserid,
       lasteditoruserid,
       lasteditdate,
       lastactivitydate,
       title,
       tags,
       answercount,
       commentcount,
       favoritecount,
       contentlicense,
       parentid,
       closeddate,
       communityowneddate,
       lasteditordisplayname,
       ownerdisplayname
FROM "StackExchange".posts
WHERE fieldid = 3;

CREATE OR REPLACE VIEW post_scores_normalized AS
SELECT fieldid,
       id,
       (score - AVG(score) OVER (PARTITION BY fieldid)) / STDDEV(score) OVER (PARTITION BY fieldid) AS normalized_score
FROM "StackExchange".posts;

CREATE OR REPLACE VIEW top_score_posts_of_all_time AS
SELECT fieldid,
       id,
       posttypeid,
       acceptedanswerid,
       creationdate,
       score,
       viewcount,
       body,
       owneruserid,
       lasteditoruserid,
       lasteditdate,
       lastactivitydate,
       title,
       tags,
       answercount,
       commentcount,
       favoritecount,
       contentlicense,
       parentid,
       closeddate,
       communityowneddate,
       lasteditordisplayname,
       ownerdisplayname
FROM "StackExchange".posts
ORDER BY (SELECT normalized_score
          FROM post_scores_normalized
          WHERE post_scores_normalized.id = posts.id
            AND post_scores_normalized.fieldid = posts.fieldid)
        DESC
LIMIT 100;

CREATE OR REPLACE VIEW top_score_posts_of_the_week AS
SELECT fieldid,
       id,
       posttypeid,
       acceptedanswerid,
       creationdate,
       score,
       viewcount,
       body,
       owneruserid,
       lasteditoruserid,
       lasteditdate,
       lastactivitydate,
       title,
       tags,
       answercount,
       commentcount,
       favoritecount,
       contentlicense,
       parentid,
       closeddate,
       communityowneddate,
       lasteditordisplayname,
       ownerdisplayname
FROM "StackExchange".posts
WHERE (lastactivitydate >= (extract(epoch from now()) - 604800))
ORDER BY (SELECT normalized_score
          FROM post_scores_normalized
          WHERE post_scores_normalized.id = posts.id
            AND post_scores_normalized.fieldid = posts.fieldid)
        DESC
LIMIT 100;