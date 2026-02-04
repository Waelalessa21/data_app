# Stage 1: Build Flutter web app
FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

# Copy pubspec files first for better layer caching
COPY pubspec.yaml pubspec.lock ./
COPY analysis_options.yaml ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the app
COPY . .

# Build for web (release mode)
RUN flutter build web --release

# Stage 2: Serve static files (Railway sets PORT)
FROM node:20-alpine

WORKDIR /app

# Copy built web assets from builder
COPY --from=builder /app/build/web ./

# Install serve to serve static files and handle SPA routing
RUN npm install -g serve

# Railway injects PORT at runtime; default for local runs
ENV PORT=8080

EXPOSE 8080

# Serve with SPA fallback so client-side routing works
CMD ["sh", "-c", "serve -s . -l $PORT"]
