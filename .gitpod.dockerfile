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

RUN brew install cmake
