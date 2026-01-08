FROM alpine:3.20

# Základní balíčky + Gammu
RUN apk add --no-cache gammu gammu-smsd bash jq coreutils

# Startovní skript
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Konfigurace (volitelné - pokud generuješ v run.sh, nemusíš kopírovat)
# COPY gammurc /etc/gammurc

CMD ["/run.sh"]

