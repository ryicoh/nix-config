# SSH 周りの設定方法

## FIDO2 対応のセキュリティーキーを使用して SSH 接続する

```zsh
% ssh-keygen -t ed25519-sk -f ~/.ssh/github_ed25519_sk -C "ryicoh@gmail.com" -O resident -O verify-required -O application=ssh:github
```

説明:

- `-t ed25519-sk`: 使用する鍵の種類
- `-C "ryicoh@gmail.com"`: 鍵のコメント
- `-O resident`: 鍵をデバイスに保存する
- `-O verify-required`: 鍵の検証を要求する
- `-O application=ssh:github`: 鍵の名前を指定する

- `-f ~/.ssh/github_ed25519_sk`: 鍵を保存する場所を指定する

## セキュリティキーから SSH 鍵をリストア

```zsh
% ssh-keygen -K
```

# GitHub の SSH 鍵を作成

```zsh
% ssh-keygen -t ed25519 -f ~/.ssh/github_ed25519 -C "ryicoh@gmail.com"
```

パスフレーズは必ず入れる

他のssh周りの設定は、ssh_config と gitconfig を参照
認証もコミット署名もやってくれる