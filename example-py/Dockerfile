FROM python:3-alpine

WORKDIR /src
COPY . .
RUN python -m compileall .

CMD python /src/aoc.py
