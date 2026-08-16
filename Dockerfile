FROM debian:13

RUN apt-get update && apt-get install -y --no-install-recommends \
        zsh git rsync wget build-essential tmux fzf ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# latest official neovim release (prebuilt, self-contained)
RUN wget -qO- https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    | tar -xz -C /usr/local --strip-components=1

COPY . /opt/dotfiles
WORKDIR /opt/dotfiles
RUN ./install.sh

