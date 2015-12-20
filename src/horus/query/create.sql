-- name: create-hosts!
CREATE TABLE hosts (
       host varchar(255) UNIQUE NOT NULL,
       last_seen timestamp DEFAULT current_timestamp,
       tlsp boolean DEFAULT False
);

-- name: create-nicks!
CREATE TABLE nicks (
       host varchar(255) NOT NULL,
       nick varchar(50) NOT NULL,
       registeredp boolean DEFAULT False
);

-- name: create-usernames!
CREATE TABLE usernames (
       host varchar(255) NOT NULL,
       nick varchar(30) NOT NULL,
       username varchar(10) NOT NULL
);

-- name: create-realnames!
CREATE TABLE realnames (
       host varchar(255) NOT NULL,
       nick varchar(30) NOT NULL,
       realname varchar(50) NOT NULL
);

-- name: create-channels!
CREATE TABLE channels (
       host varchar(255) NOT NULL,
       nick varchar(30) NOT NULL,
       channel varchar(35) NOT NULL
);
