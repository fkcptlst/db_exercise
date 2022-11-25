CREATE OR REPLACE FUNCTION semantic_query(
    IN num INTEGER,
    IN query_embedding DOUBLE PRECISION[384]
) RETURNS TABLE (
    fieldid INTEGER,
    postid INTEGER,
    similarity DOUBLE PRECISION
) AS $$
    SELECT
        fieldid,
        postid,
        calculate_cosine_similarity(query_embedding, embedding) AS similarity
    FROM semantic_embeddings
    ORDER BY similarity DESC
    LIMIT num
$$ LANGUAGE SQL;