source $CONFIGS_DIR/commands.sh

echo "Stash local changes and pull..."

cfg -C $CONFIGS_DIR/ add --all
cfg -C $CONFIGS_DIR/ stash
cfg -C $CONFIGS_DIR/ pull
cfg -C $CONFIGS_DIR/ stash pop

echo "Encrypt env..."
sleep 1

enc $CONFIGS_DIR/env

sleep 1

function push_changes() {
  echo "Push configs..."
  cfg -C $CONFIGS_DIR/ add --all
  cfg -C $CONFIGS_DIR/ commit -m "sync config"
  cfg -C $CONFIGS_DIR/ push
}

cfg diff --exit-code || push_changes

echo "Rerun setup..."

jetp local -p $CONFIGS_DIR/setup.yml || exit 1

echo "Done"
