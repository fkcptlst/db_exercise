-- calculate cosine similarity between two semantic vectors
CREATE OR REPLACE FUNCTION calculate_cosine_similarity(
    vector1 DOUBLE PRECISION[],
    vector2 DOUBLE PRECISION[]
) RETURNS DOUBLE PRECISION AS $$
DECLARE
    dot_product DOUBLE PRECISION;
    magnitude1 DOUBLE PRECISION;
    magnitude2 DOUBLE PRECISION;
BEGIN
    dot_product := 0;
    magnitude1 := 0;
    magnitude2 := 0;
    FOR i IN 1..array_length(vector1, 1) LOOP
        dot_product := dot_product + vector1[i] * vector2[i];
        magnitude1 := magnitude1 + vector1[i] * vector1[i];
        magnitude2 := magnitude2 + vector2[i] * vector2[i];
    END LOOP;
    RETURN dot_product / (SQRT(magnitude1) * SQRT(magnitude2));
END;
$$ LANGUAGE plpgsql;