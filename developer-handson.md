# OpenShift v3 開発者向けハンズオン

## 準備

- このハンズオンの実行には構築済みのOpenShift Enterprise v3環境が必要です。Persistent Volumeは利用していません。
- ユーザは事前にocコマンドでログイン可能な状態にしておくか、もしくは全ユーザを解放するAllowポリシーの設定を行ってください。
- 多人数で行う場合はDocker registryのディスクの空き容量に注意してください。
- GitHub Enterpriseとの連携を行うためには、OpenShift EnterpriseとGitHub Enterpriseのネットワークが相互通信可能である必要があります。
- OpenShiftクライアントバイナリであるocコマンドはopenshift-clientsパッケージに含まれています。
  - ハンズオン実施時には一時的に以下の認証つきURLから上記と同一のocコマンドをダウンロードすることもできます。
  - TODO: add URL for Mac, Windows and Linux

## OpenShiftとは

Dockerコンテナでアプリケーションを動作させるためのPaaS (Platform as a Service)基盤です。アプリケーションをDockerコンテナ上でビルドしてDockerイメージを作成し、Dockerコンテナとして動作させることができます。

簡単なコマンド操作でアプリケーションを配置したり、複製したり、MySQLを起動するなど、Dockerコンテナ群を自由にコントロールすることができます。

## ハンズオンシナリオの説明

1. 簡単なphpアプリケーションをGitHubに作成し、OpenShiftに登録します。
2. OpenShift上でビルドを実行し、GitのソースコードからDockerイメージをビルドしてOpenShift上に配置し、実行可能な状態にします。
3. GitHubにpushされたタイミングで自動ビルドを行うように設定します。
4. 
5. MySQLを利用するphpアプリケーションを作成します。
6. トラブルシューティング

## OpenShift Clientコマンド

OpenShift Clientコマンドは`oc`という単一の実行ファイルです。OpenShift Enterpriseのopenshift-clientsパッケージに含まれているので、管理者の方がどこかのWebサーバなどに配置して利用者にダウンロードできるようにしてください。

また、利用者ではなく管理者が利用するコマンド`oadm`というコマンドもあります。マニュアルなどに`oadm`コマンド例が出てきた場合は、管理者作業を意味します。

## ログイン

```
oc login <server>:<port>
```

ログアウトを行うにはoc logoutを実行します。

ログイン状態などのOpenShift関連の情報は`~/.kube/config`に保存されており、`oc config view`で同一の内容が確認できます。

TLS接続には`--certificate-authority`オプションに対応するca.crtを指定するか、無指定の場合insecureのまま接続するかどうかの選択肢が出ますので、内部テスト利用などではca指定せずinsecure接続を選択しても良いでしょう。

## プロジェクト作成

プロジェクト名はOpenShift環境全体でユニークである必要がありますので、個人用プロジェクトは個人のidなどを名前に含めたほうが良いです(ex. `tkimura-test-php`)。また、OpenShiftの設計上、プロジェクト名は後からリネームすることはできません。プロジェクト情報をダンプして修正して取り込むことで、同一構成を新しい名前プロジェクトにすることは簡単にできます。

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
git add index.php
git commit -m 'Hello world'
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

`oc types`で全てのリストと説明が表示されます。

- pod
- build
- route
- service, se
- buildconfig, bc
- deploymentconfig, dc
- replicationcontroller, rc
- imagestream, is
- persistentvolumeclaim, pvc

### oc get allの出力

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
$ oc describe bc hello-php
Name:			hello-php
Created:		28 seconds ago
Labels:			<none>
Latest Version:		1
Strategy:		Source
Image Reference:	ImageStreamTag openshift/php:latest
Source Type:		Git
URL:			https://github.com/nekop/hello-php
Output to:		hello-php:latest
Output Spec:		<none>
Webhook GitHub:		https://ose3.example.com:8443/oapi/v1/namespaces/hello-php/buildconfigs/hello-php/webhooks/g3igOAnHOjzENk7n6gQq/github
Webhook Generic:	https://ose3.example.com:8443/oapi/v1/namespaces/hello-php/buildconfigs/hello-php/webhooks/5VKy_GmzLooTDmDYw1bH/generic
Image Repository Trigger
- LastTriggeredImageID:	registry.access.redhat.com/openshift3/php-55-rhel7:latest
Builds:
  Name		Status		Duration	Creation Time
  hello-php-1 	running 	running for 1s 	2015-07-12 16:55:49 +0900 JST
