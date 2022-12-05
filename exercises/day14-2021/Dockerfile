FROM nimlang/nim:latest-alpine-slim

COPY . .
RUN apk add pcre
RUN ["sh", "build.sh"]

CMD ["./nimcache/aoc"]
