# Changelog

## v3.1.1 (2026-11-23)

- First release of the Railway template: Moodist v3.1.1, official image pinned by version and digest (`ghcr.io/remvze/moodist:v3.1.1@sha256:44367c9c…4b93`).
- Caddy listens on `PORT` (default 8080), with an open `/healthz` health path, compression, cache headers for hashed assets and the admin API turned off.
- Optional HTTP basic auth with `BASIC_AUTH_USERNAME` and `BASIC_AUTH_PASSWORD` (both needed; one alone stops the deploy with an error).
