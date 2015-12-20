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
      usernames.nick = nicks.nick AND
      realnames.nick = nicks.nick AND
      channels.nick = nicks.nick
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
      usernames.nick = nicks.nick AND
      realnames.nick = nicks.nick AND
      channels.nick = nicks.nick
);

-- name: select-count
SELECT count(*) AS count FROM hosts;
