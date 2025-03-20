#!/usr/bin/env bash

## from: https://www.hyperdx.io/blog/testing-sending-opentelemetry-events-curl

JSON_TEMPLATE=$(cat <<-_JSON_
{
  "resourceLogs": [
    {
      "resource": {
        "attributes": [
          {
            "key": "service.name",
            "value": {
              "stringValue": "${SERVICE_NAME}"
            }
          }
        ]
      },
      "scopeLogs": [
        {
          "logRecords": [
            {
              "severityNumber": 10,
              "severityText": "Information",
              "traceId": "${TRACEID}",
              "spanId": "${SPANID}",
              "body": {
                "stringValue": "${MESSAGE}"
              }
            }
          ]
        }
      ]
    }
  ]
}
_JSON_
)

if ! command -v jq &> /dev/null; then
  echo "jq is not installed"
  exit 1
fi

SERVICE_NAME="cli.service"
TRACEID=$(LC_CTYPE=C tr -dc 'A-F0-9' < /dev/urandom | head -c 32; echo)
SPANID=$(LC_CTYPE=C tr -dc 'A-F0-9' < /dev/urandom | head -c 16; echo)
MESSAGE="${1}"

OTEL_EXPORTER_OTLP_ENDPOINT="${OTEL_EXPORTER_OTLP_ENDPOINT:-'localhost:4317'}"
PROTO="http"
ROUTE="/v1/logs"


JSON=$(jq -c --arg service_name "${SERVICE_NAME}" --arg traceid "${TRACEID}" --arg spanid "${SPANID}" --arg message "${MESSAGE}" \
  '.resourceLogs[0].resource.attributes[0].value.stringValue = $service_name |
   .resourceLogs[0].scopeLogs[0].logRecords[0].traceId = $traceid |
   .resourceLogs[0].scopeLogs[0].logRecords[0].spanId = $spanid |
   .resourceLogs[0].scopeLogs[0].logRecords[0].body.stringValue = $message' <<< "${JSON_TEMPLATE}")

curl -v "${PROTO}://${OTEL_EXPORTER_OTLP_ENDPOINT}${ROUTE}" -X POST -H "Content-Type: application/json" --data "${JSON}"
