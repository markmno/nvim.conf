# Stage 1: Base system setup with essential dependencies
FROM debian:trixie AS base

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Etc/UTC \
    TERM=xterm-kitty \
    PATH="/opt/nvim-linux64/bin:/home/user/.cargo/bin:$PATH"

# Install core dependencies and sudo
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo build-essential kitty ripgrep npm imagemagick libmagickwand-dev \
    lua5.1 luarocks tmux curl git zsh file procps ueberzug \
    python3.12-venv libsqlite3-dev locales tzdata && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

# Add user with sudo privileges
RUN useradd -ms /bin/bash user && \
    mkdir -p /home/user && \
    chown -R user:user /home/user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Stage 2: Build stage - installs dependencies, downloads, and builds necessary components
FROM base AS builder

# Install Neovim (cached layer for Neovim download and extract)
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz && \
    tar -C /opt -xzf nvim-linux64.tar.gz && rm nvim-linux64.tar.gz

# Install Rust and Cargo, and a Cargo package (yazi)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . "$HOME/.cargo/env" && \
    cargo install --locked yazi-fm yazi-cli && \
    rm -rf /root/.cargo/registry /root/.cargo/git

# Install Quarto CLI
RUN git clone https://github.com/quarto-dev/quarto-cli && \
    cd quarto-cli && ./configure.sh && cd .. && rm -rf quarto-cli

# Clone Neovim configuration and Tmux plugins
RUN git clone https://github.com/markmno/nvim.conf.git /root/.config/nvim && \
    mkdir -p /root/.tmux/plugins && \
    git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm && \
    echo "set -g @plugin 'tmux-plugins/tpm'" >> /root/.tmux.conf && \
    echo "set -g @plugin 'arcticicestudio/nord-tmux'" >> /root/.tmux.conf && \
    echo "set -g @plugin 'tmux-plugins/tmux-sensible'" >> /root/.tmux.conf && \
    echo "set -g @plugin 'tmux-plugins/tmux-resurrect'" >> /root/.tmux.conf && \
    echo "set -g default-terminal 'xterm-kitty'" >> /root/.tmux.conf && \
    echo "set -g allow-passthrough all" >> /root/.tmux.conf && \
    echo "set -ga update-environment TERM" >> /root/.tmux.conf && \
    echo "set -ga update-environment TERM_PROGRAM" >> /root/.tmux.conf && \
    echo "set-option -g default-shell /bin/zsh" >> /root/.tmux.conf && \
    echo "run '~/.tmux/plugins/tpm/tpm'" >> /root/.tmux.conf 

# Stage 3: Final runtime stage - configure environment for user and copy over essential assets
FROM base AS final

# Copy essential assets from build stage
COPY --from=builder /opt/nvim-linux64 /opt/nvim-linux64
COPY --from=builder /root/.config/nvim /home/user/.config/nvim
COPY --from=builder /root/.tmux /home/user/.tmux
COPY --from=builder /root/.tmux.conf /home/user/.tmux.conf
COPY --from=builder /root/.cargo /home/user/.cargo

# Set ownership for user on copied files
RUN chown -R user:user /home/user/.config /home/user/.tmux /home/user/.tmux.conf /home/user/.cargo

# Switch to the non-root user
USER user
WORKDIR /home/user
ENV VIRTUAL_ENV=/home/user/.virtualenvs/neovim
ENV PATH="$VIRTUAL_ENV/bin:/opt/nvim-linux64/bin:/home/user/.cargo/bin:$PATH"

# Configure virtual environment and install Python packages
RUN python3 -m venv $VIRTUAL_ENV && \
    $VIRTUAL_ENV/bin/pip install --upgrade pip && \
    $VIRTUAL_ENV/bin/pip install pynvim jupyter_client cairosvg plotly kaleido pyperclip \
    nbformat pillow ipykernel && \
    python3 -m ipykernel install --user --name neovim-kernel

# Install Lua magick rock for image processing support
RUN luarocks --local --lua-version=5.1 install magick

# Minimal Zsh configuration
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc && \
    echo "alias ll='ls -lah --color=auto'" >> ~/.zshrc && \
    echo "export LANG=C.UTF-8" >> ~/.zshrc

RUN mkdir -p ~/.local/share/jupyter/runtime && \
    nvim --headless "+Lazy! sync" +qa

# Set default shell to Zsh
CMD ["/bin/zsh"]

