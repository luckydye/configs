container=$(docker ps --format '{{.ID}} - {{.Names}} - {{.Status}}' | gum filter | cut -d' ' -f 1)
docker attach $container
