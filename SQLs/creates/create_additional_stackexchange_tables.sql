-- user starred, StackExchange
CREATE TABLE IF NOT EXISTS user_starred
(
    FieldId INTEGER,
    UserId  INTEGER,
    PostId  INTEGER,

    PRIMARY KEY (FieldId, UserId, PostId),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (FieldId),
    FOREIGN KEY (FieldId, UserId) REFERENCES users (FieldId, id) ON DELETE CASCADE,
    FOREIGN KEY (FieldId, PostId) REFERENCES posts (FieldId, id) ON DELETE CASCADE
);

-- user login info, StackExchange
CREATE TABLE IF NOT EXISTS user_credentials
(
    FieldId INTEGER NOT NULL,
    UserId  INTEGER NOT NULL UNIQUE,
    UserName  TEXT,
    Password  TEXT NOT NULL,

    PRIMARY KEY (UserName),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (FieldId) ON DELETE CASCADE,
    FOREIGN KEY (FieldId, UserId) REFERENCES users (FieldId, id) ON DELETE CASCADE
);

-- user banned info, StackExchange
CREATE TABLE IF NOT EXISTS user_bans
(
    FieldId INTEGER NOT NULL,
    UserId  INTEGER NOT NULL,
    BanDate  INTEGER NOT NULL,
    BanInterval  INTEGER NOT NULL,
    BanReason  TEXT NOT NULL,

    PRIMARY KEY (FieldId, UserId),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (FieldId) ON DELETE CASCADE,
    FOREIGN KEY (FieldId, UserId) REFERENCES users (FieldId, id) ON DELETE CASCADE
);

-- posttags, StackExchange
CREATE TABLE IF NOT EXISTS post_tags
(
    FieldId INTEGER NOT NULL,
    PostId  INTEGER NOT NULL,
    TagId   INTEGER NOT NULL,

    PRIMARY KEY (FieldId, PostId, TagId),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (FieldId) ON DELETE CASCADE,
    FOREIGN KEY (FieldId, PostId) REFERENCES posts (FieldId, id) ON DELETE CASCADE,
    FOREIGN KEY (FieldId, TagId) REFERENCES tags (FieldId, id) ON DELETE CASCADE
);

-- semantic embeddings, StackExchange
CREATE TABLE IF NOT EXISTS semantic_embeddings
(
    FieldId INTEGER NOT NULL,
    PostId  INTEGER NOT NULL,
    Embedding DOUBLE PRECISION[384] NOT NULL,

    PRIMARY KEY (FieldId, PostId),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (FieldId) ON DELETE CASCADE,
    FOREIGN KEY (FieldId, PostId) REFERENCES posts (FieldId, id) ON DELETE CASCADE
);