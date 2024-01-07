#!/bin/bash
PATHAPP=/etc/ITkha/mikrotik-abuseipdb

source $PATHAPP/config.cfg.local
source $PATHAPP/config.cfg

# Функция для регистрации адреса в AbuseIPDB

# Функция для регистрации адреса в AbuseIPDB
ip=$1
response=$(curl -s -X POST "https://api.abuseipdb.com/api/v2/report" \
    -H "Key: $ABUSEIPDB_API" \
    -H "Content-Type: application/json" \
    --data "{\"ip\":\"$ip\",\"categories\":[\"18\"],\"comment\":\"Possible malicious activity\"}")

# Проверка успешности регистрации
if echo "$response" | grep -q '"ipAddress"'; then
    abuseConfidenceScore=$(echo "$response" | jq -r '.data.abuseConfidenceScore')
        bash $PATHAPP/scripts/logger.sh -s  "$ip successfully registered in AbuseIPDB abuse confidence score $abuseConfidenceScore"

else
    bash $PATHAPP/scripts/logger.sh -e  "error when registering $ip AbuseIPDB"
    echo "$response"
fi
