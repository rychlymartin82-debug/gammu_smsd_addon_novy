cat > Dockerfile << 'EOF'
FROM alpine:3.19

RUN apk add --no-cache \
    bash \
    gammu \
    gammu-smsd \
    mosquitto-clients \
    curl \
    jq

COPY run.sh /app/run.sh
COPY on_receive.sh /app/on_receive.sh

RUN chmod +x /app/run.sh /app/on_receive.sh

WORKDIR /app
CMD ["/app/run.sh"]
EOF
