# `make`の実行

`make`はdarwin、Home Manager、agent skillsの順に実行します。
`run-home`は毎回実行します。

`run-darwin`はdarwin構成の導出パス、Makefile、`ETC_DIR`から作ったハッシュを
`tmp/run-darwin.sha256`に記録します。前回成功時と同じなら、darwinの切り替えを省略します。
Home Managerだけの変更はdarwin構成の導出パスに影響しません。

darwinの切り替えを再実行したい場合は、`tmp/run-darwin.sha256`を削除してから
`make run-darwin`を実行します。
