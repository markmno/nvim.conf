# Stage 1: Base system setup with essential dependencies
FROM debian:trixie AS base

# Set Environment Variables Consistently
ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  TZ=Etc/UTC \
  TERM=xterm-kitty \
  # Define VIRTUAL_ENV path early
  VIRTUAL_ENV=/home/user/.virtualenvs/neovim \
  # Update PATH once, including potential future locations early
  PATH="/opt/nvim-linux-x86_64/bin:/home/user/.cargo/bin:/home/user/.local/bin:${VIRTUAL_ENV}/bin:$PATH"

# Install core dependencies, Python 3.12, and setup locale/timezone
# Added python3.12, python3.12-venv and removed python3.13-venv
# Added curl earlier as it's needed for uv install later
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo build-essential kitty ripgrep npm imagemagick libmagickwand-dev \
  lua5.1 luarocks tmux curl git zsh file procps ueberzug \
  python3.13 python3.13-venv libsqlite3-dev locales tzdata ca-certificates && \
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
RUN curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz && \
  tar -C /opt -xzf nvim-linux-x86_64.tar.gz && rm nvim-linux-x86_64.tar.gz

# Install Rust and Cargo, and a Cargo package (yazi)
# Using root's home for cargo build cache
ENV CARGO_HOME=/root/.cargo
ENV RUSTUP_HOME=/root/.rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
  . "$CARGO_HOME/env" && \
  cargo install --locked yazi-fm yazi-cli && \
  # Clean cargo cache after build
  rm -rf $CARGO_HOME/registry $CARGO_HOME/git

# Install Quarto CLI
# Building in /tmp to avoid leaving source in final image if something goes wrong
RUN git clone https://github.com/quarto-dev/quarto-cli /tmp/quarto-cli && \
  cd /tmp/quarto-cli && ./configure.sh && cd / && rm -rf /tmp/quarto-cli

# Clone Neovim configuration and Tmux plugins (as root, will be copied later)
RUN git clone https://github.com/markmno/nvim.conf.git /root/.config/nvim && \
  mkdir -p /root/.tmux/plugins && \
  git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm

# Create tmux configuration file (as root)
RUN echo "set -g @plugin 'tmux-plugins/tpm'" > /root/.tmux.conf && \
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
COPY --from=builder /opt/nvim-linux-x86_64 /opt/nvim-linux-x86_64
COPY --from=builder /root/.config/nvim /home/user/.config/nvim
COPY --from=builder /root/.tmux /home/user/.tmux
COPY --from=builder /root/.tmux.conf /home/user/.tmux.conf
# Copy cargo binaries and necessary files, not the whole cache
COPY --from=builder /root/.cargo/bin /home/user/.cargo/bin
COPY --from=builder /root/.rustup /home/user/.rustup

# Set ownership for user on copied files
RUN chown -R user:user /home/user/.config /home/user/.tmux /home/user/.tmux.conf /home/user/.cargo /home/user/.rustup

# Switch to the non-root user
USER user
WORKDIR /home/user

# --- pyenv setup for user removed ---

# Install uv using the recommended installer
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure uv is in the PATH for subsequent RUN commands (though already added via ENV)
ENV PATH="/home/user/.cargo/bin:${PATH}"

# Configure virtual environment using uv and install Python packages
# Using the system Python 3.12 installed via apt
RUN uv venv $VIRTUAL_ENV --python python3.13 && \
  # Activate isn't strictly needed if we call the uv/python in the venv directly
  # Install packages using uv into the created environment
  $VIRTUAL_ENV/bin/uv pip install --no-cache pynvim jupyter_client cairosvg plotly kaleido pyperclip \
  nbformat pillow ipykernel && \
  # Install the kernel using the Python from the virtual environment
  $VIRTUAL_ENV/bin/python -m ipykernel install --user --name neovim-kernel

# Install Lua magick rock for image processing support
RUN luarocks --local --lua-version=5.1 install magick

# Minimal Zsh configuration & Oh My Zsh install
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
  # Add PATH exports and aliases to .zshrc (ensure VIRTUAL_ENV is expanded)
  # The main PATH is already set via ENV, but repeating for shell session consistency is fine.
  echo "export PATH=\"/opt/nvim-linux-x86_64/bin:/home/user/.cargo/bin:/home/user/.local/bin:${VIRTUAL_ENV}/bin:\$PATH\"" >> ~/.zshrc && \
  echo "alias ll='ls -lah --color=auto'" >> ~/.zshrc && \
  # LANG is set globally via ENV, but can be reinforced here if needed
  echo "export LANG=C.UTF-8" >> ~/.zshrc

# Create necessary Jupyter directory and sync Neovim plugins
RUN mkdir -p ~/.local/share/jupyter/runtime && \
  # Ensure Neovim uses the Python from the virtual environment
  nvim --headless "+Lazy! sync" +qa

# Set default shell to Zsh
CMD ["/bin/zsh"]
