# Global agent skills

`make` runs nix-darwin, Home Manager, then `run-skills` as the invoking user.
`run-skills` saves the SHA-256 hash of `agent-skills.mk` in `tmp/run-skills.sha256`
after a successful installation. Later runs skip installation while the file is unchanged.
The skill selection is defined in [`agent-skills.mk`](../agent-skills.mk), not inferred from whatever happens to be installed.

```sh
make run-skills   # Install the declared global skills when agent-skills.mk changes
make skills-list  # Show currently installed global Codex skills
```

The external skills use `npx skills add <source> -g -a codex -y --skill ...`.
They are **not version-pinned**: a run after changing `agent-skills.mk` may fetch
updated versions. Delete `tmp/run-skills.sha256` to refresh without changing the
manifest.
The installer is additive: it does not uninstall other skills. Edit `agent-skills.mk` to change the declared set.

The 28 entries match the provided `npx skills list -g` inventory from 2026-10-29:
25 from `addyosmani/agent-skills`, `find-skills` from `vercel-labs/skills`,
`natural-japanese` from `coji/natural-japanese`, and the local `worktree-cleanup` skill.

`worktree-cleanup` was originally listed with `Source: local`, so its original
installed content cannot be recovered from this repository. The checked-in
[`SKILL.md`](../skills/worktree-cleanup/SKILL.md) is a **safe reconstruction**
from the known cleanup criteria, not a byte-for-byte copy. On machines where
`~/.agents/skills/worktree-cleanup/SKILL.md` already exists, `make run-skills`
preserves that version without overwriting it. For exact reproducibility,
replace the checked-in fallback with the original local `SKILL.md`.

The current manifest installs for Codex, matching the reported inventory.
To also install to Claude Code, append `-a claude-code` to each installation
command in `agent-skills.mk`; review the local-skill preservation behavior as well.

Requirements: Node.js (version supported by `skills`), `npx`, and network
access for external GitHub sources. The Nix/darwin setup already includes Node.
