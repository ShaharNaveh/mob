FROM docker.io/library/python:3.8.15-alpine3.16@sha256:0905fe2cdf70d83b946297c69ad3f4c438ac6f179d7d7f5e1ff7c97036173ae3 AS runtime
ENV PYTHONUNBUFFERED=1
RUN rm -f /tmp/*
COPY ./artifacts/file.txt /tmp/

EXPOSE 8080

# "HEALTHCHECK" is here for documentation purposes only, as it's not supported for OCI image format (yet?)
# Ref:
# https://github.com/opencontainers/image-spec/issues/749
# https://github.com/opencontainers/umoci/issues/352
# HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://127.0.0.1:8080/ || exit 1

ENTRYPOINT ["python3", "-m", "http.server", "--directory", "/tmp/", "8080"]
