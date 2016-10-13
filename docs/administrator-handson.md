<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [OpenShift Enterprise 3.2 管理者向けハンズオン](#openshift-enterprise-311-%E7%AE%A1%E7%90%86%E8%80%85%E5%90%91%E3%81%91%E3%83%8F%E3%83%B3%E3%82%BA%E3%82%AA%E3%83%B3)
  - [インストールの事前要件](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%AE%E4%BA%8B%E5%89%8D%E8%A6%81%E4%BB%B6)
  - [インストール](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)
    - [インスタンスの準備](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%81%AE%E6%BA%96%E5%82%99)
    - [サブスクリプションの設定](#%E3%82%B5%E3%83%96%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E8%A8%AD%E5%AE%9A)
    - [Dockerのイメージ領域設定](#docker%E3%81%AE%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E9%A0%98%E5%9F%9F%E8%A8%AD%E5%AE%9A)
    - [AnsibleでOpenShiftをインストールする](#ansible%E3%81%A7openshift%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B)
    - [Persistence Volumeの設定と作成](#persistence-volume%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%81%A8%E4%BD%9C%E6%88%90)
    - [Docker registryの作成](#docker-registry%E3%81%AE%E4%BD%9C%E6%88%90)
    - [Routerの作成](#router%E3%81%AE%E4%BD%9C%E6%88%90)
  - [メンテナンス](#%E3%83%A1%E3%83%B3%E3%83%86%E3%83%8A%E3%83%B3%E3%82%B9)
    - [ノードの状況確認](#%E3%83%8E%E3%83%BC%E3%83%89%E3%81%AE%E7%8A%B6%E6%B3%81%E7%A2%BA%E8%AA%8D)
    - [ノードのコンテナとイメージの削除](#%E3%83%8E%E3%83%BC%E3%83%89%E3%81%AE%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E3%81%A8%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%81%AE%E5%89%8A%E9%99%A4)
    - [古い、既に利用されていないイメージの削除](#%E5%8F%A4%E3%81%84%E3%80%81%E6%97%A2%E3%81%AB%E5%88%A9%E7%94%A8%E3%81%95%E3%82%8C%E3%81%A6%E3%81%84%E3%81%AA%E3%81%84%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%81%AE%E5%89%8A%E9%99%A4)
    - [ノードの追加](#%E3%83%8E%E3%83%BC%E3%83%89%E3%81%AE%E8%BF%BD%E5%8A%A0)
    - [ノードの削除](#%E3%83%8E%E3%83%BC%E3%83%89%E3%81%AE%E5%89%8A%E9%99%A4)
    - [ノードからPodを移動](#%E3%83%8E%E3%83%BC%E3%83%89%E3%81%8B%E3%82%89pod%E3%82%92%E7%A7%BB%E5%8B%95)
  - [バックアップ](#%E3%83%90%E3%83%83%E3%82%AF%E3%82%A2%E3%83%83%E3%83%97)
  - [トラブルシューティング](#%E3%83%88%E3%83%A9%E3%83%96%E3%83%AB%E3%82%B7%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0)
    - [トラブルシューティングのためのパッケージ](#%E3%83%88%E3%83%A9%E3%83%96%E3%83%AB%E3%82%B7%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E3%81%AE%E3%81%9F%E3%82%81%E3%81%AE%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8)
    - [ログレベルの変更](#%E3%83%AD%E3%82%B0%E3%83%AC%E3%83%99%E3%83%AB%E3%81%AE%E5%A4%89%E6%9B%B4)
    - [情報の収集](#%E6%83%85%E5%A0%B1%E3%81%AE%E5%8F%8E%E9%9B%86)
    - [コンテナ内ネットワークスペースのテスト](#%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E5%86%85%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%82%B9%E3%83%9A%E3%83%BC%E3%82%B9%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88)
  - [リファレンス](#%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# OpenShift Enterprise 3.2 管理者向けハンズオン

## インストールの事前要件

- 十分な数のOpenShift Enterpriseのサブスクリプションが必要です。
- DNSの設定が必要です。インストール対象のホスト名、アプリケーションに割り当てるワイルドカードDNSエントリが設定されている必要があります。ワイルドカードDNSエントリはRouter podがデプロイされているノードのIPアドレスとなります。一般的に設定は以下のようになります。
  - 10.xx.xx.11 master.example.com
  - 10.xx.xx.21 infra1.example.com
  - 10.xx.xx.31 node01.example.com
  - 10.xx.xx.32 node02.example.com
  - 10.xx.xx.21 *.apps.example.com

## インストール

ここでは簡略化した基本的なインストールの手順を紹介します。セットアップの詳細については[オフィシャルのインストールガイド](https://docs.openshift.com/enterprise/3.2/install_config/index.html)を参照してください。

### インスタンスの準備

OpenShiftをインストールするRHEL 7.2のインスタンス群を起動し、ネットワーク、ホスト名、タイムゾーン、NTPなどを設定してください。

プロダクションではDockerのイメージ領域として未使用のディスク領域が必要となります。一般的には2nd diskをアタッチします。

### サブスクリプションの設定

OpenShiftをインストールする全ノードで、以下のようなスクリプトでサブスクリプションを設定し、rpmリポジトリにアクセスできるようにします。

```
#!/bin/bash

RHSM_USERNAME=
RHSM_PASSWORD=
RHSM_POOLID=

sudo subscription-manager register --username=$RHSM_USERNAME --password=$RHSM_PASSWORD
sudo subscription-manager attach --pool $RHSM_POOLID
sudo subscription-manager repos --disable=*
sudo subscription-manager repos \
     --enable=rhel-7-server-rpms \
     --enable=rhel-7-server-extras-rpms \
     --enable=rhel-7-server-optional-rpms \
     --enable=rhel-7-server-ose-3.2-rpms
sudo yum update -y
```

### Dockerのイメージ領域設定

OpenShiftをインストールする全ノードで、Dockerのイメージ領域を設定します。仮想環境での2nd diskは基本的に`/dev/vdb`となると思いますが、その場合は以下のように設定します。

```
# cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/vdb
VG=docker-vg
EOF
```

### AnsibleでOpenShiftをインストールする

AnsibleでOpenShiftをインストールする方法はマニュアルでは[Advanced Installation](https://docs.openshift.com/enterprise/3.2/install_config/install/advanced_install.html)というタイトルで記述されていますが、ウィザード形式ではない、くらいの意味でそれほどAdvancedでもありません。基本的に用意するファイルはAnsibleのインベントリファイルひとつだけです。

この例ではmasterをインストールホストとしても利用します。masterに`atomic-openshift-utils`パッケージをインストールします。依存としてansibleもインストールされます。

```
sudo yum install atomic-openshift-utils -y
```

次に`/etc/ansible/hosts`にセットアップを記述します。以下はmaster, infra1, node01, node02という4台構成の例です。

```
[OSEv3:children]
masters
nodes

[OSEv3:vars]
ansible_ssh_user=cloud-user
ansible_become=true
deployment_type=openshift-enterprise
openshift_master_identity_providers=[{'name': 'allow_all', 'login': 'true', 'challenge': 'true', 'kind': 'AllowAllPasswordIdentityProvider'}]
osm_default_subdomain=apps.example.com
os_sdn_network_plugin_name=redhat/openshift-ovs-multitenant

[masters]
master.example.com

[nodes]
master.example.com
infra1.example.com openshift_node_labels="{'region': 'infra'}"
node[01:02].example.com openshift_node_labels="{'region': 'primary'}"
```

全ての設定項目が羅列されているインベントリファイルの冗長な例が https://github.com/openshift/openshift-ansible/blob/master/inventory/byo/hosts.ose.example にあります。

Ansibleを実行するためには、インストールホストから各ノードへSSH鍵認証で接続できること、Ansibleのユーザがnon-rootの場合はNOPASSWDでsudoが発行できる必要があります。

```
ssh-keygen
ssh-copy-id [cloud-user@]master.example.com
ssh-copy-id [cloud-user@]infra1.example.com
ssh-copy-id [cloud-user@]node01.example.com
ssh-copy-id [cloud-user@]node02.example.com
```

これで準備は完了です。以下のコマンドでAnsibleを実行するとインストールが行われます。

```
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
```

masterノードのAnsibleユーザはOpenShiftのcluster adminという全管理権限を持つsystem:adminアカウントとなり、`~/.kube/config`がsystem:adminユーザで設定されます。

### Persistence Volumeの設定と作成

Persistence Volumeのセットアップは環境により異なるので[公式ドキュメント](https://docs.openshift.com/enterprise/3.2/install_config/persistent_storage/index.html)を参照してください。

テスト目的でNFSを設定する場合は以下のように設定できます。

```
sudo mkdir -p /exports
sudo chown -R nfsnobody:nfsnobody /exports
sudo chmod 777 /exports/
sudo sh -c "cat << EOM > /etc/exports
/exports *(rw,sync,root_squash,no_wdelay)
EOM"
sudo iptables -I INPUT -p tcp -m state --state NEW -m tcp --dport 2049 -j ACCEPT
sudo service iptables save
sudo systemctl enable nfs-server
sudo systemctl restart nfs-server
```

PVは規模にもよりますが、プロジェクト一つあたり1, 2個利用する場合が多いと思いますので、数十程度は必要です。スクリプトで自動生成してください。

```
#!/bin/bash

SERVER=...
COUNT=50

sudo mkdir -p /exports
sudo chmod 777 /exports
sudo chown nfsnobody:nfsnobody /exports
oc project default

for i in $(seq 1 $COUNT); do
    PV=$(cat <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv$(printf %04d $i)
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: $SERVER
    path: /exports/pv$(printf %04d $i)
EOF
)
    echo "$PV" | oc create -f -
    sudo mkdir -p /exports/pv$(printf %04d $i)
    sudo chown nfsnobody:nfsnobody /exports/pv$(printf %04d $i)
done
```

### Docker registryの作成

Docker registryは全Docker imageを保持するため、かなり大きな容量が必要になります。専用のPersistentVolumeをRetainポリシーで作成します。以下はnfsでのPVの定義例です。

```
oc create -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: registry
spec:
  capacity:
    storage: 500Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  nfs:
    server: $SERVER
    path: /exports/registry
EOF
```

対応するPVCを作成して、レジストリを作成してPVCを設定します。PVCを設定すると自動的に再デプロイされます。


```
oc project default
oc create -f - <<EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: registry
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 500Gi
EOF
oadm registry --config=/etc/origin/master/admin.kubeconfig \
  --credentials=/etc/origin/master/openshift-registry.kubeconfig \
  --images='registry.access.redhat.com/openshift3/ose-${component}:${version}'
oc volume deploymentconfigs/docker-registry --add --name=registry -t pvc \
  --claim-name=registry --overwrite
```

### Routerの作成

Routerは`region=infra`ラベルが付与されているノードがあればインストーラにより自動的に作成されているので、カスタマイズの必要がなければそのままで構いません。

## メンテナンス

masterノードのAnsibleユーザが全管理権限を持つsystem:adminユーザなので、管理作業は基本的にmaster上のAnsibleユーザを利用することになります。

### ノードの状況確認

ノードのステータスは`oc get node`、詳細は`oc describe node`で確認することができます。

```
oc get node
oc describe node
```

実行例は以下のようになります。

```
$ oc get node
NAME                 LABELS                                                     STATUS    AGE
master.example.com   kubernetes.io/hostname=master.example.com,region=infra     Ready     33d
node01.example.com   kubernetes.io/hostname=node01.example.com,region=primary   Ready     33d

$ oc describe node
Name:			master.example.com
Labels:			kubernetes.io/hostname=master.example.com,region=infra
CreationTimestamp:	Thu, 03 Mar 2016 16:36:37 +0900
Phase:			
Conditions:
  Type		Status	LastHeartbeatTime			LastTransitionTime			Reason		Message
  ────		──────	─────────────────			──────────────────			──────		───────
  Ready 	True 	Wed, 06 Apr 2016 14:56:56 +0900 	Tue, 05 Apr 2016 10:24:39 +0900 	KubeletReady 	kubelet is posting ready status
Addresses:	10.64.220.227,10.64.220.227
Capacity:
 cpu:		4
 memory:	3880672Ki
 pods:		40
System Info:
 Machine ID:			e65d0a4b27024020b935bb26ed2a9847
 System UUID:			E65D0A4B-2702-4020-B935-BB26ED2A9847
 Boot ID:			ccf6dd95-0c9c-4368-8560-fd80b827ef31
 Kernel Version:		3.10.0-327.10.1.el7.x86_64
 OS Image:			Employee SKU
 Container Runtime Version:	docker://1.8.2-el7
 Kubelet Version:		v1.1.0-origin-1107-g4c8e6f4
 Kube-Proxy Version:		v1.1.0-origin-1107-g4c8e6f4
ExternalID:			master.example.com
Non-terminated Pods:		(2 in total)
  Namespace			Name				CPU Requests	CPU Limits	Memory Requests	Memory Limits
  ─────────			────				────────────	──────────	───────────────	─────────────
  default			docker-registry-6-tt5o0		0 (0%)		0 (0%)		0 (0%)		0 (0%)
  default			router-1-jpxpd			0 (0%)		0 (0%)		0 (0%)		0 (0%)
Allocated resources:
  (Total limits may be over 100%, i.e., overcommitted. More info: http://releases.k8s.io/HEAD/docs/user-guide/compute-resources.md)
  CPU Requests	CPU Limits	Memory Requests	Memory Limits
  ────────────	──────────	───────────────	─────────────
  0 (0%)	0 (0%)		0 (0%)		0 (0%)
No events.

Name:			node01.example.com
Labels:			kubernetes.io/hostname=node01.example.com,region=primary
CreationTimestamp:	Thu, 03 Mar 2016 16:26:53 +0900
Phase:			
Conditions:
  Type		Status	LastHeartbeatTime			LastTransitionTime			Reason		Message
  ────		──────	─────────────────			──────────────────			──────		───────
  Ready 	True 	Wed, 06 Apr 2016 14:56:58 +0900 	Mon, 04 Apr 2016 12:45:19 +0900 	KubeletReady 	kubelet is posting ready status
Addresses:	10.64.221.1,10.64.221.1
Capacity:
 memory:	8009432Ki
 pods:		40
 cpu:		4
System Info:
 Machine ID:			5f43afca39f24298ae1d89c440524408
 System UUID:			5F43AFCA-39F2-4298-AE1D-89C440524408
 Boot ID:			066d1304-f18d-47e0-8973-ad06241a6f4c
 Kernel Version:		3.10.0-327.13.1.el7.x86_64
 OS Image:			Employee SKU
 Container Runtime Version:	docker://1.8.2-el7
 Kubelet Version:		v1.1.0-origin-1107-g4c8e6f4
 Kube-Proxy Version:		v1.1.0-origin-1107-g4c8e6f4
ExternalID:			node01.example.com
Non-terminated Pods:		(7 in total)
  Namespace			Name				CPU Requests	CPU Limits	Memory Requests	Memory Limits
  ─────────			────				────────────	──────────	───────────────	─────────────
  foo-php			hello-php-1-348w1		0 (0%)		0 (0%)		0 (0%)		0 (0%)
  foo-php			hello-php-mysql-1-fmgy3		0 (0%)		0 (0%)		0 (0%)		0 (0%)
  mattermost			mattermost-1-b1ne9		0 (0%)		0 (0%)		0 (0%)		0 (0%)
  mattermost			mysql-1-kh8ql			0 (0%)		0 (0%)		0 (0%)		0 (0%)
  prod-hello			hello-php-1-af2eo		0 (0%)		0 (0%)		0 (0%)		0 (0%)
  test				hello-sinatra-1-cl2qi		0 (0%)		0 (0%)		0 (0%)		0 (0%)
  test-java			hello-javaee-10-et18m		0 (0%)		0 (0%)		0 (0%)		0 (0%)
Allocated resources:
  (Total limits may be over 100%, i.e., overcommitted. More info: http://releases.k8s.io/HEAD/docs/user-guide/compute-resources.md)
  CPU Requests	CPU Limits	Memory Requests	Memory Limits
  ────────────	──────────	───────────────	─────────────
  0 (0%)	0 (0%)		0 (0%)		0 (0%)
No events.
```

また、診断コマンド`oadm diagnostics`もインストールが正常に終了しているかどうかの確認に便利です。実行結果の部分のErrorが0であることを確認してください。

```
oadm diagnostics --diaglevel=0 > oadm-diagnostics.txt
```

### ノードのコンテナとイメージの削除

ノードには[ガベージコレクション](https://docs.openshift.com/enterprise/3.2/admin_guide/garbage_collection.html)の機能があり、 停止された古いコンテナや、コンテナに利用されていないイメージは自動的に消去されるようになっています。

### 古い、既に利用されていないイメージの削除

[Pruning Objectsの章](https://docs.openshift.com/enterprise/3.2/admin_guide/pruning_resources.html)で、DeploymentとBuildとイメージの削除について触れられています。

イメージはDocker registry内でディスク容量を消費するので、定期的にクリーンアップする必要がでてきます。イメージを削除するためにはイメージを参照しているDeploymentとBuildも削除する必要があるので、基本的にはこのメンテナンス作業は全て同時に行います。

クリーンアップを行う`oadm prune`コマンドはデフォルトでdry-runとなっており、実際に削除を実行するには`--confirm`オプションを指定する必要があります。

DeploymentとBuildのクリーンアップはストレートに実行できます。

```
oadm prune deployments
oadm prune deployments --confirm
oadm prune builds
oadm prune builds --confirm
```

イメージの削除を行う`oadm prune images`はOSE 3.2では技術的な制限によりcluster adminアカウントでは実行することができません。専用のユーザを用意し、`system:image-pruner`権限を付与する必要があります。`system:admin`ユーザに戻るには`oc login`に-uオプションを指定する必要があります。-uオプションではない`oc login`コマンドではユーザ名にコロンは受け付けません。

```
oadm policy add-cluster-role-to-user system:image-pruner pruner
oc login -u pruner
oadm prune images
oadm prune images --confirm
oc login -u "system:admin"
```

### ノードの追加

ノードの追加はAnsibleのnew_nodesセクションに`new_nodes`を追加して、scaleup.ymlというplaybookを実行します。実行後にnew_nodesをnodes配下に移動します。

```
[OSEv3:children]
masters
nodes
new_nodes

(省略)
[new_nodes]
node[03:04].example.com openshift_node_labels="{'region': 'primary'}"
```

```
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-cluster/scaleup.yml
```

### ノードの削除

ノードの削除は以下のコマンドで削除できます。

```
oc delete node $NODENAME
```

### ノードからPodを移動

`oadm manage-node`コマンドを利用することで、ノードからPodを移動することができます。

```
oadm manage-node node02.example.com --schedulable=false
oadm manage-node node02.example.com --evacuate --pod-selector=app=myapp
oadm manage-node node02.example.com --schedulable=true
```

## バックアップ

OpenShiftでバックアップが必要となる要素は以下の3つです。

- etcd のデータ
  - `/var/lib/origin/openshift.local.etcd/` (non-HA)
  - `/var/lib/etcd/` (HA)
- 各ノードの設定ファイル
  - `/etc/origin/`
  - `/etc/etcd/` (HA)
  - `/etc/sysconfig/atomic-openshift*`
  - `/etc/sysconfig/docker*`
- Persistence Storage
  - 各ストレージサイドでのバックアップ

## トラブルシューティング

英語ですが、サポート契約者向けに[トラブルシューティングガイド](https://access.redhat.com/solutions/1542293)があります。

### トラブルシューティングのためのパッケージ

以下のパッケージ群は一般的なトラブルシューティングに役立つものです。入れておいて損はないでしょう。

```
sos sysstat net-tools bind-utils lsof tcpdump kexec-tools strace
```

### ログレベルの変更

ログレベルは`/etc/sysconfig/atomic-openshift*`に定義されており、デフォルトでは`--loglevel=2`です。0-5までの値が指定でき、5が一番多くのログを出力する設定です。

### 情報の収集

基本的な情報は`sosreport`で取得できます。`sosreport`はsosパッケージで提供されるコマンドで、ホストの基本的な情報を網羅的に収集してアーカイブを作成します。`docker.all=on`を指定しないと終了したコンテナの情報が収集されないので、調べたいコンテナのログが見つからない、というようなことになります。

```
sosreport -e docker -k docker.all=on
```
OpenShiftは残念ながらまだsosreportに対応していないため、設定やログは別途取得する必要があります。

```
journalctl -u atomic-openshift-master -u atomic-openshift-master-api -u atomic-openshift-master-controllers > `hostname`-openshift-master.log
journalctl -u atomic-openshift-node   > `hostname`-openshift-node.log
tar czf `hostname`-openshift-config.tar.gz /etc/origin /etc/sysconfig/atomic-openshift-*  /etc/sysconfig/docker*
```

ノードやネットワーク、Docker registryやRouterなどのOpenShiftのインフラを調査するには以下のコマンド群を利用します。

```
oc project default
oc version        > oc-version.txt
oc get node       > oc-get-node.txt
oc describe node  > oc-describe-node.txt
oc get hostsubnet > oc-get-hostsubnet.txt
oc get event      > oc-get-event-default.txt
oc get all,pvc,quota,limits -o wide   > oc-get-all-default.txt
oc get all,pvc,quota,limits -o yaml   > oc-get-all-yaml-default.txt
oadm diagnostics --diaglevel=0 > oadm-diagnostics.txt
```

必要に応じて`oc get logs $POD_NAME`を利用してdocker-registryやrouterのログも取得してください。

特定のプロジェクトのトラブルシューティングでは以下の情報を取得します。

```
oc project $PROJECT
oc get all,pvc,quota,limits -o wide > oc-get-all-$PROJECT.txt
oc get all,pvc,quota,limits -o yaml > oc-get-all-yaml-$PROJECT.txt
oc get event > oc-get-event-$PROJECT.txt
```

### コンテナ内ネットワークスペースのテスト

ほとんどの場合Dockerコンテナには最低限のコマンドしかインストールされておらず、`oc rsh`でpodに接続しても、たとえばnetstatコマンドなどがインストールされておらず利用できない、といったことが多々発生します。

そのような場合には、DockerホストとプロセスIDを特定して、当該Dockerホストにssh接続を行い、nsenterコマンドで当該pidのネットワークスペースをアタッチすることで、Dockerホスト側のコマンドを利用することができます。

```
oc get pod $POD -o wide
ssh <docker host>
ps -eaf | grep <pod process filter string>
nsenter -n -t $PID netstat -tan
```

## リファレンス

- [英語公式ドキュメント](https://docs.openshift.com/enterprise/3.2/welcome/index.html)
- [英語ブログ](https://blog.openshift.com/)

