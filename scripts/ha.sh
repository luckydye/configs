curl "https://home.luckydye.de/api/$1" -X "POST" -H "Authorization: Bearer $HOME_ASSISTANT_TOKEN" -H "Content-Type: application/json" -d "{ \"entity_id\": \"$2\" }"
