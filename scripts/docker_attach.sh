container=$(docker ps --format '{{.ID}} - {{.Names}} - {{.Status}}' | gum filter | cut -d' ' -f 1)
docker logs $container
docker attach $container
