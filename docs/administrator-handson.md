<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [OpenShift Enterprise 3.1.1 管理者向けハンズオン](#openshift-enterprise-311-%E7%AE%A1%E7%90%86%E8%80%85%E5%90%91%E3%81%91%E3%83%8F%E3%83%B3%E3%82%BA%E3%82%AA%E3%83%B3)
  - [インストールの事前要件](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%AE%E4%BA%8B%E5%89%8D%E8%A6%81%E4%BB%B6)
  - [インストール](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)
    - [インスタンスの準備](#%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9%E3%81%AE%E6%BA%96%E5%82%99)
    - [サブスクリプションの設定](#%E3%82%B5%E3%83%96%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E8%A8%AD%E5%AE%9A)
    - [Dockerのイメージ領域設定](#docker%E3%81%AE%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E9%A0%98%E5%9F%9F%E8%A8%AD%E5%AE%9A)
    - [AnsibleでOpenShiftをインストールする](#ansible%E3%81%A7openshift%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B)
    - [Docker registryの作成](#docker-registry%E3%81%AE%E4%BD%9C%E6%88%90)
    - [Persistence Volumeの設定と作成](#persistence-volume%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%81%A8%E4%BD%9C%E6%88%90)
  - [リファレンス](#%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# OpenShift Enterprise 3.1.1 管理者向けハンズオン

## インストールの事前要件

- 十分な数のOpenShift Enterpriseのサブスクリプションが必要です。
- DNSの設定が必要です。インストール対象のホスト名、アプリケーションに割り当てるワイルドカードDNSエントリが設定されている必要があります。ワイルドカードDNSエントリはRouter podがデプロイされているノードのIPアドレスとなります。一般的に設定は以下のようになります。
  - 10.xx.xx.11 master.example.com
  - 10.xx.xx.21 infra1.example.com
  - 10.xx.xx.31 node01.example.com
  - 10.xx.xx.32 node02.example.com
  - 10.xx.xx.21 *.apps.example.com

## インストール

ここでは簡略化した基本的なインストールの手順を紹介します。セットアップの詳細については[オフィシャルのインストールガイド](https://docs.openshift.com/enterprise/3.1/install_config/index.html)を参照してください。

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
     --enable=rhel-7-server-ose-3.1-rpms
sudo yum update
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

AnsibleでOpenShiftをインストールする方法はマニュアルでは[Advanced Installation](https://docs.openshift.com/enterprise/3.1/install_config/install/advanced_install.html)というタイトルで記述されていますが、ウィザード形式ではない、くらいの意味でそれほどAdvancedでもありません。基本的に用意するファイルはAnsibleのインベントリファイルひとつだけです。

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
ansible_sudo=true
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

あとは以下のコマンドでAnsibleを実行するとインストールが行われます。

```
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
```

### Docker registryの作成

Docker registryは全Docker imageを保持するため、かなり大きな容量が必要になります。専用のPersistentVolumeをRetainポリシーで作成します。以下はnfsでの例です。

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

### Persistence Volumeの設定と作成

Persistence Volumeのセットアップは環境により異なるので[公式ドキュメント](https://docs.openshift.com/enterprise/3.1/install_config/persistent_storage/index.html)を参照してください。

テスト目的でNFSを設定する場合は以下のように設定できます。

```
sudo mkdir -p /exports
sudo chown -R nfsnobody:nfsnobody /exports
sudo chmod 777 /exports/
sudo sh -c "cat << EOM > /etc/exports
/exports *(rw,sync,root_squash)
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


## リファレンス

- [英語公式ドキュメント](https://docs.openshift.com/enterprise/3.1/welcome/index.html)
- [英語ブログ](https://blog.openshift.com/)

