FROM nimlang/nim:latest-alpine-slim

COPY . .
RUN ["sh", "build.sh"]

CMD ["./nimcache/aoc"]
