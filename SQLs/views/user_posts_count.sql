CREATE OR REPLACE VIEW user_posts_count_view AS
SELECT owneruserid,
       COUNT(*) AS posts_count
FROM (SELECT *
      FROM posts
      WHERE (extract(epoch from now()) - lastactivitydate < 604800) -- a week
     ) AS weekly_posts
GROUP BY owneruserid
ORDER BY posts_count DESC;