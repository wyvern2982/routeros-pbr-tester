# syntax=docker/dockerfile:1
ARG ALPINE_VERSION=3.22
FROM alpine:${ALPINE_VERSION}

# trippy (binary: trip) is in Alpine community; CI smoke test fails if it is missing.
RUN apk add --no-cache curl iproute2 mtr tini trippy

COPY --chmod=755 pbr/*.sh /opt/pbr/
COPY --chmod=644 pbr/pbr.conf /opt/pbr/

LABEL org.opencontainers.image.title="routeros-pbr-tester" \
      org.opencontainers.image.description="PBR test client for RouterOS containers: address, public IP, ping, traceroute, speed test"

# tini as PID 1 so `/container stop` (SIGTERM) exits promptly.
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/sh", "/opt/pbr/start.sh"]
