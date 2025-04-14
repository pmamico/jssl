#!/usr/bin/env bash

uname="$(uname)"
if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X platform
    sudo curl -o /usr/local/bin/jssl -s https://raw.githubusercontent.com/pmamico/jssl/main/src/jssl && sudo chmod +x /usr/local/bin/jssl
    INSTALL_PATH=/usr/local/bin/jssl
elif [ "${uname:0:5}" == "Linux" ]; then
    # GNU/Linux platform
     sudo curl -o /usr/local/bin/jssl -s https://raw.githubusercontent.com/pmamico/jssl/main/src/jssl && sudo chmod +x /usr/local/bin/jssl
     INSTALL_PATH=/usr/local/bin/jssl
elif [ "${uname:0:10}" == "MINGW32_NT" ]; then
    # 32 bits Windows NT platform
    mkdir -p "$HOME"/bin
    curl -o "$HOME"/bin/jssl -s https://raw.githubusercontent.com/pmamico/jssl/main/src/jssl
    INSTALL_PATH=$HOME/bin/jssl
elif [ "${uname:0:10}" == "MINGW64_NT" ]; then
    # 64 bits Windows NT platform
   mkdir -p "$HOME"/bin
   curl -o "$HOME"/bin/jssl -s https://raw.githubusercontent.com/pmamico/jssl/main/src/jssl
   INSTALL_PATH=$HOME/bin/jssl
fi

if test -f "$INSTALL_PATH"; then
    echo "$(jssl --version) successfully installed. ($INSTALL_PATH)"
else
    echo "Failed to install jssl"
fi
