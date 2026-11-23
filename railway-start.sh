#!/bin/sh
# Railway wrapper for Moodist: Caddy listens on $PORT, serves an open /healthz for
# Railway's health check, and turns on HTTP basic auth only when both
# BASIC_AUTH_USERNAME and BASIC_AUTH_PASSWORD are set. Safe to run on every start.
set -eu

PORT="${PORT:-8080}"
case "$PORT" in ''|*[!0-9]*) echo "railway-start.sh: PORT must be a number, got '$PORT'" >&2; exit 1 ;; esac

AUTH_BLOCK=""
if [ -n "${BASIC_AUTH_USERNAME:-}" ] && [ -n "${BASIC_AUTH_PASSWORD:-}" ]; then
  case "$BASIC_AUTH_USERNAME" in *[!A-Za-z0-9._@-]*) echo "railway-start.sh: BASIC_AUTH_USERNAME may only use letters, digits and . _ @ -" >&2; exit 1 ;; esac
  HASH=$(printf '%s\n' "$BASIC_AUTH_PASSWORD" | caddy hash-password 2>/dev/null | tail -n 1)
  case "$HASH" in '$2'*) ;; *) echo "railway-start.sh: could not hash BASIC_AUTH_PASSWORD" >&2; exit 1 ;; esac
  AUTH_BLOCK="basic_auth @protected {
		$BASIC_AUTH_USERNAME $HASH
	}"
  echo "railway-start.sh: basic auth on for user $BASIC_AUTH_USERNAME"
elif [ -n "${BASIC_AUTH_USERNAME:-}${BASIC_AUTH_PASSWORD:-}" ]; then
  echo "railway-start.sh: set both BASIC_AUTH_USERNAME and BASIC_AUTH_PASSWORD to turn on basic auth" >&2
  exit 1
fi

cat > /etc/caddy/Caddyfile <<CONF
{
	admin off
	auto_https off
	persist_config off
}

:${PORT} {
	root * /var/www/html
	encode zstd gzip

	@health path /healthz
	handle @health {
		respond "ok" 200
	}

	@protected not path /healthz
	${AUTH_BLOCK}

	@hashed path /_astro/*
	header @hashed Cache-Control "public, max-age=31536000, immutable"

	file_server

	handle_errors 404 {
		rewrite * /index.html
		file_server
	}
}
CONF

caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile >/dev/null 2>&1 || {
  echo "railway-start.sh: generated Caddyfile is invalid" >&2
  caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile >&2 || true
  exit 1
}
echo "railway-start.sh: Moodist listening on port $PORT"
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
