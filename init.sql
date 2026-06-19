CREATE DATABASE documenso_db;

\c koudmain;
CREATE EXTENSION IF NOT EXISTS postgis SCHEMA public;

\c documenso_db;
CREATE EXTENSION IF NOT EXISTS pg_trgm SCHEMA public;