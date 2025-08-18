# ==============================
# Stage 1: Base environment
# ==============================
FROM fedora:latest AS base

# Locale, timezone, paths
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=Etc/UTC \
    TERM=xterm-kitty \
    PATH="/opt/nvim-linux-x86_64/bin:/home/user/.cargo/bin:/home/user/.local/bin:$PATH" \
    CARGO_HOME=/home/user/.cargo \
    RUSTUP_HOME=/home/user/.rustup

# Install core dependencies and Python 3.13
RUN dnf -y update && \
    dnf -y install \
        --setopt=install_weak_deps=False \
        kernel-devel gcc make \
        kitty ripgrep npm ImageMagick ImageMagick-devel \
        lua luarocks tmux git zsh file procps-ng \
        python3 sqlite-devel \
        glibc-langpack-en && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    localedef -i en_US -f UTF-8 en_US.UTF-8 || true && \
    dnf clean all && rm -rf /var/cache/dnf


# Add non-root user with passwordless sudo
RUN useradd -ms /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user


# ==============================
# Stage 2: Builder
# ==============================
FROM base AS builder

# Install Neovim nightly
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz && \
    tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
    rm nvim-linux-x86_64.tar.gz

# Install Rust + Cargo packages
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    . "$CARGO_HOME/env" && \
    cargo install --locked yazi-fm yazi-cli && \
    rm -rf $CARGO_HOME/registry $CARGO_HOME/git

# Install Quarto CLI from source
RUN git clone --depth=1 https://github.com/quarto-dev/quarto-cli /tmp/quarto-cli && \
    cd /tmp/quarto-cli && ./configure.sh && \
    rm -rf /tmp/quarto-cli

# Clone Neovim config & Tmux plugins
RUN git clone https://github.com/markmno/nvim.conf.git /root/.config/nvim && \
    mkdir -p /root/.tmux/plugins && \
    git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm && \
    printf '%s\n' \
      "set -g @plugin 'tmux-plugins/tpm'" \
      "set -g @plugin 'arcticicestudio/nord-tmux'" \
      "set -g @plugin 'tmux-plugins/tmux-sensible'" \
      "set -g @plugin 'tmux-plugins/tmux-resurrect'" \
      "set -g default-terminal 'xterm-kitty'" \
      "set -g allow-passthrough all" \
      "set -ga update-environment TERM" \
      "set -ga update-environment TERM_PROGRAM" \
      "set-option -g default-shell /bin/zsh" \
      "run '~/.tmux/plugins/tpm/tpm'" \
    > /root/.tmux.conf


# ==============================
# Stage 3: Final runtime image
# ==============================
FROM base AS final

# Copy built artifacts
COPY --from=builder /opt/nvim-linux-x86_64 /opt/nvim-linux-x86_64
COPY --from=builder /root/.config/nvim /home/user/.config/nvim
COPY --from=builder /root/.tmux /home/user/.tmux
COPY --from=builder /root/.tmux.conf /home/user/.tmux.conf
COPY --from=builder /home/user/.cargo /home/user/.cargo
COPY --from=builder /home/user/.rustup /home/user/.rustup

# Fix ownership
RUN chown -R user:user /home/user

USER user
WORKDIR /home/user

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Oh My Zsh & minimal zshrc tweaks
RUN git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    { \
      echo "alias ll='ls -lah --color=auto'"; \
      echo "export LANG=en_US.UTF-8"; \
    } >> ~/.zshrc

RUN mkdir -p ~/.config/yazi && \
    echo -e "[preview]\nbackend = \"kitty\"" > ~/.config/yazi/config.toml

# Sync Neovim plugins
RUN nvim --headless "+Lazy! sync" +qa

CMD ["/bin/zsh"]

