-- Profanity
CREATE TABLE IF NOT EXISTS profanity
(
    id   SERIAL PRIMARY KEY,
    word VARCHAR(255) NOT NULL
);

-- fields, Common
CREATE TABLE IF NOT EXISTS fields
(
    FieldId     SERIAL PRIMARY KEY, -- field of expertise
    Description TEXT                -- description of field
);