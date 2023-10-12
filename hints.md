
# up/down prefixed history search

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

###################################
# install gitui

USER gitpod


RUN curl -s https://api.github.com/repos/extrawurst/gitui/releases/latest | grep -wo "https.*linux.*gz" | wget -qi - \
     && bash -c "tar xzvf gitui-linux-musl.tar.gz \
         && rm gitui-linux-musl.tar.gz \
         && chmod +x gitui \
         && sudo mv gitui /usr/local/bin"


###################################
# Install Neovim from source.

USER root

ENV CMAKE_BUILD_TYPE=RelWithDebInfo
RUN mkdir -p /root/TMP
RUN cd /root/TMP && git clone https://github.com/neovim/neovim
RUN cd /root/TMP/neovim && git checkout stable && make -j4 && make install
RUN rm -rf /root/TMP \
  && cd /home/gitpod/.local \
  && rm -rf state 