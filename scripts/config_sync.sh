source $CONFIGS_DIR/commands.sh

function push_changes() {
	echo "Push configs..."
	git -C $CONFIGS_DIR/ add --all
	git -C $CONFIGS_DIR/ commit -m "sync config"
	git -C $CONFIGS_DIR/ push
}

echo "Stash local changes and pull..."
git -C $CONFIGS_DIR/ add --all
git -C $CONFIGS_DIR/ stash
git -C $CONFIGS_DIR/ pull
git -C $CONFIGS_DIR/ stash pop

cp $CONFIGS_DIR/env $CONFIGS_DIR/env.swap

echo "Rerun setup..."
jetp local -p $CONFIGS_DIR/setup.yml || exit 1

echo "Merge env..."
# merge new env with old env.swap
git -C $CONFIGS_DIR/ merge-file -p $CONFIGS_DIR/env $CONFIGS_DIR/env $CONFIGS_DIR/env.swap >$CONFIGS_DIR/env
rm $CONFIGS_DIR/env.swap

echo "Encrypt env..."
enc $CONFIGS_DIR/env

echo "Push changes..."
git -C $CONFIGS_DIR/ diff --exit-code || push_changes

echo "Done"
