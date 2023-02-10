FROM passsy/flutterw:base-latest
COPY . .
RUN ./flutterw config --no-analytics
ENTRYPOINT ./flutterw run --release --web-port=80 --web-hostname 0.0.0.0 -d web-server
EXPOSE 80