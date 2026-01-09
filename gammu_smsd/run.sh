#!/bin/bash

CONFIG_FILE="/etc/gammu-smsdrc"

DEVICE="${DEVICE:-/dev/ttyUSB2}"
LOG_LEVEL="${LOG_LEVEL:-info}"
CHECK_INTERVAL="${CHECK_INTERVAL:-10}"
RECEIVE="${RECEIVE:-true}"

# Generate gammu-smsd config
cat <<EOF > $CONFIG_FILE
[gammu]
device = ${DEVICE}
connection = at

[smsd]
service = files
logfile = /data/smsd.log
logformat = ${LOG_LEVEL}
checksecurity = 0
receive = ${RECEIVE}
checkinterval = ${CHECK_INTERVAL}
phoneid = modem1
inboxpath = /data/inbox/
outboxpath = /data/outbox/
sentsmspath = /data/sent/
errorsmspath = /data/error/
EOF

mkdir -p /data/inbox /data/outbox /data/sent /data/error

echo "Using device: ${DEVICE}"

# Start MQTT bridge (only once)
echo "Starting MQTT bridge..."
/usr/local/bin/mqtt_bridge.sh &

# Start SMSD
gammu-smsd -c $CONFIG_FILE

wait
