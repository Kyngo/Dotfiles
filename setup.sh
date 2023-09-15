#!/bin/bash

OPERATING_SYSTEM=`uname`

function copy_dotfiles() {
    for i in `ls -a | grep "^\.\w"`; do
        if [ -f "~/$i"]; then
            rm "~/$i"
        fi
        ln -s "$PWD/$i" "~/$i"
    done
}

function install_common_stuff() {
    # NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    # Poetry
    curl -sSL https://install.python-poetry.org | python3 -
    # Installing Node.js versions
    for ((i = 8; i <= 20; i++))
    do
        nvm install $i
    done
    nvm alias default 18

    # oh my zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # common aliases
    ln -s $PWD/aliases.common.sh ~/aliases.common.sh
}

function install_macos() {
    # brew
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
    brew bundle
}

function install_debian() {
    PKG_MGR="apt"
    INSTALL_CMD="$PKG_MGR install -yyq"
    PKGS=(
        "python3" "docker.io" "docker-compose" "zip" "unzip" "virtualenv" "build-essential" "jq"
        "golang" "yakuake" "traceroute" "telegram-desktop" "lighttpd" "nmap" "gparted" "zsh" 
        "htop" "curl"
    )

    if [ $EUID -eq 0 ]; then
        echo "Must NOT run this script as root!"
        exit 1
    fi
    echo "Please enter your sudo password..."
    sudo -v

    for i in ${PKGS[@]}
    do
        sudo $INSTALL_CMD $i
    done

    # SPHP
    wget https://gist.githubusercontent.com/Kyngo/96f4f9ae48e98fa6d167f4d954f1eab0/raw/81e1b8b3dcb79ca13b6a402a2061a44b372a6261/sphp.sh  -O /usr/bin/sphp
    chmod +x /usr/bin/sphp
}

if [ "$OPERATING_SYSTEM" = "Darwin" ]; then
    install_macos
    copy_dotfiles
    install_common_stuff
elif [ "$OPERATING_SYSTEM" = "Linux" ]; then
    if [ -f `which apt` ]; then
        echo "Debian-based distro detected - installing packages"
        install_debian
    fi
    copy_dotfiles
    install_common_stuff
else
    echo "Unsupported OS :("
    exit 1
fi
