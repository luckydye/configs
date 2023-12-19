source $CONFIGS_DIR/commands.sh

function push_changes() {
  echo "Push configs..."
  cfg -C $CONFIGS_DIR/ add --all
  cfg -C $CONFIGS_DIR/ commit -m "sync config"
  cfg -C $CONFIGS_DIR/ push
}

echo "Stash local changes and pull..."

cfg -C $CONFIGS_DIR/ add --all
cfg -C $CONFIGS_DIR/ stash
cfg -C $CONFIGS_DIR/ pull
cfg -C $CONFIGS_DIR/ stash pop

echo "Encrypt env..."

cp env env.swap

echo "Rerun setup..."

jetp local -p $CONFIGS_DIR/setup.yml || exit 1

echo "Merge env..."

# merge new env with old env.swap
cfg merge-file -p env env.swap env > env
enc $CONFIGS_DIR/env

echo "Push changes..."

cfg diff --exit-code || push_changes

echo "Done"
