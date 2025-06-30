default: run-all

run-all:
	sudo $(MAKE) run-darwin
	$(MAKE) run-home

run-darwin:
	nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake .#default --impure

run-home:
	nix run nixpkgs#home-manager -- switch --flake .#default

fmt:
	nix fmt --extra-experimental-features 'flakes nix-command'
