source $CONFIGS_DIR/commands.sh

echo "Stash local changes and pull..."

git -C $CONFIGS_DIR/ add --all
git -C $CONFIGS_DIR/ stash
git -C $CONFIGS_DIR/ pull
git -C $CONFIGS_DIR/ stash pop

echo "Encrypt env..."
sleep 1

enc $CONFIGS_DIR/env

sleep 1

function push_changes() {
  echo "Push configs..."
  git -C $CONFIGS_DIR/ add --all
  git -C $CONFIGS_DIR/ commit -m "sync config"
  git -C $CONFIGS_DIR/ push
}

git diff --exit-code || push_changes

echo "Rerun setup..."

jetp local -p $CONFIGS_DIR/setup.yml || exit 1

echo "Done"
