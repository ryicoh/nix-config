# Global Codex skills listed by `npx skills list -g` (2026-10-29).
# Add or remove names here to manage the desired set.
# The upstream skills are installed from their latest default branches.

ADDYOSMANI_SKILLS := \
	api-and-interface-design \
	code-review-and-quality \
	code-simplification \
	debugging-and-error-recovery \
	deprecation-and-migration \
	documentation-and-adrs \
	doubt-driven-development \
	frontend-ui-engineering \
	git-workflow-and-versioning \
	incremental-implementation \
	interview-me \
	performance-optimization \
	planning-and-task-breakdown \
	security-and-hardening \
	source-driven-development \
	spec-driven-development \
	test-driven-development

.PHONY: run-skills skills-list

run-skills:
	@set -eu; \
	hash=$$(shasum -a 256 agent-skills.mk); \
	if [ -f tmp/run-skills.sha256 ] && [ "$$hash" = "$$(cat tmp/run-skills.sha256)" ]; then \
		echo "Skipping run-skills: agent-skills.mk is unchanged"; \
		exit 0; \
	fi; \
	command -v node >/dev/null 2>&1 || { echo "Node.js is required for npx skills" >&2; exit 1; }; \
	npx --yes skills add addyosmani/agent-skills -g -a codex claude-code -y $(addprefix --skill ,$(ADDYOSMANI_SKILLS)); \
	npx --yes skills add vercel-labs/skills -g -a codex claude-code -y --skill find-skills; \
	npx --yes skills add coji/natural-japanese -g -a codex claude-code -y --skill natural-japanese; \
	mkdir -p tmp; \
	printf '%s\n' "$$hash" > tmp/run-skills.sha256

skills-list:
	@npx --yes skills list -g -a codex -a codex
