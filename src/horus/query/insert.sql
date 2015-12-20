-- name: insert-host<!
INSERT INTO hosts (host, tlsp)
VALUES (:host, :tlsp);

-- name: insert-nick<!
INSERT INTO nicks (host, nick, registeredp)
VALUES (:host, :nick, :registeredp);

-- name: insert-username<!
INSERT INTO usernames (nick, username)
VALUES (:nick, :username);

-- name: insert-realname<!
INSERT INTO realnames (nick, realname)
VALUES (:nick, :realname);

-- name: insert-channels<!
INSERT INTO channels (nick, channel)
VALUES (:nick, :channel);
