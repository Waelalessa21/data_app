FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
COPY analysis_options.yaml ./

RUN flutter pub get

COPY . .

# Build as root; Flutter SDK in image is owned by root and needs write access to its cache
RUN flutter build web --release --no-tree-shake-icons

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/build/web ./

RUN npm install -g serve

ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "serve -s . -l $PORT"]
