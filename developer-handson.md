<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [OpenShift v3 開発者向けハンズオン](#openshift-v3-%E9%96%8B%E7%99%BA%E8%80%85%E5%90%91%E3%81%91%E3%83%8F%E3%83%B3%E3%82%BA%E3%82%AA%E3%83%B3)
  - [準備](#%E6%BA%96%E5%82%99)
  - [OpenShiftとは](#openshift%E3%81%A8%E3%81%AF)
  - [ハンズオンシナリオの説明](#%E3%83%8F%E3%83%B3%E3%82%BA%E3%82%AA%E3%83%B3%E3%82%B7%E3%83%8A%E3%83%AA%E3%82%AA%E3%81%AE%E8%AA%AC%E6%98%8E)
  - [OpenShift Clientコマンド](#openshift-client%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89)
  - [ログイン](#%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3)
  - [プロジェクト作成](#%E3%83%97%E3%83%AD%E3%82%B8%E3%82%A7%E3%82%AF%E3%83%88%E4%BD%9C%E6%88%90)
  - [アプリケーション作成](#%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E4%BD%9C%E6%88%90)
  - [ビルドの実行とアプリケーションの確認](#%E3%83%93%E3%83%AB%E3%83%89%E3%81%AE%E5%AE%9F%E8%A1%8C%E3%81%A8%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E7%A2%BA%E8%AA%8D)
  - [各種コマンド](#%E5%90%84%E7%A8%AE%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89)
    - [基本的なコマンド](#%E5%9F%BA%E6%9C%AC%E7%9A%84%E3%81%AA%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89)
    - [リソースのリスト](#%E3%83%AA%E3%82%BD%E3%83%BC%E3%82%B9%E3%81%AE%E3%83%AA%E3%82%B9%E3%83%88)
    - [oc get allの出力](#oc-get-all%E3%81%AE%E5%87%BA%E5%8A%9B)
  - [自動ビルドの設定](#%E8%87%AA%E5%8B%95%E3%83%93%E3%83%AB%E3%83%89%E3%81%AE%E8%A8%AD%E5%AE%9A)
  - [データベースの追加とテンプレート](#%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E3%81%AE%E8%BF%BD%E5%8A%A0%E3%81%A8%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88)
  - [データベースへの接続](#%E3%83%87%E3%83%BC%E3%82%BF%E3%83%99%E3%83%BC%E3%82%B9%E3%81%B8%E3%81%AE%E6%8E%A5%E7%B6%9A)
  - [トラブルシューティング](#%E3%83%88%E3%83%A9%E3%83%96%E3%83%AB%E3%82%B7%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0)
  - [デモ](#%E3%83%87%E3%83%A2)
    - [チームでの開発環境、テスト環境、本番環境の管理](#%E3%83%81%E3%83%BC%E3%83%A0%E3%81%A7%E3%81%AE%E9%96%8B%E7%99%BA%E7%92%B0%E5%A2%83%E3%80%81%E3%83%86%E3%82%B9%E3%83%88%E7%92%B0%E5%A2%83%E3%80%81%E6%9C%AC%E7%95%AA%E7%92%B0%E5%A2%83%E3%81%AE%E7%AE%A1%E7%90%86)
      - [Gitベースの管理](#git%E3%83%99%E3%83%BC%E3%82%B9%E3%81%AE%E7%AE%A1%E7%90%86)
      - [Dockerイメージベースの管理](#docker%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%83%99%E3%83%BC%E3%82%B9%E3%81%AE%E7%AE%A1%E7%90%86)
    - [Dockerイメージのデプロイ](#docker%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%81%AE%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4)
    - [スケールとローリングアップデート](#%E3%82%B9%E3%82%B1%E3%83%BC%E3%83%AB%E3%81%A8%E3%83%AD%E3%83%BC%E3%83%AA%E3%83%B3%E3%82%B0%E3%82%A2%E3%83%83%E3%83%97%E3%83%87%E3%83%BC%E3%83%88)
    - [ロールバック](#%E3%83%AD%E3%83%BC%E3%83%AB%E3%83%90%E3%83%83%E3%82%AF)
    - [障害復旧](#%E9%9A%9C%E5%AE%B3%E5%BE%A9%E6%97%A7)
    - [OSおよびミドルウェアのパッチ](#os%E3%81%8A%E3%82%88%E3%81%B3%E3%83%9F%E3%83%89%E3%83%AB%E3%82%A6%E3%82%A7%E3%82%A2%E3%81%AE%E3%83%91%E3%83%83%E3%83%81)
    - [テンプレート作成](#%E3%83%86%E3%83%B3%E3%83%97%E3%83%AC%E3%83%BC%E3%83%88%E4%BD%9C%E6%88%90)
    - [Jenkins連携](#jenkins%E9%80%A3%E6%90%BA)
  - [よくある質問](#%E3%82%88%E3%81%8F%E3%81%82%E3%82%8B%E8%B3%AA%E5%95%8F)
  - [リファレンス](#%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# OpenShift v3 開発者向けハンズオン

## 準備

- このハンズオンの実行には構築済みのOpenShift Enterprise v3環境が必要です。Persistent Volumeは利用していません。
- ユーザは事前にocコマンドでログイン可能な状態にしておくか、もしくは全ユーザを解放するAllowポリシーの設定を行ってください。
- 多人数で行う場合はDocker registryのディスクの空き容量に注意してください。
- GitHub Enterpriseとの連携を行うためには、OpenShift EnterpriseとGitHub Enterpriseのネットワークが相互通信可能である必要があります。また、[Using self-signed SSL certificates](https://help.github.com/enterprise/11.10.340/admin/articles/using-self-signed-ssl-certificates/)の通りに`/etc/openshift/master/ca.crt`をGitHub Enterprise側にインストールする必要があります。
- OpenShiftクライアントバイナリであるocコマンドはopenshift-clientsパッケージに含まれています。
  - ハンズオン実施時には一時的に以下のURLから上記と同一のocコマンドをダウンロードすることもできます。
  - [Mac OS X](http://people.redhat.com/tkimura/ose3/macosx/oc.zip) [Linux](http://people.redhat.com/tkimura/ose3/linux/oc.zip) [Windows](http://people.redhat.com/tkimura/ose3/windows/oc.zip)

## OpenShiftとは

Dockerコンテナでアプリケーションを動作させるためのPaaS (Platform as a Service)基盤です。アプリケーションをDockerコンテナ上でビルドしてDockerイメージを作成し、Dockerコンテナとして動作させることができます。

簡単なコマンド操作でアプリケーションを配置したり、複製したり、MySQLを起動するなど、Dockerコンテナ群を自由にコントロールすることができます。

![OpenShift marketecture](https://raw.githubusercontent.com/nekop/openshift-sandbox/wip/marketecture.jpg)

## ハンズオンシナリオの説明

1. 簡単なphpアプリケーションをGitHubに作成し、OpenShiftに登録します。
2. OpenShift上でビルドを実行し、GitのソースコードからDockerイメージをビルドしてOpenShift上に配置し、実行可能な状態にします。
3. GitHubにpushされたタイミングで自動ビルドを行うように設定します。
4. MySQLを利用するphpアプリケーションを作成します。
5. ログを

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
- `oc describe [resource] [resource-name]`
- `oc get all -o yaml`
- `oc build-logs [build-name]`
- `oc logs [pod-name]`
- `oc delete [resource] [resource-name]`
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

OpenShiftはhookからブランチ名などを取得し、ビルド要否を判断して自動ビルドを行います。Webhookからのビルドでは、`oc describe build`や`oc describe isimage`の出力にgitのcommit SHA-1値が含まれるようになります。

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

ビルドに失敗した場合は`oc build-logs`でビルドログを参照します。

```
oc build-logs [build-name]
```

デプロイに失敗した、もしくはデプロイは成功しているが正常に動いていない、という場合は`oc logs`で対象podのログを参照します。デプロイのリトライは`oc deploy --retry`で行うことができます。

```
oc logs [pod-name]
oc deploy [dc-name] --retry
```

ビルドやデプロイはnew-appの直後などはタイミングの問題により失敗したりします。その場合は少し待ってから再実行すると成功します。

コンテナの内部を調べたい場合は`oc exec`を利用します。しかし、Dockerコンテナの中は通常最低限のツールのみがインストールされている状態ですので、あまりできることは多くありません。コンテナの中のファイルの確認などには便利です。

```
oc exec -it -p [pod-name] bash
```

ハンズオン中に実際にトラブルが発生したものを例に挙げてフォローおよび解説する予定です。何もトラブルがなかったらごめんなさい。

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

joe, alice, ben各個人はこのリポジトリをforkして、OpenShift上では個人のプロジェクトへ`new-app`を発行し、自動ビルドを設定します。各個人は各個人の環境で開発を行い、プロジェクトのgitリポジトリへPull Requestを送信します。

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

この利用方法での`oc describe is`の出力例ですが、以下のようになります。devがv4、testがv3、prodはv2がデプロイされています。

```
$ oc describe is hello-php
Name:			hello-php
Created:		25 hours ago
Labels:			<none>
Docker Pull Spec:	172.30.55.101:5000/hello-php/hello-php

Tag     Spec                      Created       PullSpec
latest  library/hello-php:latest   7 hours ago  172.30.55.101:5000/hello-php/hello-php@sha256:v4
                                   7 hours ago  172.30.55.101:5000/hello-php/hello-php@sha256:v3
                                   9 hours ago  172.30.55.101:5000/hello-php/hello-php@sha256:v2
                                  25 hours ago  172.30.55.101:5000/hello-php/hello-php@sha256:v1
                                  25 hours ago  library/hello-php:latest
test    library/hello-php:latest   7 hours ago  172.30.55.101:5000/hello-php/hello-php@sha256:v3
                                   9 hours ago  172.30.55.101:5000/hello-php/hello-php@sha256:v2
                                  25 hours ago  172.30.55.101:5000/hello-php/hello-php@sha256:v1
                                  25 hours ago  library/hello-php:latest
prod    library/hello-php:latest   9 hours ago  172.30.55.101:5000/hello-php/hello-php@sha256:v2
                                  25 hours ago  library/hello-php:latest
```

### Dockerイメージのデプロイ

`oc new-app`では、ソースコードではなく一般的なDockerイメージを指定することもできます。

OpenShift環境では[セキュリティのためにデフォルトではUIDの利用に制限](https://docs.openshift.com/enterprise/3.0/admin_guide/manage_scc.html)がかかっています。そのため、Dockerfileでユーザを作って動作するようなDockerイメージはそのままでは動作せず、実際にデプロイした場合はパーミッションエラーで起動しません。[Docker Hubのopenshiftユーザー](https://registry.hub.docker.com/repos/openshift/)でホストされているイメージはそのまま動作するように作られています。

```
oc new-app openshift/jenkins-1-centos
```

### スケールとローリングアップデート

OpenShiftではアプリケーションコンテナを複数立ち上げることができます。接続はOpenShiftに含まれる`router`コンポーネントによって、接続数の少ないコンテナへロードバランスされます。`router`コンポーネントは[HAProxy](http://www.haproxy.org/)によって実装されており、`leastconn`ロードバランスがデフォルトで適用されるようになっています。

```
oc scale rc [rc-name] --replicas=2
```

負荷に応じて自動的にスケールを制御するオートスケールは将来のバージョンで実装される予定です。

OpenShiftのpodのデプロイ方法ですが、デフォルトでコンテナを再生成`Recreate`します。`Recreate`では全てのpodを停止してから、新しいpodをデプロイします。

別のデプロイ方法として`Rolling`があります。`Rolling`では新しいpodを生成してから古いpodを停止する、というのを1つずつ行います。デプロイ方法を変更するにはDeploymentConfigを編集します。

```
oc edit dc [dc-name]
```

ローリングアップデートを有効化することにより、ベーシックな無停止リリースが可能となります。

### ロールバック

まずはロールバック対象となるデプロイ名を探します。

```
oc describe dc [dc-name]
```

ロールバック対象のデプロイ名を指定して`oc rollback`を発行します。発行すると、指定されたデプロメントと同じ内容の新しいデプロイメントが作成され、自動デプロイトリガーが無効化されます。

```
oc rollback [deployment-name]
```

問題が解決したあと、自動デプロイトリガーを有効化するには以下を発行します。

```
oc deploy [dc-name] --enable-triggers
```

### 障害復旧

OpenShiftはサービスへの接続を監視しており、機能不全となっているpodは自動的に再起動します。pod内のプロセスを停止したり、podを停止したりしても短時間で復旧します。

### OSおよびミドルウェアのパッチ

openshiftプロジェクトのImageStreamに定義されているビルダーイメージにはミドルウェアやOSが含まれています。これらのミドルウェアやOSにセキュリティ修正などの変更がある場合には、`oc -import-image`を実行して新しいバージョンのイメージを取得します。関連するイメージで`latest`タグを参照しているアプリケーションなどは全て再ビルドされてデプロイされます。

```
# oc project openshift
# oc get is
NAME                                 DOCKER REPO                                                      TAGS                   UPDATED
jboss-amq-6                          registry.access.redhat.com/jboss-amq-6/amq-openshift             6.2,6.2-84,latest      9 days ago
jboss-eap6-openshift                 registry.access.redhat.com/jboss-eap-6/eap-openshift             6.4,6.4-207,latest     9 days ago
jboss-webserver3-tomcat7-openshift   registry.access.redhat.com/jboss-webserver-3/tomcat7-openshift   3.0,3.0-135,latest     9 days ago
jboss-webserver3-tomcat8-openshift   registry.access.redhat.com/jboss-webserver-3/tomcat8-openshift   3.0,3.0-137,latest     9 days ago
mongodb                              registry.access.redhat.com/openshift3/mongodb-24-rhel7           2.4,latest,v3.0.0.0    9 days ago
mysql                                registry.access.redhat.com/openshift3/mysql-55-rhel7             5.5,latest,v3.0.0.0    9 days ago
nodejs                               registry.access.redhat.com/openshift3/nodejs-010-rhel7           0.10,latest,v3.0.0.0   9 days ago
perl                                 registry.access.redhat.com/openshift3/perl-516-rhel7             5.16,latest,v3.0.0.0   9 days ago
php                                  registry.access.redhat.com/openshift3/php-55-rhel7               5.5,latest,v3.0.0.0    9 days ago
postgresql                           registry.access.redhat.com/openshift3/postgresql-92-rhel7        9.2,latest,v3.0.0.0    9 days ago
python                               registry.access.redhat.com/openshift3/python-33-rhel7            3.3,latest,v3.0.0.0    9 days ago
ruby                                 registry.access.redhat.com/openshift3/ruby-20-rhel7              2.0,latest,v3.0.0.0    9 days ago
# oadm build-chain --all
{
	"fullname": "openshift/php",
	"tags": [
		"latest"
	],
	"edges": [
		{
			"fullname": "hello-php/hello-php",
			"to": "hello-php/hello-php"
		}
	],
	"children": [
		{
			"fullname": "hello-php/hello-php",
			"tags": [
				"latest"
			]
		}
	]
}
# oc import-image php
```

### テンプレート作成

既存のプロジェクトからテンプレートを作成するには以下のコマンドを発行します。

```
oc export bc,is,dc,svc --all --as-template=hello-php
```

ただし、現在ImageStreamのexportが失敗するバグがあるので、ImageStreamは除外してください。ImageStreamは以下のような内容で簡単に定義できます。

```
- apiVersion: v1
  kind: ImageStream
  metadata:
    creationTimestamp: null
    name: hello-php
  spec: {}
  status:
    dockerImageRepository: ""
```

### Jenkins連携

残念ながら、OpenShift v3の最初のリリースではJenkinsサポートは未実装です。今年中にリリースされる3.1でJenkinsサポートが実装される予定であり、手動でJenkins連携の設定をするよりは簡単に設定ができるようになる予定です。

開発版では[サンプルアプリケーションとしてのJenkinsの定義](https://github.com/openshift/origin/tree/master/examples/jenkins)が提供されています。

## よくある質問

- アプリケーションのログはどうしたらいいですか？
  - Dockerコンテナの標準入出力は`oc logs`で参照でき、また、OpenShift上のjournaldにも集約されています。
  - クラウド環境ではfluentdなどのネットワークログサーバに送信するというのが一般的です。
  - どうしてもファイルベースでということであれば、PersistentVolumeをアタッチしてそちらに出力するという方法もあります。
- oc get allの出力が古いもので埋まって見づらいのはどうしたらいいですか？
  - 古いものの自動消去は検討中です。

## リファレンス

- [英語公式ドキュメント](https://docs.openshift.com/enterprise/3.0/welcome/index.html)

