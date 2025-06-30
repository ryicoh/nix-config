default: run-all

ETC_DIR ?= /etc

run-all:
	$(MAKE) run-darwin
	$(MAKE) run-home
	$(MAKE) run-skills

run-darwin:
	@set -eu; \
	darwin_derivation=$$(nix eval --raw .#darwinConfigurations.default.system.drvPath --impure --extra-experimental-features 'flakes nix-command'); \
	makefile_hash=$$(shasum -a 256 Makefile); \
	hash=$$(printf '%s\n' "$$darwin_derivation" "$$makefile_hash" "$(ETC_DIR)" | shasum -a 256); \
	if [ -f tmp/run-darwin.sha256 ] && [ "$$hash" = "$$(cat tmp/run-darwin.sha256)" ]; then \
		echo "Skipping run-darwin: darwin configuration is unchanged"; \
		exit 0; \
	fi; \
	sudo $(MAKE) apply-darwin ETC_DIR="$(ETC_DIR)"; \
	mkdir -p tmp; \
	printf '%s\n' "$$hash" > tmp/run-darwin.sha256

apply-darwin:
	@set -eu; \
	for name in zshrc zprofile bashrc; do \
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
	sudo -u ryicoh /opt/homebrew/bin/brew trust --formula hashicorp/tap/terraform
	sudo -u ryicoh /opt/homebrew/bin/brew trust --formula lambdalisue/cclens/cclens
	nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake .#default --impure

run-home:
	nix run nixpkgs#home-manager -- switch --flake .#default

fmt:
	nix fmt --extra-experimental-features 'flakes nix-command'

# Keep global coding-agent skills in a separate declarative file.
include agent-skills.mk
