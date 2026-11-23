[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/moodist?utm_medium=integration&utm_source=button&utm_campaign=moodist)

# Moodist on Railway

A one-click Railway template for [Moodist](https://github.com/remvze/moodist) (MIT), an ambient sound mixer for focus and calm: 84 sounds (rain, nature, cafés and other places, noise and more) to layer into your own mix, plus binaural beats, a Pomodoro timer, a countdown, a notepad, a to-do list, breathing exercises and a sleep timer. Everything you set up is kept in the visitor's own browser.

**Version:** Moodist `v3.1.1`, official image `ghcr.io/remvze/moodist:v3.1.1@sha256:44367c9ca0f1ec93a28dd3715ad39fa8e69e25cb64931ab655f86954c2ee4b93` (pinned by version and digest in the [`Dockerfile`](Dockerfile)).

## What it deploys

One service, **Moodist**, built from this repo's `Dockerfile`:

- the official Moodist image (Caddy serving the built static site);
- a small start script, [`railway-start.sh`](railway-start.sh), that makes Caddy listen on Railway's `PORT`, adds an open health path `/healthz`, compresses responses, sets long cache headers for the hashed assets, turns off Caddy's admin API, and switches on optional HTTP basic auth.

There is no database and no volume: Moodist keeps no data on the server. Mixes, presets, notes and to-dos are stored in each visitor's browser (local storage).

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `PORT` | `8080` | Port Caddy listens on; the public domain points at it. |

Nothing to fill in at deploy time. The public URL works as soon as the deploy is healthy.

**Optional login.** Moodist has no accounts. To put the whole site behind a password, add both `BASIC_AUTH_USERNAME` (letters, digits and `. _ @ -`) and `BASIC_AUTH_PASSWORD` to the service's variables and redeploy. The password is hashed (bcrypt) at start; `/healthz` stays open for Railway's health check. Setting only one of the two stops the deploy with an error, so a half-set login never leaves the site open by mistake.

## After you deploy

Open the service's public URL (Settings → Networking) and click the sounds you want. To use your own domain, add it under Settings → Networking → Custom Domain.

## Updates

This template builds from this GitHub repo. When a new Moodist release is out, we bump the pinned image here and add an entry to [`CHANGELOG.md`](CHANGELOG.md). Railway then shows an "update available" notice on your project, and you choose when to apply it. There is no server-side data, so an update can't lose anything.

## Running it elsewhere

```sh
docker build -t moodist .
docker run --rm -p 8080:8080 moodist
```

Upstream self-hosting docs: <https://github.com/remvze/moodist#self-hosting>.
