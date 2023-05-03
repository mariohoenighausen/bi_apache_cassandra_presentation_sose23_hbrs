-- Create a keyspace
CREATE KEYSPACE mykeyspace
  WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '3'};

-- Use the keyspace
USE mykeyspace;

-- Create a user-defined type
CREATE TYPE address (
  street text,
  city text,
  state text,
  zip int
);

-- Create a table with a composite partition key, compound clustering key, and clustering order, and a column with a user-defined type
CREATE TABLE users (
  country text,
  state text,
  id int,
  created_at timestamp,
  username text,
  age int,
  address frozen<address>,
  PRIMARY KEY ((country, state), id, created_at, username)
) WITH CLUSTERING ORDER BY (id ASC, created_at DESC, username ASC);

-- Insert data into the table
INSERT INTO users (country, state, id, created_at, username, age, address) VALUES ('USA', 'California', 1, '2023-04-28 10:00:00', 'Alice', 30, {street: '123 Main St', city: 'San Francisco', state: 'CA', zip: 94110});
INSERT INTO users (country, state, id, created_at, username, age, address) VALUES ('USA', 'California', 2, '2023-04-29 09:00:00', 'Bob', 25, {street: '456 Elm St', city: 'Los Angeles', state: 'CA', zip: 90001});
INSERT INTO users (country, state, id, created_at, username, age, address) VALUES ('USA', 'New York', 3, '2023-04-30 08:00:00', 'Charlie', 40, {street: '789 Maple St', city: 'New York', state: 'NY', zip: 10001});

-- Select data from the table
SELECT * FROM users WHERE country = 'USA' AND state = 'California' AND id = 1 AND created_at = '2023-04-28 10:00:00';

-- Create an index on a column
CREATE INDEX users_age ON users (age);

-- Select data using the index
SELECT * FROM users WHERE age > 30;

-- Create a materialized view
CREATE MATERIALIZED VIEW users_by_age AS
  SELECT country, state, id, created_at, username, age
  FROM users
  WHERE age IS NOT NULL AND created_at IS NOT NULL AND username IS NOT NULL
  PRIMARY KEY (age, created_at, username);

-- Select data from the materialized view
SELECT * FROM users_by_age WHERE age > 30;

-- Update data using a conditional statement
UPDATE users SET age = 35 WHERE country = 'USA' AND state = 'California' AND id = 2 AND created_at = '2023-04-29 09:00:00' AND username = 'Bob' IF age = 25;

-- Delete data using a batch statement
BEGIN BATCH
  DELETE FROM users WHERE country = 'USA' AND state = 'California' AND id = 1 AND created_at = '2023-04-28 10:00:00' AND username = 'Alice';
  DELETE FROM users_by_age WHERE age = 30 AND created_at = '2023-04-28 10:00:00' AND username = 'Alice';
APPLY BATCH;
