# OpenShift v3 開発者向けハンズオン

## 準備

- このハンズオンの実行には構築済みのOpenShift Enterprise v3環境が必要です。
- ユーザは事前にocコマンドでログイン可能な状態にしておくか、もしくは全ユーザを解放するAllowポリシーの設定を行ってください。
- OpenShiftクライアントバイナリであるocコマンドはopenshift-clientsパッケージに含まれています。
  - ハンズオン実施時には一時的に以下の認証つきURLから上記と同一のocコマンドをダウンロードすることもできます。
  - TODO: add URL for Mac, Windows and Linux

## ハンズオンシナリオの説明

TODO: 概念の説明を入れる？やるとしたら最後、まず触ってもらいましょう。

1. 簡単なphpアプリケーションをGitHubに作成し、OpenShiftに登録します。
2. OpenShift上でビルドを実行し、GitのソースコードからDockerイメージをビルドしてOpenShift上に配置し、実行可能な状態にします。
3. GitHubにpushされたタイミングで自動ビルドを行うように設定します。
4. 
5. MySQLを利用するphpアプリケーションを作成します。
6. トラブルシューティング

## ログイン

```
oc login <server>:<port>
```

ログアウトを行うにはoc logoutを実行します。

ログイン状態などのOpenShift関連の情報は`~/.kube/config`に保存されており、`oc config view`で同一の内容が確認できます。

TLS接続には`--certificate-authority`オプションに対応するca.crtを指定するか、無指定の場合insecureのまま接続するかどうかの選択肢が出ますので、内部テスト利用などではca指定せずinsecure接続を選択しても良いでしょう。

## プロジェクト作成

プロジェクト名はOpenShift環境全体でユニークである必要がありますので、個人用プロジェクトは個人のidなどを名前に含めたほうが良いです。 (ex. tkimura-test-php)

```
oc new-project <project-name>
```

## アプリケーション作成

まずはgithubにリポジトリを作成し、cloneしてください。

```
git clone <repository>
```

cloneが完了したら、最初のお約束であるHello Worldを配置します。

```
cd <repository>; echo '<?php echo "Hello world"; ?>' > index.php
git commit -am 'Hello world'
git push
```

gitへpushしたらOpenShift上にアプリケーションを作成します。

```
oc new-app <app-name> <repository>
oc status
oc get all
oc expose service <app-name>
```

`oc new-app`コマンドでは、gitリポジトリのファイルによって[利用言語を自動検出](https://docs.openshift.com/enterprise/3.0/dev_guide/new_app.html#language-detection)し、適切なビルダーイメージを割り当てます。今回のようにindex.phpがあるとPHPのビルダーイメージが利用されます。Webコンソールではこの機能はないため、自分でビルダーイメージを選択する必要があります。

`oc new-app`コマンドを実行すると、実際にはbc, dc, rc, is, seという各種オブジェクト(後述します)と実行用podが作成されます。初期状態では実行用podはビルド済みイメージが未作成で見つからないためError状態となります。状態の確認には`oc status`コマンド、および`oc get all`を使用します。

## ビルドの実行とアプリケーションの確認

マニュアルでソースコードからDockerイメージを生成するビルドを実行します。成功するとDockerイメージがImageStreamに登録され、実行用podが再作成されてアプリケーションが実行されます。

``
oc start-build [name]
oc build-logs [name]-1
``

ビルドが完了すると、以下のURLでアプリケーションにアクセスすることが可能になっているはずです。

```
http://<app-name>.<your-openshift-cloud-domain>
```

## 各種コマンド

### 基本的なコマンド

- `oc status`
- `oc get all`
- `oc get [resource]`
- `oc describe [resource] [resource name]`
- `oc get all -o yaml`
- `oc build-logs [build name]`
- `oc logs [pod name]`
- `oc delete [resource] [resource name]`
- `oc delete all --all` # プロジェクトの内容全消し

### リソースのリスト

リソース名は最後に"s"をつけてもつけなくても動作します。いくつかのリソース名は名前が長いので省略形が用意されています。

- pod
- build
- route
- service, se
- buildconfig, bc
- deploymentconfig, dc
- replicationcontroller, rc
- imagestream, is
- persistentvolumeclaim, pvc

## oc get allの出力

oc get allは以下のリソースをまとめて表示します。

- buildconfig
- build
- imagestream
- deploymentconfig
- replicationcontroller
- persistentvolumeclaim
- service
- pod

## 自動ビルドの設定

`oc describe bc [name]`を実行してビルドコンフィグを参照すると、hookのURLが取得できます。このhookをGitHubのWebhookに設定したり、Webhook GenericのURLをgitのpost-updateなどのhookでcurl -X POSTで呼び出すことで自動的にビルドがトリガーされます。

```
$ oc describe bc sinatra-test
Name:			sinatra-test
Created:		2 hours ago
Labels:			<none>
Latest Version:		3
Strategy:		Source
Image Reference:	ImageStreamTag openshift/ruby:latest
Source Type:		Git
URL:			https://github.com/nekop/sinatra-test
Output to:		sinatra-test:latest
Output Spec:		<none>
Webhook GitHub:		https://ose3.example.com:8443/oapi/v1/namespaces/sinatra-test/buildconfigs/sinatra-test/webhooks/L4WnkM7uXdvQFnHElBeQ/github
Webhook Generic:	https://ose3.example.com:8443/oapi/v1/namespaces/sinatra-test/buildconfigs/sinatra-test/webhooks/hL2KPgq_QrAM3ionQ1-y/generic
Image Repository Trigger
- LastTriggeredImageID:	registry.access.redhat.com/openshift3/ruby-20-rhel7:latest
Builds:
  Name			Status		Duration	Creation Time
  sinatra-test-3 	complete 	1m49s 		2015-07-08 13:12:42 +0900 JST
  sinatra-test-2 	failed 		51s 		2015-07-08 13:08:00 +0900 JST
  sinatra-test-1 	complete 	1m49s 		2015-07-08 13:06:58 +0900 JST
```

TODO: github hookの設定方法のURL

## データベースの追加

MySQL

(Optional) MySQL init script handling

## テンプレート

## テスト環境、ステージング環境へのリリース

## トラブルシューティング

## アプリケーションログ

## チーム作業

## デモ

### Docker image deploy
### スケール
### 障害復旧
### OSパッチ
### ロールバック

## Jenkins連携

残念ながら、OpenShift v3のJenkinsサポートは未実装です。今年中にリリースされる3.1でJenkinsサポートが実装される予定です。

通常のJenkins連携の設定はもちろん可能です。

## Other

