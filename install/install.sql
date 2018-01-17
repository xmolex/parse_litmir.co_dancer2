CREATE DATABASE `parse` CHARACTER SET utf8 COLLATE utf8_general_ci;
use parse;
CREATE TABLE data
(
  id integer NOT NULL,
  title VARCHAR(255) NOT NULL,
  poster VARCHAR(255),
  rating real DEFAULT 0,
  page integer DEFAULT 0,
  writer VARCHAR(255),
  genres VARCHAR(255),
  lang VARCHAR(30),
  year integer,
  link VARCHAR(1000),
  PRIMARY KEY (id)
);
