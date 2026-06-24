-- Executado automaticamente na primeira inicialização do PostgreSQL
-- Cria os três bancos separados

CREATE DATABASE ticket_db;
CREATE DATABASE evolution_db;
CREATE DATABASE n8n_db;

GRANT ALL PRIVILEGES ON DATABASE ticket_db    TO postgres;
GRANT ALL PRIVILEGES ON DATABASE evolution_db TO postgres;
GRANT ALL PRIVILEGES ON DATABASE n8n_db       TO postgres;