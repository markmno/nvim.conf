FROM debian:bookworm

# Install system dependencies (including ImageMagick development files)
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
    python3.11-venv \
    zsh \
    zplug \
    file \
    procps \
    sudo \
    ueberzug \
    libsqlite3-dev

# Create user and set appropriate permissions
RUN useradd -ms /bin/bash user && \
    chown -R user:user /home/user

RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

# Install Neovim (using user permissions and improved download handling)
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux64.tar.gz

ENV PATH="/opt/nvim-linux64/bin:$PATH"

# Install and configure zsh (ensure zsh is installed before running the script)
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions

USER user
WORKDIR /home/user

# Install Quarto
RUN git clone https://github.com/quarto-dev/quarto-cli
WORKDIR /home/user/quarto-cli
RUN ./configure.sh
# Install magick rock 
RUN luarocks --local --lua-version=5.1 install magick 
# Install Homebrew (adapt path if needed — this uses a common location)
USER linuxbrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
USER root
RUN chown -R $CONTAINER_USER: /home/linuxbrew/.linuxbrew/Cellar
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# Install your desired Homebrew packages 
USER linuxbrew
RUN brew update && \
    brew doctor && \
    brew install pyenv
USER user
RUN pyenv install 3.12
RUN pyenv global 3.12

# Set up and activate the virtual environment
ENV VIRTUAL_ENV=/home/user/.virtualenvs/neovim
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Upgrade pip and install Python packages
RUN pip install --upgrade pip \
    pynvim \
    jupyter_client \
    cairosvg \
    plotly \
    kaleido \
    pyperclip \
    nbformat \
    pillow \
    ipykernel

# Install IPython kernel
RUN python3 -m ipykernel install --user --name neovim-kernel

# Copy tmux config
# WORKDIR /home/user/.config/tmux
# RUN git clone https://github.com/markmno/tmux.conf.git .

# Install cargo
RUN  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/user/.cargo/bin:$PATH"
RUN cargo install yazi-fm

# Copy nvim config
WORKDIR /home/user/.config/nvim
RUN git clone https://github.com/markmno/nvim.conf.git .

# Default command (start zsh shell)
CMD ["/bin/bash"]
