export EDITOR="vim"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# Go
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/sdk/go1.24.4/bin:$PATH"

# GPG
# export GPG_TTY=$(tty)
# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# SSH
# /usr/bin/ssh-add --apple-use-keychain /Users/ryicoh/.ssh/github_ed25519 > /dev/null

