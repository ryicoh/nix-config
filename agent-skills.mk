# Global Codex skills listed by `npx skills list -g` (2026-10-29).
# Add or remove names here to manage the desired set.
# The upstream skills are installed from their latest default branches.

ADDYOSMANI_SKILLS := \
	api-and-interface-design \
	browser-testing-with-devtools \
	ci-cd-and-automation \
	code-review-and-quality \
	code-simplification \
	constraint-driven-development \
	context-engineering \
	debugging-and-error-recovery \
	deprecation-and-migration \
	documentation-and-adrs \
	doubt-driven-development \
	frontend-ui-engineering \
	git-workflow-and-versioning \
	idea-refine \
	incremental-implementation \
	interview-me \
	observability-and-instrumentation \
	performance-optimization \
	planning-and-task-breakdown \
	security-and-hardening \
	shipping-and-launch \
	source-driven-development \
	spec-driven-development \
	test-driven-development \
	using-agent-skills

.PHONY: run-skills skills-list

run-skills:
	@command -v node >/dev/null 2>&1 || { echo "Node.js is required for npx skills" >&2; exit 1; }
	@npx --yes skills add addyosmani/agent-skills -g -a codex claude-code -y $(addprefix --skill ,$(ADDYOSMANI_SKILLS))
	@npx --yes skills add vercel-labs/skills -g -a codex claude-code -y --skill find-skills
	@npx --yes skills add coji/natural-japanese -g -a codex claude-code -y --skill natural-japanese
	@npx --yes skills add PostHog/posthog -g -a codex claude-code -y \
		--skill writing-code-comments \
		--skill writing-pr-descriptions \
		--skill writing-tests
	@npx --yes skills add getsentry/skills -g -a codex claude-code -y --skill skill-writer

skills-list:
	@npx --yes skills list -g -a codex -a codex
