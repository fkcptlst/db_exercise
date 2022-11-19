-- post content mustn't be empty
ALTER TABLE posts
    ADD CONSTRAINT posts_content_not_empty
        CHECK (body <> '');

-- post content mustn't be longer than 1000 characters
ALTER TABLE posts
    ADD CONSTRAINT posts_content_length
        CHECK (char_length(body) <= 60000);

-- -- post content mustn't contain profanity, as defined in the profanity table in Common
-- ALTER TABLE posts
--     ADD CONSTRAINT posts_content_no_profanity
--         CHECK ("Common".check_profanity(body));
