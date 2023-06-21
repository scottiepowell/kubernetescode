# syntax=docker/dockerfile:1

# Build stage
FROM arm64v8/python:3.9.17-slim-bullseye AS build

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

# Runtime stage
FROM arm64v8/python:3.9.17-slim-bullseye AS runtime

WORKDIR /app

COPY --from=build /app .

CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0"]

