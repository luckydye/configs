# install enrry for windows

$CONFIGS_DIR = "~/configs"

function explain() {
    echo ""
    echo "#######################################################"
    echo ""
    echo "Installation complete. Open a new Terminal."
    echo ""
    echo "To sync config to the latest commit run: sync"
    echo ""
    echo "#######################################################"
    echo ""
}

mkdir $CONFIGS_DIR/..
cd $CONFIGS_DIR/..
git clone https://github.com/luckydye/configs.git

# install mise
scoop install mise

mise install -y

cd $CONFIGS_DIR
task -t setup.yaml

explain
