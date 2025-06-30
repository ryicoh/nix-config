default: run-all

ETC_DIR ?= /etc

run-all:
	sudo $(MAKE) run-darwin
	$(MAKE) run-home

run-darwin:
	@set -eu; \
	for name in zshrc zprofile; do \
		file="$(ETC_DIR)/$$name"; \
		if [ -L "$$file" ] || [ ! -e "$$file" ]; then continue; fi; \
		backup="$$file.before-nix-darwin"; \
		if [ -e "$$backup" ]; then \
			if ! cmp -s "$$backup" "$$file"; then \
				echo "Existing backup differs from $$file:"; \
				diff -u "$$backup" "$$file" || true; \
			fi; \
		fi; \
		n=1; \
		while [ -e "$$backup" ] || [ -L "$$backup" ]; do \
			backup="$$file.before-nix-darwin.$$n"; \
			n=$$((n + 1)); \
		done; \
		mv "$$file" "$$backup"; \
		echo "Moved $$file to $$backup"; \
	done
	nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake .#default --impure

run-home:
	nix run nixpkgs#home-manager -- switch --flake .#default

fmt:
	nix fmt --extra-experimental-features 'flakes nix-command'
