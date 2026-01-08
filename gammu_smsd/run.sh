#!/bin/bash
set -euo pipefail

OPTIONS_FILE="/data/options.json"

DEVICE=$(jq -r '.device // "/dev/serial/by-id/usb-HUAWEI_HUAWEI_Mobile-if00-port0"' "$OPTIONS_FILE")
PIN=$(jq -r '.pin // ""' "$OPTIONS_FILE")
SMSC=$(jq -r '.smsc // ""' "$OPTIONS_FILE")
LOG_LEVEL=$(jq -r '.log_level // "info"' "$OPTIONS_FILE")
CHECK_INTERVAL=$(jq -r '.check_interval // 10' "$OPTIONS_FILE")
RECEIVE=$(jq -r '.receive // true' "$OPTIONS_FILE")
DELETE_AFTER_RECV=$(jq -r '.delete_after_recv // false' "$OPTIONS_FILE")

echo "Gammu SMSD starting..."
echo "Device: $DEVICE, PIN: ${PIN:+(set)}, Log: $LOG_LEVEL, Interval: $CHECK_INTERVAL"

mkdir -p /data/inbox /data/outbox /data/sent /data/error
touch /data/smsd.log

# gammurc
cat > /etc/gammurc <<EOF
[gammu]
device = ${DEVICE}
connection = at
EOF

# smsd config
cat > /etc/gammu-smsdrc <<EOF
[gammu]
device = ${DEVICE}
connection = at

[smsd]
service = files
logfile = /data/smsd.log
debuglevel = ${LOG_LEVEL}
checkinterval = ${CHECK_INTERVAL}

inboxpath = /data/inbox
outboxpath = /data/outbox
sentpath = /data/sent
errorpath = /data/error

${PIN:+init = AT+CPIN=${PIN}}
${SMSC:+smsc = ${SMSC}}

receive = ${RECEIVE}
deleteafterreceive = ${DELETE_AFTER_RECV}
EOF

echo "Starting SMSD..."
exec gammu-smsd --config /etc/gammu-smsdrc

# Spuštění Gammu SMSD v popředí (Supervisor to vyžaduje)
exec gammu-smsd --config /etc/gammu-smsdrc --pid /var/run/gammu-smsd.pid --daemon never
