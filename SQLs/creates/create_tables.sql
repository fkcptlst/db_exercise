-- users
CREATE TABLE IF NOT EXISTS users
(
    FieldId         INTEGER, -- field of expertise
    Id              SERIAL,
    Reputation      INTEGER          DEFAULT 0,
    CreationDate    INTEGER,
    DisplayName     TEXT,
    LastAccessDate  INTEGER,
    Location        TEXT,
    AboutMe         TEXT,
    Views           INTEGER,
    UpVotes         INTEGER,
    DownVotes       INTEGER,
    AccountId       INTEGER,
    ProfileImageUrl TEXT,
    WebsiteUrl      TEXT,
    PRIMARY KEY (FieldId, Id),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (fieldid)
);

-- badges
CREATE TABLE IF NOT EXISTS badges
(
    FieldId  INTEGER,
    Id       INTEGER,
    UserId   INTEGER,
    Name     TEXT,
    Date     INTEGER,
    Class    INTEGER,
    TagBased TEXT,
    PRIMARY KEY (FieldId, Id),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (fieldid),
    FOREIGN KEY (FieldId, UserId) REFERENCES users (FieldId, Id)
        ON DELETE CASCADE -- DEFERRABLE INITIALLY IMMEDIATE
);

-- posts
CREATE TABLE IF NOT EXISTS posts
(
    FieldId               INTEGER, -- field of expertise
    Id                    INTEGER,
    PostTypeId            INTEGER,
    AcceptedAnswerId      INTEGER,
    CreationDate          INTEGER,
    Score                 INTEGER,
    ViewCount             INTEGER,
    Body                  TEXT,
    OwnerUserId           INTEGER,
    LastEditorUserId      INTEGER,
    LastEditDate          INTEGER,
    LastActivityDate      INTEGER,
    Title                 TEXT,
    Tags                  TEXT,
    AnswerCount           INTEGER,
    CommentCount          INTEGER,
    FavoriteCount         INTEGER,
    ContentLicense        TEXT,
    ParentId              INTEGER,
    ClosedDate            INTEGER,
    CommunityOwnedDate    INTEGER,
    LastEditorDisplayName TEXT,
    OwnerDisplayName      TEXT,
    PRIMARY KEY (FieldId, Id),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (fieldid),
    FOREIGN KEY (FieldId, AcceptedAnswerId) REFERENCES posts (FieldId, Id),
--         ON DELETE SET NULL ,-- DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (FieldId, LastEditorUserId) REFERENCES users (FieldId, Id),
--         ON DELETE SET NULL ,-- DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (FieldId, OwnerUserId) REFERENCES users (FieldId, Id),
--         ON DELETE SET NULL ,-- DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (FieldId, ParentId) REFERENCES posts (FieldId, Id)
--         ON DELETE SET NULL -- DEFERRABLE INITIALLY IMMEDIATE
);

-- comments
CREATE TABLE IF NOT EXISTS comments
(
    FieldId         INTEGER, -- field of expertise
    Id              INTEGER,
    PostId          INTEGER,
    Score           INTEGER DEFAULT 0,
    Text            TEXT,
    CreationDate    INTEGER,
    UserDisplayName TEXT,
    UserId          INTEGER,
    ContentLicense  TEXT,
    PRIMARY KEY (FieldId, Id),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (fieldid),
    FOREIGN KEY (FieldId, PostId) REFERENCES posts (FieldId, Id)
        ON DELETE CASCADE ,-- DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (FieldId, UserId) REFERENCES users (FieldId, Id)
        ON DELETE SET NULL -- DEFERRABLE INITIALLY IMMEDIATE
);

-- posthistory
CREATE TABLE IF NOT EXISTS posthistory
(
    FieldId           INTEGER, -- field of expertise
    Id                INTEGER,
    PostHistoryTypeId INTEGER,
    PostId            INTEGER,
    RevisionGUID      TEXT,
    CreationDate      INTEGER,
    UserId            INTEGER,
    Text              TEXT,
    ContentLicense    TEXT,
    Comment           TEXT,
    UserDisplayName   TEXT,
    PRIMARY KEY (FieldId, Id),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (fieldid),
    FOREIGN KEY (FieldId, PostId) REFERENCES posts (FieldId, Id)
        ON DELETE CASCADE ,-- DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (FieldId, UserId) REFERENCES users (FieldId, Id)
        ON DELETE SET NULL -- DEFERRABLE INITIALLY IMMEDIATE
);

-- postlinks
CREATE TABLE IF NOT EXISTS postlinks
(
    FieldId       INTEGER, -- field of expertise
    Id            INTEGER,
    CreationDate  INTEGER,
    PostId        INTEGER,
    RelatedPostId INTEGER,
    LinkTypeId    INTEGER,
    PRIMARY KEY (FieldId, Id),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (fieldid),
    FOREIGN KEY (FieldId, PostId) REFERENCES posts (FieldId, Id)
        ON DELETE SET NULL ,-- DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (FieldId, RelatedPostId) REFERENCES posts (FieldId, Id)
        ON DELETE SET NULL -- DEFERRABLE INITIALLY IMMEDIATE
);

-- tags
CREATE TABLE IF NOT EXISTS tags
(
    FieldId       INTEGER, -- field of expertise
    Id            INTEGER,
    TagName       TEXT,
    Count         INTEGER,
    ExcerptPostId INTEGER,
    WikiPostId    INTEGER,
    PRIMARY KEY (FieldId, Id),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (fieldid),
    FOREIGN KEY (FieldId, ExcerptPostId) REFERENCES posts (FieldId, Id)
        ON DELETE SET NULL ,-- DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (FieldId, WikiPostId) REFERENCES posts (FieldId, Id)
        ON DELETE SET NULL -- DEFERRABLE INITIALLY IMMEDIATE
);

-- votes
CREATE TABLE IF NOT EXISTS votes
(
    FieldId      INTEGER, -- field of expertise
    Id           INTEGER,
    PostId       INTEGER,
    VoteTypeId   INTEGER,
    CreationDate INTEGER,
    UserId       INTEGER,
    BountyAmount INTEGER,
    PRIMARY KEY (FieldId, Id),
    FOREIGN KEY (FieldId) REFERENCES "Common".fields (fieldid),
    FOREIGN KEY (FieldId, PostId) REFERENCES posts (FieldId, Id)
        ON DELETE CASCADE ,-- DEFERRABLE INITIALLY IMMEDIATE,
    FOREIGN KEY (FieldId, UserId) REFERENCES users (FieldId, Id)
        ON DELETE SET NULL -- DEFERRABLE INITIALLY IMMEDIATE
);