```

GitHubのリポジトリのページから、`Settings` -> `Webhooks & services` -> `Add webhook`でWebhookの追加が行えます。

OpenShiftはhookからブランチ名などを取得し、ビルド要否を判断して自動ビルドを行います。

## データベースの追加とテンプレート

データベースなどの追加ソフトウェアなどはテンプレートという機構で管理します。今回はmysql-ephemeralというテンプレートを利用します。

全ユーザが利用できるテンプレートはopenshiftプロジェクトに定義されています。以下のコマンドでテンプレートの一覧と、各テンプレートの情報を取得できます。

```
oc get template -n openshift
oc describe template mysql-ephemeral -n openshift
```

テンプレートから実際にオブジェクトを生成するには`oc new-app`コマンドを利用します。`oc new-app`コマンドは表向きの概念としてはアプリケーションを作る、というものでありコマンド名もそのようになっていますが、実際にはアプリケーションに必要なオブジェクトを生成するコマンドです。

MySQLはデータベース名やユーザ名にハイフンは利用できないので注意してください。もし入力してしまってMySQLが起動しない場合は`oc edit dc hello-php-mysql`で修正でき、DeploymentConfigの変更トリガーはデフォルトで有効になっているので自動で再デプロイされます。

```
oc new-app --template=mysql-ephemeral --param=DATABASE_SERVICE_NAME=hello-php-mysql,MYSQL_DATABASE=hello,MYSQL_USER=user,MYSQL_PASSWORD=pass
```

テンプレートはデータベースの追加以外にも、任意の構成を簡単に作るための用途に幅広く利用できます。

## データベースへの接続

phpアプリケーションからデータベースへ接続するためにはMySQLへの接続情報をphp側へ設定する必要があります。接続情報は上記の情報を渡せば良いのですが、`oc env --list`コマンドでも参照できます。

```
oc env dc hello-php-mysql --list
```

`oc env`コマンドを利用してphpアプリケーションへ接続情報を設定します。

```
oc env dc hello-php MYSQL_USER=user MYSQL_PASSWORD=pass MYSQL_DATABASE=hello
```

MySQLのホスト名が無いことに気付いたでしょうか。MySQLのサービスホスト名はKubernetesにより自動的に環境変数設定されます。サービス名を大文字にして`_SERVICE_HOST`を付与した環境変数に格納されています。今回はMySQLのサービス名は`hello-php-mysql`なので、`HELLO_PHP_MYSQL_SERVICE_HOST`となります。もし単純に`database`というサービス名にした場合は`DATABASE_SERVICE_HOST`になります。

`index.php`を作成したデータベースに接続するように変更します。

```php
<?php

echo "<h1>Hello world</h1>";
$mysqli = new mysqli(getenv("HELLO_PHP_MYSQL_SERVICE_HOST"), getenv("MYSQL_USER"), getenv("MYSQL_PASSWORD"), getenv("MYSQL_DATABASE"));
if ($mysqli->connect_error) {
    exit($mysqli->connect_error);
} else {
    $mysqli->set_charset("utf8");
}
$result = $mysqli->query("select 1") or exit($mysqli->error());
echo var_dump($result->fetch_assoc());
$mysqli->close();

