# OpenShift v3 開発者向けハンズオン

## 準備

- このハンズオンの実行には構築済みのOpenShift v3環境が必要です。
- ユーザは事前にログイン可能な状態にしておくか、もしくは全ユーザを解放するAllowポリシーの設定を行ってください。
- OpenShiftクライアントバイナリであるocコマンドはopenshift-clientパッケージに含まれています。
  - ハンズオン実施時には一時的に以下の認証つきURLから上記と同一のocコマンドをダウンロードすることもできます。
  - TODO: add URL

## ログイン

```
oc login <server>:<port>
```

ログアウトを行うにはoc logoutを実行します。

ログイン状態などのOpenShift関連の情報は`~/.kube/config`に保存されます。

TLS接続には`--certificate-authority`オプションに対応するca.crtを指定するか、無指定の場合insecureのまま接続するかどうかの選択肢が出ますので、内部テスト利用などではca指定せずinsecure接続を選択しても良いでしょう。

## プロジェクト作成

```
oc new-project <project-name>
```

## アプリケーション作成

まずはgithubにリポジトリを作成し、cloneしてください。

```
git clone <repository>
```

cloneが完了したら、まず最初のお約束であるHello Worldを配置します。

```
cd <repository>; echo '<?php echo "Hello world"; ?>' > index.php
git commit -am 'Hello world'
git push
```

gitへpushしたらOpenShift上にアプリケーションを作成します。

```
oc new-app <app-name> <repository>
```

`oc new-app`コマンドでは、gitリポジトリのファイルによって[言語を自動検出](https://docs.openshift.com/enterprise/3.0/dev_guide/new_app.html#language-detection)し、適切なビルダーイメージを割り当てます。Webコンソールではこの機能はないため、自分でビルダーイメージを選択する必要があります。

## ビルドの実行

マニュアルビルド、確認

## 自動ビルドの設定

Githubへのhookの設定

## データベースの追加

MySQL

## (Optional) MySQL init script handling

## テンプレート

## Jenkins連携

- OpenShiftのJenkinsサポートは未実装
- ふつうにJenkins起動してふつうにJenkins設定するしかない
- JenkinsをDockerイメージにする方法、os, php, ruby実行環境を包含しないといけないのでマニュアルで作るのは若干ヘビー
- 共用のJenkins使う?
- そもそもOpenShift特有の連携方法が今のところないのであまり嬉しくない
- 7/10 3amにOpenShift CIのセッションがある

## ルート追加

oc expose

## チーム作業


