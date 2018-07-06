# OlegGlushchenko_infra_04
OlegGlushchenko Infra repository

bastion_IP = 35.195.137.24
someinternalhost_IP = 10.132.0.3

testapp_IP = 35.198.167.169
testapp_port = 9292

### Дополнительное задание 1
#### Листинг **startup script**:
'''
    gcloud compute instances create reddit-app \
    --boot-disk-size=10GB \
    --image-family ubuntu-1604-lts \
    --image-project=ubuntu-os-cloud \
    --machine-type=g1-small \
    --tags puma-server \
    --restart-on-failure \
    --metadata startup-script='#! /bin/bash
    sudo su -
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
    cat <<EOF > /etc/apt/sources.list.d/mongodb-org-3.2.list
    deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse
    EOF
    apt-get update
    apt install -y ruby-full ruby-bundler build-essential
    apt install -y mongodb-org
    systemctl start mongod
    systemctl enable mongod
    mydir = $HOME
    git clone -b monolith https://github.com/express42/reddit.git $mydir
    cd $mydir/reddit && bundle install
    puma -d'
'''

### Дополнительное задание 2
#### Удалить правило файера:
'''
    gcloud compute firewall-rules delete default-puma-server
'''

#### Добавить правило файера:
'''
    gcloud compute firewall-rules create default-puma-server \
        --network default \
        --action allow \
        --direction ingress \
        --rules tcp:9292 \
        --source-ranges 0.0.0.0/0 \
        --priority 50 \
        --target-tags puma-server
'''
