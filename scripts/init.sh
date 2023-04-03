# linux machine first setup

if ! command -v git &> /dev/null
then
    sudo apt update
    sudo apt install git
    exit
fi

git clone https://github.com/luckydye/configs.git ~/configs

echo "source ~/configs/.bashrc" >> ~/.bashrc

echo "Successfully installed."
