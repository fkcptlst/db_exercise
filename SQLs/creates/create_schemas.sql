-- Common schema
create schema "Common";
comment on schema "Common" is 'stores some common tables';
alter schema "Common" owner to shujuku;

-- schema for StackExchange
create schema "StackExchange";
comment on schema "StackExchange" is 'StackExchange forum';
alter schema "StackExchange" owner to shujuku;

-- -- schema for Mathoverflow
-- create schema "Mathoverflow";
-- comment on schema "Mathoverflow" is 'Mathoverflow forum';
-- alter schema "Mathoverflow" owner to shujuku;
--
-- -- schema for datascience.stackexchange
-- create schema "Datascience";
-- comment on schema "Datascience" is 'Datascience Stackexchange forum';
-- alter schema "Datascience" owner to shujuku;
--
-- -- schema for AI.stackexchange
-- create schema "AI";
-- comment on schema "AI" is 'AI Stackexchange forum';
-- alter schema "AI" owner to shujuku;
--
--     -- schema for AI.stackexchange
-- create schema "AI";
-- comment on schema "AI" is 'AI Stackexchange forum';
-- alter schema "AI" owner to shujuku;
