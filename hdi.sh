#!/bin/bash
# hdi.sh

API_KEY="${OPENAI_API_KEY}"

if [ -z "${API_KEY}" ]; then
    echo "OpenAI API key not set. Please set it in the OPENAI_API_KEY environment variable."
    exit 1
fi

USER_INPUT="$@"

if [ -z "$USER_INPUT" ]; then
    echo "Please provide an input to hdi. Usage: 'hdi {Your search query here}'"
    exit 1
fi

API_URL="https://api.openai.com/v1/chat/completions"
MODEL="gpt-3.5-turbo"

MESSAGES_JSON="[
    {\"role\": \"system\", \"content\": \"You are to give me the command that would take the following action in ternimal. Bes as succinct as possible, including only the command.\"},
    {\"role\": \"user\", \"content\": \"$USER_INPUT\"}
]"

RESPONSE=$(curl -s -X POST $API_URL \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    --data "{\"model\": \"$MODEL\", \"messages\": $MESSAGES_JSON}")

echo $RESPONSE | jq -r '.choices[0].message.content'

