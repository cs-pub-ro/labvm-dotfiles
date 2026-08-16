IMAGE ?= personal/labvm-dotfiles-test:latest

.PHONY: build run test clean

build:
	docker build -t $(IMAGE) .

# interactive shell with the dotfiles installed
run: build
	docker run --rm -it $(IMAGE) bash -c './install.sh && exec zsh -i'

# full install, then verify every component's config actually loads
test: build
	docker run -it --rm $(IMAGE) bash -c 'set -e; \
		zsh -i -c exit; \
		nvim --headless -c quit; \
		tmux -f ~/.config/tmux/tmux.conf new-session -d -s t -x 80 -y 24; \
		tmux kill-server; \
		echo OK: all dotfiles load'

run: build
	docker run -it --rm $(IMAGE) zsh

clean:
	docker rmi -f $(IMAGE) || true
