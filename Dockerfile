# Base image
FROM debian:trixie

# Set up system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    kitty \
    ripgrep \
    npm \
    imagemagick \
    libmagickwand-dev \
    lua5.1 \
    luarocks \
    tmux \
    curl \
    git \
    zsh \
    file \
    procps \
    sudo \
    ueberzug \
    python3.12-venv\
    libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

# Add user accounts and permissions
RUN useradd -ms /bin/bash user && \
    chown -R user:user /home/user && \
    useradd -m -s /bin/zsh linuxbrew && \
    usermod -aG sudo linuxbrew &&  \
    mkdir -p /home/linuxbrew/.linuxbrew && \
    chown -R linuxbrew: /home/linuxbrew/.linuxbrew

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    rm nvim-linux64.tar.gz
ENV PATH="/opt/nvim-linux64/bin:$PATH"

# Configure Zsh with plugins
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

# Set working directory for user
USER user
WORKDIR /home/user

# Clone and configure Quarto CLI
RUN git clone https://github.com/quarto-dev/quarto-cli && \
    cd quarto-cli && ./configure.sh

# Install Lua magick rock
RUN luarocks --local --lua-version=5.1 install magick

# # Install Homebrew under linuxbrew user
# USER linuxbrew
# RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# USER root
# RUN chown -R $CONTAINER_USER: /home/linuxbrew/.linuxbrew
# ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
# RUN git config --global --add safe.directory /home/linuxbrew/.linuxbrew/Homebrew
# USER linuxbrew
# RUN brew update && \
#     brew doctor

# # Install pyenv manually and set up Python
# RUN curl https://pyenv.run | bash && \
#     export PATH="$HOME/.pyenv/bin:$PATH" && \
#     eval "$(pyenv init --path)" && \
#     pyenv install 3.12 && \
#     pyenv global 3.12

USER user
# Configure virtual environment
ENV VIRTUAL_ENV=/home/user/.virtualenvs/neovim
RUN python3 -m venv $VIRTUAL_ENV && \
    $VIRTUAL_ENV/bin/pip install --upgrade pip && \
    $VIRTUAL_ENV/bin/pip install \
        pynvim \
        jupyter_client \
        cairosvg \
        plotly \
        kaleido \
        pyperclip \
        nbformat \
        pillow \
        ipykernel
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install IPython kernel for Neovim
RUN python3 -m ipykernel install --user --name neovim-kernel

# Install Rust and Cargo dependencies
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/user/.cargo/bin:$PATH"
RUN cargo install yazi-fm

# Clone Neovim and Tmux configurations
RUN mkdir -p /home/user/.config/nvim && \
    git clone https://github.com/markmno/nvim.conf.git /home/user/.config/nvim && \
    mkdir -p /home/user/.config/tmux && \
    git clone https://github.com/markmno/tmux.conf.git /home/user/.config/tmux

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Set default shell to Zsh
CMD ["/bin/zsh"]

