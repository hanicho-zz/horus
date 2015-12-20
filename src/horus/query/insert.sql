-- name: insert-host<!
INSERT INTO hosts (host, tlsp)
VALUES (:host, :tlsp);

-- name: insert-nick<!
INSERT INTO nicks (host, nick, registeredp)
VALUES (:host, :nick, :registeredp);

-- name: insert-username<!
INSERT INTO usernames (host, nick, username)
VALUES (:host, :nick, :username);

-- name: insert-realname<!
INSERT INTO realnames (host, nick, realname)
VALUES (:host, :nick, :realname);

-- name: insert-channel<!
INSERT INTO channels (host, nick, channel)
VALUES (:host, :nick, :channel);
