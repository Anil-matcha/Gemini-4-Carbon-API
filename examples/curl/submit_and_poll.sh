#!/usr/bin/env bash
# Submit a Gemini 4 Carbon request and poll until it finishes. Requires curl and jq.
set -euo pipefail
: "${MUAPI_API_KEY:?Set MUAPI_API_KEY first}"
BASE="https://api.muapi.ai/api/v1"
PROMPT="${1:-Explain the difference between SQL injection and command injection, with one fix for each.}"

REQUEST_ID=$(curl -sS -X POST "$BASE/gemini-4-carbon" \
  -H "x-api-key: $MUAPI_API_KEY" -H "Content-Type: application/json" \
  -d "$(jq -n --arg p "$PROMPT" '{prompt:$p, reasoning_effort:"medium"}')" | jq -r .request_id)
echo "request_id: $REQUEST_ID" >&2

while true; do
  RESULT=$(curl -sS "$BASE/predictions/$REQUEST_ID/result" -H "x-api-key: $MUAPI_API_KEY")
  STATUS=$(echo "$RESULT" | jq -r .status)
  case "$STATUS" in
    completed) echo "$RESULT" | jq -r '.outputs[0]'; exit 0 ;;
    failed) echo "$RESULT" | jq . >&2; exit 1 ;;
  esac
  sleep 2
done