?>
```

## トラブルシューティング

```
oc logs [pod-name]
oc build-logs [build-name]
```

ハンズオン中に実際にトラブルが発生したものを例に挙げてフォローおよび解説する予定です。何もトラブルがなかったらごめんなさい。

## アプリケーションログ

## チーム作業

## デモ

### チームでの開発環境、テスト環境、本番環境の管理

joe, aliceそしてbenの開発者が小さなphp/mysqlプロジェクト`greenhat`でチーム開発を行います。チーム開発のセットアップは現状`oadm`コマンドを利用する必要があり、OpenShift管理者によるオペレーションが必要です。

プロジェクトを作成し、joe, aliceとbenを管理者として登録します。チームのプロジェクトなので、特に個人名などは付与しません。

```
oadm new-project greenhat --admin="joe"
oc project greenhat
oadm add-role-to-user admin alice
oadm add-role-to-user admin ben
oc project default
```

joeがこのプロジェクトを構成していきます。もちろんaliceでもbenでもこの作業は可能です。

```
oc new-app http://github.example.jp/greenhat/greenhat
oc expose se greenhat
```

この後にWebhookで自動ビルドを設定します。これでGitのgreenhatのmasterブランチである開発バージョンは`greenhat.cloudapps.example.jp`で常にビルドされて公開される状態になりました。masterブランチにpull requestがマージされて更新されるたびに開発バージョンがアップデートされて自動デプロイされます。

joe, alice, ben各個人はこのリポジトリをforkして、OpenShift上hでは個人のプロジェクトへ`new-app`を発行し、自動ビルドを設定します。

続いてテスト環境と本番環境を作成します。別環境へのリリースはgitベースとDockerイメージベースの2つのアプローチがあります。

#### Gitベースの管理

最初はgitのブランチとして管理する方法です。testブランチを作って、そちらを新しいアプリケーションとして`test-greenhat`という名前で登録します。開発版からテスト環境へデプロイする場合はtestブランチへpushします。必要に応じてタグも付与すると良いでしょう。

```
oc new-app http://github.example.jp/greenhat/greenhat#test --name=test-greenhat
oc expose se test-greenhat
```

テスト環境はテスト中などに誤って更新されても困るので、自動ビルドは設定しなくても良いでしょう。マニュアルでstart-buildします。本番環境も同じようにブランチを作成して設定します。

#### Dockerイメージベースの管理

テスト環境用の`test`, 本番環境用の`prod`というタグをImageStreamに作成しておきます。ImageStreamのtagは実際にはgitのブランチのように機能し、過去にタグ付けされたイメージの履歴を全て保持しています。

```
oc tag library/greenhat:latest greenhat:test
oc tag library/greenhat:latest greenhat:prod
```

次に、開発バージョンのDeploymentConfig, Service, Routeを複製します。ImageStreamは共用しますし、テスト環境や本番環境はビルドを行わないのでBuildConfigはありません。

```
oc export dc greenhat -o json >> test-greenhat.json
oc export se greenhat -o json >> test-greenhat.json
oc export route greenhat -o json >> test-greenhat.json
```

出力されたJSONファイルの`greenhat`を`test-greenhat`や`prod-greenhat`に置換するのですが、`ImageStreamTag`と`image`の部分に含まれる`greenhat`は置換対象から外します。

`ImageStreamTag`に`greenhat:latest`が定義されていますので、`greenhat:test`, `greenhat:prod`へ変更します。

```
{
    "type": "ImageChange",
    "imageChangeParams": {
        "automatic": true,
        "containerNames": [
            "greenhat"
        ],
        "from": {
            "kind": "ImageStreamTag",
            "name": "greenhat:latest"
        }
    }
}
```


ここまで行なったらOpenShiftのmaster APIサーバへ流し込みます。

```
cat test-greenhat.json | oc create -f -
```

これで準備は完了です。`test`タグが付けられたイメージが存在していないので、初回のデプロイは失敗します。

`oc describe is greenhat`を実行して、適当なイメージに`test`タグを付与します。

```
oc tag greenhat@sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx greenhat:test
```

タグ付けを行うとイメージを検出してテスト環境へのデプロイが実行され、イメージはテスト環境へとリリースされます。本番環境も同様にリリースできます。

### Docker image deploy
### スケール
### 障害復旧
### OSパッチ
### ロールバック
### ローリングアップデート
### Gitトピックブランチ方式開発

### Jenkins連携

残念ながら、OpenShift v3のJenkinsサポートは未実装です。今年中にリリースされる3.1でJenkinsサポートが実装される予定であり、手動でJenkins連携の設定をするよりは簡単に設定ができるようになる予定です。

開発版ではサンプルアプリケーションとしてのJenkinsの定義が提供されています。 https://github.com/openshift/origin/tree/master/examples/jenkins

TODO: 時間があればサンプルを実際にデモします。

## よくある質問

- oc get allの出力が古いもので埋まって見づらいのはどうしたらいいですか？

## リファレンス

- [英語公式ドキュメント](https://docs.openshift.com/enterprise/3.0/welcome/index.html)

