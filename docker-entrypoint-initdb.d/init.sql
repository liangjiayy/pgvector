CREATE EXTENSION IF NOT EXISTS vector;

CREATE SCHEMA IF NOT EXISTS knowledge;

CREATE TABLE IF NOT EXISTS knowledge.vector_data (
    id     SERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL DEFAULT 0,
    file_id BIGINT NOT NULL DEFAULT 0,
    content VARCHAR(65535) NOT NULL DEFAULT '',
    featrue VECTOR(1024),
    created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS vector_data_featrue_idx
    ON knowledge.vector_data
    USING hnsw (featrue vector_cosine_ops);
