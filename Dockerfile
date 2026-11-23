# Moodist for Railway: the official image, pinned by version and digest.
# Upstream: https://github.com/remvze/moodist (MIT). Image: https://github.com/remvze/moodist/pkgs/container/moodist
# The image is Caddy 2.11.4 serving Moodist's static build from /var/www/html.
FROM ghcr.io/remvze/moodist:v3.1.1@sha256:44367c9ca0f1ec93a28dd3715ad39fa8e69e25cb64931ab655f86954c2ee4b93

# Writes the Caddyfile for $PORT, the open /healthz path and optional basic auth,
# then starts Caddy. A bad setting stops the container with a non-zero exit code.
COPY --chmod=755 railway-start.sh /usr/local/bin/railway-start.sh

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
