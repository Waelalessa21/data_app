FROM ghcr.io/cirruslabs/flutter:stable AS builder

WORKDIR /app

RUN adduser --disabled-password --gecos "" flutteruser

COPY pubspec.yaml pubspec.lock ./
COPY analysis_options.yaml ./

RUN flutter pub get

COPY . .

RUN chown -R flutteruser:flutteruser /app

RUN git config --system --add safe.directory /sdks/flutter

USER flutteruser

RUN flutter build web --release --no-tree-shake-icons

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/build/web ./

RUN npm install -g serve

ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "serve -s . -l $PORT"]
