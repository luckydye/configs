alias cfg='/usr/bin/git -C $CONFIGS_DIR/'

function push_changes() {
  echo "Push configs..."
  cfg add --all
  cfg commit -m "sync config"
  cfg push
}

echo "Stash local changes and pull..."

cfg add --all
cfg stash
cfg pull
cfg stash pop

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
