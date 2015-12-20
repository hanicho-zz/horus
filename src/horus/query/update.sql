-- name: update-seen<!
UPDATE hosts
SET last_seen = current_timestamp
WHERE host = :host;

-- name: update-tlsp<!
UPDATE hosts
SET tlsp = True
WHERE host = :host;

-- name: update-registeredp<!
UPDATE nicks
SET registeredp = True
WHERE host = :host AND nick = :nick;
