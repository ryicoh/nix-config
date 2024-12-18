default: install

install:
	-nix profile remove nix-config
	nix profile install

uninstall:
	nix profile remove nix-config
