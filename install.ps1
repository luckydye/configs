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

git clone https://github.com/luckydye/configs.git ${CONFIGS_DIR} 

# install task
scoop install task

task -t $CONFIGS_DIR/setup.yml

explain
