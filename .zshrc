export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

ALIAS_FILES=(
    "aliases.common.sh" "aliases.macos.sh" "aliases.linux.sh"
)
for i in ${ALIAS_FILES[@]}
do
    if [ -f $HOME/$i ]; then
        source $HOME/$i
    fi
done
