#!/bin/bash

CONFIG_FILE="/etc/gammu-smsdrc"

DEVICE="${DEVICE:-/dev/ttyUSB2}"
LOG_LEVEL="${LOG_LEVEL:-info}"
CHECK_INTERVAL="${CHECK_INTERVAL:-10}"
RECEIVE="${RECEIVE:-true}"

MQTT_HOST="${MQTT_HOST:-core-mosquitto}"
MQTT_PORT="${MQTT_PORT:-1883}"
MQTT_USER="${MQTT_USER:-smsd}"
MQTT_PASS="${MQTT_PASS}"
MQTT_OUTGOING_TOPIC="${MQTT_OUTGOING_TOPIC:-Ourplace/SMS/Outgoing}"

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
echo "MQTT: host=${MQTT_HOST} port=${MQTT_PORT} user=${MQTT_USER} topic=${MQTT_OUTGOING_TOPIC}"

/usr/local/bin/mqtt_bridge.sh &

gammu-smsd -c $CONFIG_FILE
