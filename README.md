# Gammu SMS Gateway for Home Assistant

SMS gateway add-on using Gammu SMSD with MQTT support for Huawei E3372 modem.

## Installation

1. Add this repository to Home Assistant:
```
   https://github.com/rychlymartin82-debug/gammu_smsd_addon
```

2. Install "Gammu SMS Gateway" add-on

3. Configure:
   - Device: `/dev/ttyUSB2` (or your modem's AT port)
   - MQTT host: `core-mosquitto`
   - MQTT credentials
   - MQTT topic prefix

4. Start the add-on

## MQTT Topics

- **Incoming SMS**: `Ourplace/SMS/Incoming`
- **Outgoing SMS**: `Ourplace/SMS/Outgoing`

## Sending SMS

Publish to `Ourplace/SMS/Outgoing`:
```json
{
  "to": "+420123456789",
  "message": "Hello from Home Assistant"
}
```

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `device` | `/dev/ttyUSB2` | Modem device path |
| `mqtt_host` | `core-mosquitto` | MQTT broker hostname |
| `mqtt_port` | `1883` | MQTT broker port |
| `mqtt_user` | `smsd` | MQTT username |
| `mqtt_password` | - | MQTT password |
| `mqtt_topic` | `Ourplace/SMS/Outgoing` | Topic for outgoing SMS |


