container=$(docker ps --all --format '{{.ID}} - {{.Names}} - {{.Status}}' | gum choose --no-limit | cut -d' ' -f 1) && \
docker container remove -f $container
