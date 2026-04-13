FROM --platform=$TARGETPLATFORM golang:1.26-bookworm AS builder

WORKDIR /src
COPY . .

RUN CGO_ENABLED=1 make release

FROM --platform=$TARGETPLATFORM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/build/bin/aws_signing_helper /usr/local/bin/

USER 65532:65532

ENTRYPOINT ["/usr/local/bin/aws_signing_helper"]
