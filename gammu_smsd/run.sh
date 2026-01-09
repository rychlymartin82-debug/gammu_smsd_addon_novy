#!/bin/sh

# Soubor, který Gammu předá jako první argument, obsahuje SMS
SMS_FILE="$1"

if [ ! -f "$SMS_FILE" ]; then
  echo "No SMS file provided"
  exit 1
fi

# Načteme text SMS (a případně další metadata, kdybys chtěl)
MESSAGE=$(cat "$SMS_FILE")

# Pokud proměnné nejsou exportované, načteme je z options.json
OPTIONS_FILE="/data/options.json"

if [ -z "$MQTT_HOST" ]; then
  MQTT_HOST=$(jq -r '.mqtt_host' "$OPTIONS_FILE")
fi
if [ -z "$MQTT_PORT" ]; then
  MQTT_PORT=$(jq -r '.mqtt_port' "$OPTIONS_FILE")
fi
if [ -z "$MQTT_USER" ]; then
  MQTT_USER=$(jq -r '.mqtt_user' "$OPTIONS_FILE")
fi
if [ -z "$MQTT_PASS" ]; then
  MQTT_PASS=$(jq -r '.mqtt_pass' "$OPTIONS_FILE")
fi
if [ -z "$MQTT_TOPIC_OUT" ]; then
  MQTT_TOPIC_OUT=$(jq -r '.mqtt_outgoing_topic' "$OPTIONS_FILE")
fi

mosquitto_pub \
  -h "$MQTT_HOST" \
  -p "$MQTT_PORT" \
  -u "$MQTT_USER" \
  -P "$MQTT_PASS" \
  -t "$MQTT_TOPIC_OUT" \
  -m "$MESSAGE"
