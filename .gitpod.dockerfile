FROM gitpod/workspace-python-3.11:2023-10-10-09-48-27


USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1
ENV NODE_VERSION="18.18.0"

ENV PNPM_HOME=/home/gitpod/.pnpm
ENV PATH=/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:/home/gitpod/.yarn/bin:${PNPM_HOME}:$PATH

RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | PROFILE=/dev/null bash \
    && bash -c ". .nvm/nvm.sh \
        && nvm install v${NODE_VERSION} \
        && nvm alias default v${NODE_VERSION} \
        && npm install -g typescript yarn pnpm node-gyp" \
    && echo ". ~/.nvm/nvm-lazy.sh"  >> /home/gitpod/.bashrc.d/50-node
# above, we are adding the lazy nvm init to .bashrc, because one is executed on interactive shells, the other for non-interactive shells (e.g. plugin-host)
COPY --chown=gitpod:gitpod nvm-lazy.sh /home/gitpod/.nvm/nvm-lazy.sh

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH
ENV MANPATH="$MANPATH:/home/linuxbrew/.linuxbrew/share/man"
ENV INFOPATH="$INFOPATH:/home/linuxbrew/.linuxbrew/share/info"
ENV HOMEBREW_NO_AUTO_UPDATE=1

RUN brew install cmake lf lsd gh

USER root

RUN apt-get -y install fzf ripgrep tree xclip tzdata ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config zip unzip mc ncdu wget fd-find tmux luajit libluajit-5.1-dev lua-mpack lua-lpeg libunibilium-dev libmsgpack-dev libtermkey-dev
###################################

USER gitpod

# install gitui

RUN curl -s https://api.github.com/repos/extrawurst/gitui/releases/latest | grep -wo "https.*linux.*gz" | wget -qi - \
     && bash -c "tar xzvf gitui-linux-musl.tar.gz \
         && rm gitui-linux-musl.tar.gz \
         && chmod +x gitui \
         && sudo mv gitui /usr/local/bin"

###################################

# install neovim


# Cooperate Neovim with Python 3.
RUN pip3 install pynvim black

# Cooperate NodeJS with Neovim.
RUN npm i -g neovim prettier pyright typescript typescript-language-server

USER root

# Install Neovim from source.
ENV CMAKE_BUILD_TYPE=RelWithDebInfo
RUN mkdir -p /root/TMP
RUN cd /root/TMP && git clone https://github.com/neovim/neovim
RUN cd /root/TMP/neovim && git checkout stable && make -j4 && make install
RUN rm -rf /root/TMP \
  && cd /home/gitpod/.local \
  && rm -rf state 



USER gitpod

RUN sudo apt-get update \
 && sudo rm -rf /var/lib/apt/lists/*\
# && pyenv install 3.9.13\
# && pyenv global 3.9.13\
 && cd /home/gitpod \
 && mkdir .config \
 && cd .config \
 && mkdir nvim \
 && cd nvim \
 && git clone https://github.com/rom38/Neovim-from-scratch .\
 && git switch dev\
 && nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'\
 && nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'\
 && nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'\
 #&& nvim --headless +PlugInstall +qall
