# Stage 1: Base system setup with essential dependencies
FROM fedora:latest AS base

# Set Environment Variables Consistently
ENV LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  TZ=Etc/UTC \
  TERM=xterm-kitty \
  VIRTUAL_ENV=/home/user/.virtualenvs/neovim \
  PATH="/opt/nvim-linux-x86_64/bin:/home/user/.cargo/bin:/home/user/.local/bin:${VIRTUAL_ENV}/bin:$PATH"

# Install core tools, Python 3.13, CUDA toolkit, locale & timezone
RUN dnf -y update && \
  dnf -y install \
  sudo wget ca-certificates \
  kernel-devel gcc make \
  kitty ripgrep npm ImageMagick ImageMagick-devel \
  lua lua-luarocks tmux curl git zsh file procps-ng \
  python3.13 python3.13-venv sqlite-devel glibc-langpack-en tzdata \
  epel-release && \
  # Enable NVIDIA CUDA repository
  wget https://developer.download.nvidia.com/compute/cuda/repos/fedora38/x86_64/cuda-repo-fedora38-1.1-1.x86_64.rpm && \
  rpm -i cuda-repo-fedora38-1.1-1.x86_64.rpm && \
  rm cuda-repo-fedora38-1.1-1.x86_64.rpm && \
  dnf clean all && \
  # Install CUDA toolkit
  dnf -y install nvidia-cuda-toolkit && \
  # Locale and timezone setup
  localectl set-locale LANG=en_US.UTF-8 && \
  timedatectl set-timezone $TZ && \
  dnf clean all

# Add user with sudo privileges
RUN useradd -ms /bin/bash user && \
  echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user

# Stage 2: Builder – install Rust, Neovim, Quarto, configs
FROM base AS builder

# Install Neovim (cached layer)
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz && \
  tar -C /opt -xzf nvim-linux-x86_64.tar.gz && \
  rm nvim-linux-x86_64.tar.gz

# Install Rust and Cargo packages
ENV CARGO_HOME=/root/.cargo \
  RUSTUP_HOME=/root/.rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
  . "$CARGO_HOME/env" && \
  cargo install --locked yazi-fm yazi-cli && \
  rm -rf $CARGO_HOME/registry $CARGO_HOME/git

# Install Quarto CLI
RUN git clone https://github.com/quarto-dev/quarto-cli /tmp/quarto-cli && \
  cd /tmp/quarto-cli && ./configure.sh && \
  cd / && rm -rf /tmp/quarto-cli

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
  "run '~/.tmux/plugins/tpm/tpm'" > /root/.tmux.conf

# Stage 3: Final runtime – copy assets and configure user environment
FROM base AS final

# Copy built artifacts & configs
COPY --from=builder /opt/nvim-linux-x86_64 /opt/nvim-linux-x86_64
COPY --from=builder /root/.config/nvim /home/user/.config/nvim
COPY --from=builder /root/.tmux /home/user/.tmux
COPY --from=builder /root/.tmux.conf /home/user/.tmux.conf
COPY --from=builder /root/.cargo/bin /home/user/.cargo/bin
COPY --from=builder /root/.rustup /home/user/.rustup

# Fix ownership
RUN chown -R user:user /home/user

# Switch to non-root
USER user
WORKDIR /home/user

# Install uv (universal-venv) and Python packages
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
  uv venv $VIRTUAL_ENV --python python3.13 && \
  $VIRTUAL_ENV/bin/uv pip install --no-cache pynvim jupyter_client cairosvg plotly kaleido pyperclip \
  nbformat pillow ipykernel && \
  $VIRTUAL_ENV/bin/python -m ipykernel install --user --name neovim-kernel

# Install LuaMagick
RUN luarocks --local --lua-version=5.1 install magick

# Oh My Zsh + minimal zshrc tweaks
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  { \
  echo "export PATH=\"/opt/nvim-linux-x86_64/bin:/home/user/.cargo/bin:/home/user/.local/bin:${VIRTUAL_ENV}/bin:\$PATH\""; \
  echo "alias ll='ls -lah --color=auto'"; \
  echo "export LANG=en_US.UTF-8"; \
  } >> ~/.zshrc

# Final sync of plugins
RUN mkdir -p ~/.local/share/jupyter/runtime && \
  nvim --headless "+Lazy! sync" +qa

RUN curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash

CMD ["/bin/zsh"]

