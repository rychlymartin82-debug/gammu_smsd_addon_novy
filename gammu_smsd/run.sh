#!/bin/sh
set -e

OPTIONS_FILE="/data/options.json"

DEVICE=$(jq -r '.device' "$OPTIONS_FILE")
PIN=$(jq -r '.pin' "$OPTIONS_FILE")
SMSC=$(jq -r '.smsc' "$OPTIONS_FILE")
LOG_LEVEL=$(jq -r '.log_level' "$OPTIONS_FILE")
CHECK_INTERVAL=$(jq -r '.check_interval' "$OPTIONS_FILE")
RECEIVE=$(jq -r '.receive' "$OPTIONS_FILE")
DELETE_AFTER_RECV=$(jq -r '.delete_after_recv' "$OPTIONS_FILE")

MQTT_HOST=$(jq -r '.mqtt_host' "$OPTIONS_FILE")
MQTT_PORT=$(jq -r '.mqtt_port' "$OPTIONS_FILE")
MQTT_USER=$(jq -r '.mqtt_user' "$OPTIONS_FILE")
MQTT_PASS=$(jq -r '.mqtt_pass' "$OPTIONS_FILE")
MQTT_TOPIC_OUT=$(jq -r '.mqtt_outgoing_topic' "$OPTIONS_FILE")

export MQTT_HOST MQTT_PORT MQTT_USER MQTT_PASS MQTT_TOPIC_OUT

echo "Using device: $DEVICE"
echo "MQTT: host=$MQTT_HOST port=$MQTT_PORT user=$MQTT_USER topic=$MQTT_TOPIC_OUT"

mkdir -p /data/inbox /data/outbox /data/sent /data/error

cat > /etc/gammu-smsdrc <<EOF
[gammu]
device = $DEVICE
connection = at

[smsd]
service = files
logfile = /data/smsd.log
debuglevel = 1
CheckSecurity = 0
StatusFrequency = $CHECK_INTERVAL
InboxPath = /data/inbox/
OutboxPath = /data/outbox/
SentSMSPath = /data/sent/
ErrorSMSPath = /data/error/
RunOnReceive = /usr/local/bin/mqtt_bridge.sh
EOF

# wait for device node to appear (max 30 s)
echo "Waiting for device node $DEVICE to appear..."
for i in $(seq 1 30); do
  if [ -e "$DEVICE" ]; then
    echo "Device node found"
    break
  fi
  sleep 1
done

# wait for modem to respond to gammu identify (max 40 s)
echo "Waiting for modem to respond to AT commands..."
for i in $(seq 1 40); do
  if gammu --identify -c /etc/gammu-smsdrc >/dev/null 2>&1; then
    echo "Modem responded"
    break
  fi
  sleep 1
done

echo "Starting gammu-smsd..."
exec gammu-smsd -c /etc/gammu-smsdrc -d
