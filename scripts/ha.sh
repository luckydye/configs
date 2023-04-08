echo $1
echo $2
echo curl "https://home.luckydye.de/api/$2" -X "POST" -H "Authorization: Bearer $HOME_ASSISTANT_TOKEN" -H "Content-Type: application/json" -d "{ \"entity_id\": \"$3\" }"
curl "https://home.luckydye.de/api/$2" -X "POST" -H "Authorization: Bearer $HOME_ASSISTANT_TOKEN" -H "Content-Type: application/json" -d "{ \"entity_id\": \"$3\" }"
