# data_app

## Project Status

This project is currently in progress. The initial structure and core UI have been implemented to prepare for further development.


## Completed Work

- Application design has been completed

- Home screen has been fully implemented

- Test (mock) data has been integrated to support UI development and validation

## Next Steps

Connect real backend data

Implement remaining screens

---

## Deploying to Railway (Web)

This app is configured to run as a web app on [Railway](https://railway.app).

### How it works

- **Dockerfile**: Multi-stage build that (1) builds the Flutter web app with `flutter build web`, then (2) serves the static files with `serve` on the port Railway provides (`$PORT`).
- **railway.toml**: Deploy settings (healthcheck, restart policy).
- **.dockerignore**: Keeps the Docker build context small.

### Deploy steps

1. Push this repo to GitHub (or connect another Git provider).
2. In [Railway](https://railway.app), create a new project and choose **Deploy from GitHub repo**.
3. Select this repository. Railway will detect the Dockerfile and build the app.
4. After the build finishes, open your service → **Settings** → **Networking** and click **Generate domain** so the app gets a public URL (e.g. `https://your-app.up.railway.app`).
5. Open the generated URL in a browser to use the web app.

### Local Docker build (optional)

```bash
docker build -t data_app .
docker run -p 8080:8080 -e PORT=8080 data_app
```

Then open http://localhost:8080.
