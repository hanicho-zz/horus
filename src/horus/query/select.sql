-- name: select-ntrack
SELECT (
       hosts.host,
       hosts.last_seen,
       hosts.tlsp,
       nicks.nick,
       nicks.registeredp,
       usernames.username,
       realnames.realname,
       channels.channel
)
FROM hosts, nicks, usernames, realnames, channels
WHERE (
      nicks.nick = :nick AND
      hosts.host = nicks.host AND

      hosts.host = usernames.host AND
      hosts.host = realnames.host AND
      hosts.host = channels.host AND

      nicks.nick = usernames.nick AND
      nicks.nick = realnames.nick AND
      nicks.nick = channels.nick
);

-- name: select-htrack
SELECT (
       hosts.host,
       hosts.last_seen,
       hosts.tlsp,
       nicks.nick,
       nicks.registeredp,
       usernames.username,
       realnames.realname,
       channels.channel
)
FROM hosts, nicks, usernames, realnames, channels
WHERE (
      hosts.host = :host AND
      hosts.host = nicks.host AND

      hosts.host = usernames.host AND
      hosts.host = realnames.host AND
      hosts.host = channels.host AND

      nicks.nick = usernames.nick AND
      nicks.nick = realnames.nick AND
      nicks.nick = channels.nick
);

-- name: fuzzy-ntrack
SELECT (
       hosts.host,
       hosts.last_seen,
       hosts.tlsp,
       nicks.nick,
       nicks.registeredp,
       usernames.username,
       realnames.realname,
       channels.channel
)
FROM hosts, nicks, usernames, realnames, channels
WHERE (
      nicks.nick LIKE :nick AND
      hosts.host = nicks.host AND

      hosts.host = usernames.host AND
      hosts.host = realnames.host AND
      hosts.host = channels.host AND

      nicks.nick = usernames.nick AND
      nicks.nick = realnames.nick AND
      nicks.nick = channels.nick
);

-- name: fuzzy-htrack
SELECT (
       hosts.host,
       hosts.last_seen,
       hosts.tlsp,
       nicks.nick,
       nicks.registeredp,
       usernames.username,
       realnames.realname,
       channels.channel
)
FROM hosts, nicks, usernames, realnames, channels
WHERE (
      hosts.host LIKE :host AND
      hosts.host = nicks.host AND

      hosts.host = usernames.host AND
      hosts.host = realnames.host AND
      hosts.host = channels.host AND

      nicks.nick = usernames.nick AND
      nicks.nick = realnames.nick AND
      nicks.nick = channels.nick
);

-- name: select-count
SELECT count(*) AS count FROM hosts;

-- name: select-host
SELECT * FROM hosts WHERE host = :host;

-- name: select-nick
SELECT * FROM nicks WHERE host = :host AND nick = :nick;

-- name: select-username
SELECT * FROM usernames WHERE host = :host AND nick = :nick AND username = :username

-- name: select-realname
SELECT * FROM realnames WHERE host = :host AND nick = :nick AND realname = :realname

-- name: select-channel
SELECT * FROM channels WHERE host = :host AND nick = :nick AND channel = :channel
