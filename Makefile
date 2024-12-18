default: install

install:
	nix run nix-darwin --extra-experimental-features 'flakes nix-command' -- switch --flake .#default --impure

fmt:
	nix fmt