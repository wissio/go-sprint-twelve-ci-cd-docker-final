# Multi-Stage Build [image size 18.27 MB]
# Stage 1: Build stage
FROM golang:alpine AS builder
# Set the working directory
WORKDIR /app
# Download & install necessary the gcc, libc-dev and binutils packages
RUN apk add --no-cache build-base
# Copy and download dependencies
COPY go.* ./
RUN go mod download
# Copy the source code
COPY *.go ./
# Build the Go application
RUN go build -o main .

# Stage 2: Final stage
FROM alpine:latest
# Set the working directory
WORKDIR /app
# Download & install necessary Sqlite libs packages
RUN apk add --no-cache libc6-compat sqlite-libs
# Copy the binary from the build stage
COPY --from=builder app/main .
# Copy the database
COPY tracker.db .
# Set the entrypoint command
CMD ["./main"]


## Uncomment to use One-Stage Build
# Basic One-Stage [image size 1.28 GB]

# From golang:1.22
# # Set the working directory
# WORKDIR /app
# # Copy and download dependencies
# COPY go.* ./
# RUN go mod download
# # Copy the source code
# COPY . .
# # Build the Go application
# RUN go build -o main .
# # Set the entrypoint command
# CMD ["./main"]
