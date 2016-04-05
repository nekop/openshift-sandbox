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
  - [Webコンソール](#web%E3%82%B3%E3%83%B3%E3%82%BD%E3%83%BC%E3%83%AB)
  - [基本的な概念](#%E5%9F%BA%E6%9C%AC%E7%9A%84%E3%81%AA%E6%A6%82%E5%BF%B5)
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
  - [よくある質問](#%E3%82%88%E3%81%8F%E3%81%82%E3%82%8B%E8%B3%AA%E5%95%8F)
  - [リファレンス](#%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# OpenShift v3 開発者向けハンズオン

## 準備

- このハンズオンの実行には構築済みのOpenShift Enterprise 3.1.1環境が必要です。Persistent Volumeは利用していません。
- ユーザは事前にocコマンドでログイン可能な状態にしておくか、もしくは全ユーザを解放するAllowポリシーの設定を行ってください。
- 多人数で行う場合はDocker registryのディスクの空き容量に注意してください。
- GitHubとの連携を行うためには、OpenShift EnterpriseとGitHubのネットワークが相互通信可能である必要があります。つまり、インターネット上に構築されている必要があります。
- GitHub Enterpriseとの連携を行うためには、OpenShift EnterpriseとGitHub Enterpriseのネットワークが相互通信可能である必要があります。また、[Using self-signed SSL certificates](https://help.github.com/enterprise/11.10.340/admin/articles/using-self-signed-ssl-certificates/)の通りに`/etc/openshift/master/ca.crt`をGitHub Enterprise側にインストールする必要があります。
- OpenShiftクライアントバイナリであるocコマンドはatomic-openshift-clients-redistributableパッケージに含まれているので、それをOpenShift管理者が利用者へ配布します。
  - ハンズオン実施時には一時的に以下のURLから上記と同一のocコマンドをダウンロードすることもできます。bash補完ファイルを利用する場合は`/etc/bash_completion.d/oc`に配置してbashを再度開始するか、`. ~/.bash_profile`で再読み込みしてくだい。
  - [Mac OS X](http://people.redhat.com/tkimura/ose-3.1/macosx/oc.zip) | [Linux](http://people.redhat.com/tkimura/ose-3.1/linux/oc.zip) | [Windows](http://people.redhat.com/tkimura/ose-3.1/windows/oc.zip) | [bash補完ファイル](http://people.redhat.com/tkimura/ose-3.1/bash_completion.d/oc)


## OpenShiftとは

Dockerコンテナでアプリケーションを動作させるためのPaaS (Platform as a Service)基盤です。アプリケーションをDockerコンテナ上でビルドしてDockerイメージを作成し、Dockerコンテナとして動作させることができます。Dockerコンテナのスケジューリングを行うGoogleの[Kubernetes](http://kubernetes.io/)をベースに構築されています。

簡単なコマンド操作でアプリケーションを配置したり、複製したり、MySQLを起動するなど、Dockerコンテナ群を自由にコントロールすることができます。

![OpenShift Overview](https://raw.githubusercontent.com/nekop/openshift-sandbox/master/oepnshift-overview.png)

環境をセットアップして利用するのではなく、OpenShiftのようにビルド済みのDockerイメージをDocker実行環境へデプロイするモデルは現在はImmutable InfrastructureやBlue Green Deploymentの実現方法として注目を集めています。


## ハンズオンシナリオの説明

1. 簡単なphpアプリケーションをGitHubに作成し、OpenShiftに登録します。
2. OpenShift上でビルドを実行し、GitのソースコードからDockerイメージを作成してデプロイし、実行可能な状態にします。
3. GitHubにpushされたタイミングで自動ビルドを行うように設定します。
4. MySQLを利用するphpアプリケーションを作成します。
5. OpenShift上で何が発生しているのか、ログやイベント、コンテナ内部を調べます。
6. イメージをテスト環境や本番環境へリリースするなど、応用シナリオのデモを行います。


## OpenShift Clientコマンド

OpenShift Clientコマンドは`oc`という単一の実行ファイルです。OpenShift Enterpriseのatomic-openshift-clients-redistributableパッケージに含まれているので、管理者の方がどこかのWebサーバなどに配置して利用者にダウンロードできるようにしてください。

また、利用者ではなく管理者が利用するコマンド`oadm`というコマンドもあります。マニュアルなどに`oadm`コマンド例が出てきた場合は、管理者作業を意味します。


## ログイン

```
oc login <server>[:<port>]
```

ログアウトを行うにはoc logoutを実行します。

ログイン状態などのOpenShift関連の情報は`~/.kube/config`に保存されており、`oc config view`で同一の内容が確認できます。

TLS接続には`--certificate-authority`オプションに対応するca.crtを指定するか、無指定の場合insecureのまま接続するかどうかの選択肢が出ます。内部テスト利用などではinsecure接続を選択しても良いでしょう。


## プロジェクト作成

プロジェクト名はOpenShift環境全体でユニークである必要がありますので、個人用プロジェクトは個人のidなどを名前に含めたほうが良いです(ex. `tkimura-test-php`)。また、OpenShiftの設計上、プロジェクト名は後からリネームすることはできません。プロジェクト情報をダンプして修正して取り込むことで、同一構成を新しい名前プロジェクトにすることは簡単にできます。

```
oc new-project <project-name>
```


## アプリケーション作成

まずはgithubにアプリケーションのリポジトリを作成し、cloneしてください。アプリケーション名(リポジトリ名)は英字開始で、ダッシュ(ハイフン)以外の記号は利用しないでください。数字で開始したり、アンダーバーが含まれていると、OpenShiftやURLの仕様違反となる名前になってしまい、後のステップでエラーとなってしまうので注意してください。

```
git clone <git clone URL>
```

cloneが完了したら、最初のお約束であるHello Worldを配置します。

```
cd <repository>; echo '<?php echo "Hello world"; ?>' > index.php
git add index.php
git commit -m 'Hello world'
git push
```

gitへpushしたらOpenShift上にアプリケーションを作成します。この`oc new-app`ではOpenShiftがgitのcloneを発行するため、sshなどの認証が必要なclone URLは利用しないでください。一般的にはhttpsのURLが認証なしのclone URLとなることが多いでしょう。認証も可能ですがこのハンズオンのスコープには含めていません。

```
oc new-app <git public clone URL>
oc expose service <app-name>
```

`oc new-app`コマンドでは、gitリポジトリのファイルによって[利用言語を自動検出](https://docs.openshift.com/enterprise/3.1/dev_guide/new_app.html#language-detection)し、適切なビルダーイメージを割り当てます。今回のようにindex.phpがあるとPHPのビルダーイメージが利用されます。Webコンソールではこの機能はないため、自分でビルダーイメージを選択する必要があります。

`oc new-app`コマンドを実行すると、実際にはbc, dc, rc, is, svcという各種オブジェクト(後述します)と実行用podが作成されます。初期状態では実行用podはビルド済みイメージが未作成で見つからないためError状態となります。状態の確認には`oc status`, `oc get all`および`oc get events`を使用しますが、後述するWebコンソールのほうがCLIに慣れない最初のうちは特に見やすいので便利です。


## ビルドの実行とアプリケーションの確認

マニュアルでソースコードからDockerイメージを生成するビルドを行う`oc start-build`を実行します。成功するとDockerイメージがImageStreamに登録され、実行用podが再作成されてアプリケーションが実行されます。`bc-name`は`app-name`と同一です。`build-name`は末尾に`-1`のようなシーケンス番号が付くので注意してください。

```
oc start-build <bc-name>
oc get build
oc build-logs <build-name>
```

最初のビルドは`oc new-app`を発行してから少し時間がたてば開始されます。手動でビルドを発行したのと合わせて2つビルドが同時に走ると片方がDockerイメージのpushに失敗することがありますが気にしないでください。

ビルドが完了すると、以下のURLでアプリケーションにアクセスすることが可能になっているはずです。

```
http://`<app-name>.<project-name>.<cloud-domain>`
```

`oc expose`を行うと、アプリケーションへアクセスするためのルーティング情報が生成されます。デフォルトでは`<app-name>.<project-name>.<cloud-domain>`という形式のURLとなります。`--hostname`オプションで任意のURLに変更できるので、DNS設定と合わせて任意のURLへのリクエストをOpenShiftでハンドルすることができます。


## Webコンソール

ログインにも利用したOpenShiftのmasterサーバにはWebコンソールが付属しています。デフォルトでhttps, 8443ポートを利用するようになっています。ブラウザで開いてログインしてみましょう。

```
https://<server>:8443/
```

Webコンソールでは構成がグラフィカルに表示されるようになっています。今はアプリケーションのみの単一構成なのであまり見どころはないのですが、アプリケーションのpodを増殖させたり、データベースなどを追加するとにぎやかになります。

## 基本的な概念

- Pod
  - コンテナの入れ物であり、デプロイするユニットとなるKubernetesのオブジェクト。OpenShift上ではアプリケーションやMySQLなどのコンテナがそれぞれpodになる。
  - [k8s Pod](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/pods.md)
- Service (svc)
  - pod群のIPアドレスを保持し、podへのアクセスポイントとなるKubernetesのオブジェクト
  - [k8s Service](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/services.md)
- Replication Controller (rs)
  - podの数を管理して制御するKubernetesのオブジェクト
  - [k8s Replication Controller](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/replication-controller.md)
- Deployment Config (dc)
  - デプロイ管理を行うOpenShiftのオブジェクト
- Build Config (bc)
  - ビルド管理を行うOpenShiftのオブジェクト
- Image Stream (is)
  - イメージ管理を行うOpenShiftのオブジェクト。タグはそれぞれ追記専用リスト(Stream)構造になっており、イメージの履歴を参照できる。イメージは実際にはDocker Registryに保存されているので、Image Streamはイメージを保持しているわけではなくイメージを参照するための情報のみを保持している。
- Route
  - ルーター設定を行うOpenShiftのオブジェクト。OpenShiftのHAProxyルーターコンポーネントの設定情報を保持する。Routeを作成すると、OpenShift外部からサービスへURLアクセス可能になる。`oc expose`コマンドで作成できる。


## 各種コマンド

### 基本的なコマンド

- `oc status`
- `oc get all`
- `oc get events`
- `oc get <resource>`
- `oc describe <resource> <resource-name>`
- `oc get all -o yaml`
- `oc build-logs <build-name>`
- `oc logs <pod-name>`
- `oc rsh <pod-name>`
- `oc delete <resource> <resource-name>`
- `oc delete all --all` # プロジェクトの内容全消し

### リソースのリスト

リソース名は最後に"s"をつけてもつけなくても動作します。いくつかのリソース名は名前が長いので省略形が用意されています。

`oc types`で全てのリストと説明が表示されます。

- pod
- build
- route
- service, svc
- buildconfig, bc
- deploymentconfig, dc
- replicationcontroller, rc
- imagestream, is
- persistentvolumeclaim, pvc

### oc get allの出力

`oc get all`は以下のリソースをまとめて表示します。

- buildconfig
- build
- imagestream
- deploymentconfig
- replicationcontroller
- persistentvolumeclaim
- service
- pod


## 自動ビルドの設定

`oc describe bc <name>`を実行してビルドコンフィグを参照すると、hookのURLが取得できます。このhookをGitHubのWebhookに設定したり、Webhook GenericのURLをgitのpost-updateなどのhookでcurl -X POSTで呼び出すことで自動的にビルドがトリガーされます。

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

テストを行うにはいくつか空コミットを生成してpushします。gitで空コミットを作るには`git commit --allow-empty`を実行します。

```
git commit --allow-empty -m 'empty' && git push
```

OpenShiftはhookからブランチ名などを取得し、ビルド要否を判断して自動ビルドを行います。Webhookからのビルドでは、`oc describe build <build-name>`や`oc describe isimage <image>`の出力にgitのcommit SHA-1値が含まれるようになります。


## データベースの追加とテンプレート

データベースなどの追加ソフトウェアなどはテンプレートという機構で管理します。今回は`mysql-ephemeral`というテンプレートを利用します。

全ユーザが利用できるテンプレートは`openshift`プロジェクトに定義されています。以下のコマンドでテンプレートの一覧と、各テンプレートの情報を取得できます。

```
oc get template -n openshift
oc describe template mysql-ephemeral -n openshift
```

テンプレートから実際にオブジェクトを生成するには`oc new-app`コマンドを利用します。`oc new-app`コマンドは表向きの概念としてはアプリケーションを作る、というものでありコマンド名もそのようになっていますが、実際にはアプリケーションに必要なオブジェクト群を生成するコマンドです。

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

メンテナンスなどのためのmysqlへのアクセスは以下の手順で行うことができます。

```
oc get pod
oc describe pod <pod-name> # IP取得
oc rsh <pod-name>
mysql -h <host> -u <user> -p
```

もしくは`oc port-forward`で自マシンと接続します。

```
oc port-forward -p <pod-name>  3306:3306
mysql -h 127.0.0.1 -P 3306 -u user -p
```

`oc rsh`でリモートのPaaSサーバ群のどこかに配置されているDockerコンテナのシェルを手元から簡単に起動できて操作できます。`oc rsh`の通信にはWebSocketが利用されています。

また、再度Webコンソールを開いてみてください。アプリケーションとデータベースが配置されているのが確認できます。


## トラブルシューティング

ビルドに失敗した場合は`oc logs`でビルドPodのログを参照します。

```
oc logs <build-pod-name>
```

デプロイに失敗した、もしくはデプロイは成功しているが正常に動いていない、という場合は`oc logs`で対象podのログを参照します。デプロイのリトライは`oc deploy --retry`で行うことができます。

```
oc logs <pod-name>
oc deploy <dc-name> --retry
```

phpのpodではApache httpdが動作しており、`oc logs`でログを参照するとサーバ名の設定がされていないため以下の警告メッセージが見えますが無視してかまいません。OpenShift上では不要なものです。

```
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 10.x.x.x. Set the 'ServerName' directive globally to suppress this message
```

ビルドやデプロイは`new-app`の直後などはタイミングの問題により失敗したりします。その場合は少し待ってから再実行すると成功します。

DockerイメージのpullやDockerコンテナのステータス変更などのイベントの一覧は`oc get events`で参照できます。

```
oc get events
```

コンテナの内部を調べたい場合は`oc rsh`を利用します。しかし、Dockerコンテナの中は通常最低限のツールのみがインストールされている状態ですので、あまりできることは多くありません。コンテナの中のファイルの確認などには便利です。

```
oc rsh <pod-name>
```

ハンズオン中に実際にトラブルが発生したものを例に挙げてフォローおよび解説する予定です。何もトラブルがなかったらごめんなさい。


## デモ

### チームでの開発環境、テスト環境、本番環境の管理

joe, aliceそしてbenの開発者が小さなphp/mysqlプロジェクト`hello-php`でチーム開発を行います。joeがプロジェクトを作成し、aliceとbenを管理者として登録します。チームのプロジェクトなので、特に個人名などは付与しません。

```
oc new-project hello"
oc project hello
oc policy add-role-to-user admin alice
oc policy add-role-to-user admin ben
```

joeがこのプロジェクトを構成していきます。もちろんaliceでもbenでもこの作業は可能です。

```
oc new-app http://github.example.jp/hello-php/hello-php
oc expose svc hello-php --hostname=hello.apps.example.jp
```

この後にWebhookで自動ビルドを設定します。これでGitのhello-phpのmasterブランチである開発バージョンは`hello-php.apps.example.jp`で常にビルドされて公開される状態になりました。masterブランチにpull requestがマージされて更新されるたびに開発バージョンがアップデートされて自動デプロイされます。

joe, alice, ben各個人はこのリポジトリをforkして、OpenShift上では個人のプロジェクトへ`new-app`を発行し、自動ビルドを設定します。各個人は各個人の環境で開発を行い、プロジェクトのgitリポジトリへPull Requestを送信します。

続いて本番環境を作成します。同じ手順でテスト環境、ステージング環境などを定義でき、開発環境から本番環境まで順次イメージをプロモーションするようなワークフローが作成できます。

![OpenShift Image Promotion](https://raw.githubusercontent.com/nekop/openshift-sandbox/wip/image-promotion.jpg)

環境のコピーは開発バージョンのDeploymentConfig, Serviceをexportして利用します。本番環境はビルドを行わないのでBuildConfigはありません。

```
oc export dc,svc -o yaml --as-template=hello > prod-hello.yaml
```

出力されたYAMLファイルの中に定義されている、デプロイするイメージのタグをlatestではなくprodへ変更します。

```
perl -i -pe 's/name: hello-php:latest/name: hello-php:prod/g' prod-hello.yaml
```

本番環境用prod-helloプロジェクトを作成し、helloプロジェクトからイメージをpullできるよう権限を付与してnew-appでオブジェクトを生成します。

```
oc new-project prod-hello
oc policy add-role-to-user system:image-puller system:serviceaccount:prod-hello:default -n hello
oc new-app -f prod-hello.yaml
oc expose svc hello-php --hostname=prod-hello.apps.example.jp
```

`oc describe is hello-php -n hello`を実行して、本番環境の`prod`タグを開発環境の適当なイメージに付与します。

```
oc tag hello/hello-php@sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx hello-php:prod
```

タグ付けを行うとデプロイが実行され、イメージは本番環境へとリリースされることになります。

この利用方法での`oc describe is`の出力例ですが、以下のようになります。devがv5、prodはv4がデプロイされています。この例では"v4"などの部分は読みやすいように書き換えてありますが、実際には64ケタのsha256値です。

```
$ oc describe is hello-php -n hello
Name:			hello-php
Created:		25 hours ago
Labels:			<none>
Docker Pull Spec:	172.30.55.101:5000/hello/hello-php

Tag     Spec                      Created       PullSpec
latest  library/hello-php:latest   2 hours ago  172.30.55.101:5000/hello/hello-php@sha256:v5
                                   7 hours ago  172.30.55.101:5000/hello/hello-php@sha256:v4
                                   7 hours ago  172.30.55.101:5000/hello/hello-php@sha256:v3
                                   9 hours ago  172.30.55.101:5000/hello/hello-php@sha256:v2
                                  25 hours ago  172.30.55.101:5000/hello/hello-php@sha256:v1
                                  25 hours ago  library/hello-php:latest
```

```
$ oc describe is hello-php -n prod-hello
Name:			hello-php
Created:		25 hours ago
Labels:			<none>
Docker Pull Spec:	172.30.55.101:5000/prod-hello/hello-php

Tag     Spec                      Created       PullSpec
prod    library/hello-php:latest   7 hours ago  172.30.55.101:5000/prod-hello/hello-php@sha256:v4
                                  25 hours ago  library/hello-php:latest
```


### Dockerイメージのデプロイ

`oc new-app`では、ソースコードではなく一般的なDockerイメージを指定することもできます。

OpenShift環境では[セキュリティのためにデフォルトではUIDの利用に制限](https://docs.openshift.com/enterprise/3.1/admin_guide/manage_scc.html)があり、実行時にはランダムなUIDが割り当たります。そのため、Dockerfileで特定のユーザを作っていて特定のユーザでの動作を期待するようなDockerイメージや、USERを指定しておらずrootでの動作を前提としてしまっているイメージはそのままでは動作せず、実際にデプロイした場合はパーミッションエラーで起動しません。[Docker Hubのopenshiftユーザー](https://registry.hub.docker.com/repos/openshift/)でホストされているイメージはそのまま動作するように作られています。

```
oc new-app openshift/jenkins-1-centos
```


### スケールとローリングアップデート

OpenShiftではアプリケーションコンテナを複数立ち上げることができます。接続はOpenShiftに含まれる`router`コンポーネントによって、接続数の少ないコンテナへロードバランスされます。`router`コンポーネントは[HAProxy](http://www.haproxy.org/)によって実装されており、`leastconn`ロードバランスがデフォルトで適用されるようになっています。

```
oc scale rc <rc-name> --replicas=2
```

負荷に応じて自動的にスケールを制御する[オートスケール](https://docs.openshift.com/enterprise/3.1/dev_guide/pod_autoscaling.html)というものもあります。

OpenShiftのpodのデプロイ方法は2つ`Rolling`と`Recreate`があり、デフォルトは`Rolling`です。`Rolling`では新しいpodを生成してから古いpodを停止する、というのを1つずつ行うローリングアップデートであり、ベーシックな無停止リリースが可能となっています。

```
oc edit dc <dc-name>
```

`Recreate`では全てのpodを停止してから、新しいpodをデプロイします。


### ロールバック

まずはロールバック対象となるデプロイ名を探します。

```
oc describe dc <dc-name>
```

ロールバック対象のデプロイ名を指定して`oc rollback`を発行します。発行すると、指定されたデプロメントと同じ内容の新しいデプロイメントが作成され、自動デプロイトリガーが無効化されます。

```
oc rollback <deployment-name>
```

問題が解決したあと、自動デプロイトリガーを有効化するには以下を発行します。

```
oc deploy <dc-name> --enable-triggers
```


### 障害復旧

OpenShiftはサービスへの接続を監視しており、機能不全となっているコンテナは自動的に再起動されます。pod内のプロセスを停止したり、podを削除したりしても短時間で復旧します。

```
oc delete pod <pod-name>
oc rsh <pod-name> kill 1
```

### OSおよびミドルウェアのパッチ

openshiftプロジェクトのImageStreamに定義されているビルダーイメージにはミドルウェアやOSが含まれています。これらのミドルウェアやOSにセキュリティ修正などの変更がある場合には、`oc -import-image`を実行して新しいバージョンのイメージを取得します。関連するイメージで`latest`タグを参照しているアプリケーションなどは全て再ビルドされてデプロイされます。

```
$ oc get is -n openshift
NAME                                  DOCKER REPO                                                                    TAGS                               UPDATED
fis-java-openshift                    registry.access.redhat.com/jboss-fuse-6/fis-java-openshift                     1.0-9,latest,1.0-10 + 2 more...    4 weeks ago
fis-karaf-openshift                   registry.access.redhat.com/jboss-fuse-6/fis-karaf-openshift                    latest,1.0-10,1.0-11 + 2 more...   4 weeks ago
jboss-amq-62                          registry.access.redhat.com/jboss-amq-6/amq62-openshift                         1.2-12,1.2,1.1 + 5 more...         4 weeks ago
jboss-datagrid65-openshift            registry.access.redhat.com/jboss-datagrid-6/datagrid65-openshift               1.2-13,1.2-18,1.2-19 + 2 more...   4 weeks ago
jboss-decisionserver62-openshift      registry.access.redhat.com/jboss-decisionserver-6/decisionserver62-openshift   1.2-10,1.2-17,1.2-18 + 2 more...   4 weeks ago
jboss-eap64-openshift                 registry.access.redhat.com/jboss-eap-6/eap64-openshift                         1.3,1.3-10,1.2-19 + 7 more...      7 days ago
jboss-webserver30-tomcat7-openshift   registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat7-openshift     1.1-2,1.1-6,1.2 + 5 more...        4 weeks ago
jboss-webserver30-tomcat8-openshift   registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift     1.1-3,1.2-10,1.2-11 + 5 more...    4 weeks ago
jenkins                               172.30.48.173:5000/openshift/jenkins                                           1,latest                           4 weeks ago
mongodb                               172.30.48.173:5000/openshift/mongodb                                           2.4,2.6,latest                     4 weeks ago
mysql                                 172.30.48.173:5000/openshift/mysql                                             5.6,latest,5.5                     4 weeks ago
nodejs                                172.30.48.173:5000/openshift/nodejs                                            0.10,latest                        4 weeks ago
perl                                  172.30.48.173:5000/openshift/perl                                              latest,5.20,5.16                   4 weeks ago
php                                   172.30.48.173:5000/openshift/php                                               5.6,latest,5.5                     4 weeks ago
postgresql                            172.30.48.173:5000/openshift/postgresql                                        9.4,latest,9.2                     4 weeks ago
python                                172.30.48.173:5000/openshift/python                                            3.4,latest,3.3 + 1 more...         4 weeks ago
ruby                                  172.30.48.173:5000/openshift/ruby                                              2.2,latest,2.0                     4 weeks ago
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

## よくある質問

- アプリケーションのログはどうしたらいいですか？
  - Dockerコンテナの標準入出力は`oc logs`で参照でき、また、OpenShift上のjournaldにも集約されています。
  - クラウド環境ではfluentdなどのネットワークログサーバに送信するというのが一般的です。
  - どうしてもファイルベースでということであれば、PersistentVolumeをアタッチしてそちらに出力するという方法もあります。
- カスタマイズはできますか？
  - はい、OpenShiftのほぼ全てがAPIで構成され、プログラマブルになっています。ocコマンドもWebコンソールも基本的にはAPIを叩いているだけのAPIクライアント実装です。
  - ビルドされるイメージをカスタマイズしたい場合は、[`.sti/bin`ディレクトリにカスタムの`assemble`, `run`スクリプトを含めるか、カスタムのビルダーイメージを作成](https://docs.openshift.com/enterprise/3.1/creating_images/s2i.html)します。
  - アプリケーションのpodの開始、終了の前後処理を行う[ライフサイクルフック](https://docs.openshift.com/enterprise/3.1/dev_guide/deployments.html#pod-based-lifecycle-hook)が定義できます。


## リファレンス

- [英語公式ドキュメント](https://docs.openshift.com/enterprise/3.1/welcome/index.html)
- [英語ブログ](https://blog.openshift.com/)

