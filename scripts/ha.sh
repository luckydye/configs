curl -s "https://home.luckydye.de/api/$2" -X "POST" -H "Authorization: Bearer $HOME_ASSISTANT_TOKEN" -H "Content-Type: application/json" -d "{ \"entity_id\": \"$3\" }" > /dev/null
echo ""
