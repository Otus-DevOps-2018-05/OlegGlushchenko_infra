# OlegGlushchenko_infra_07

- Используя нарботки предыдущего дз, создали инфраструктуру при помощи terraform
- Ипортирована существующая инфраструктура в terraform, созданная из веб-приложения
- Задан IP для инстанса с приложением в виде внешнего ресурса
- Монолитный файл main.tf разделен на отедельные логические модули - app, db, vpc со своего IP)
- Проведена работа по параметризации. Работа параметризованного модуля vpc была проверена на примере доступа только с личного IP-адреса
- Созданы 2 отдельных окружения prod и state
- Созданы 2 bucket в Google Cloud Storage
- Выполнено первое задание со * : настроено хранение стейт файла в удаленном бекенде (remote backends) для окружений stage и prod
- Выполнено второе задание со * : добавлены необходимые provisioner в модули для деплоя и работы приложения 
Файлы для provisioner'ов хранятся в директории модуля. Для их использования необходмо обращаться через ${path.module}/)
Для запуска приложения в puma.service была использована опция EnvironmentFile=/tmp/puma.env. В puma.env записывается  переменная окружения DATABASE_URL внутренним ip-адресом интанса reddit-db. Для возможности подключения к БД в /etc/mongod.conf была проведена замена 127.0.0.1 на 0.0.0.0
Отключение provisioner в зависимости от значения переменной реализовано через count = "${var.provision_enabled ? 1 : 0}". Переменная по умолчанию имеет значение "false", т.е. provisioner'ы по умолчанию выключены


# OlegGlushchenko_infra_06
OlegGlushchenko Infra repository

Отработана практика создания VM с помощью шаблонов terraform. Отработана работа с шаблоном, входными и выходными переменными, работа с инстансами и правилами файерволла, а также разворачивание проекта из базового образа с применением deploy.sh.
Выполнено задание со " * ":
 - отработан способ добавления SSH ключей в метаданные проекта. Необходимо помнить, что если ключи, добавленные через web-интерфейс, будут затерты после очередного запуска terraform.

Выполнено задание с " ** ":
 - настроен балансировщик. При его использовании возникают следующие проблемы 
    - если количество однотипных инстансов увеличивать добавлением новых строк, получается слишком большой листинг (решается использованием count).
    - оба инстанса используют каждый свою БД, т.е. при падении одного инстанса, данные становятся недоступны, изменения теряются (решается использованием стороннего сервера БД)
    - готовый листинг балансировщика может состоять из нескольких строк, так и нескольких страниц кода - настройка может быть слишком сложной (можно использовать готовые модули балансировщиков, подгоняя под свои нужды)

# OlegGlushchenko_infra_05
OlegGlushchenko Infra repository

Создан базовый шаблон с дополнительными параметрами. Часть параметров вынесены в отдельный файл.
Выполнены задания со " * ":
 - создан шаблон на основе базового, разворачивающего приложение.
 - создан скрипт для запуска виртуальной машины с развернутым приложением

# OlegGlushchenko_infra_04
OlegGlushchenko Infra repository

bastion_IP = 35.195.137.24
someinternalhost_IP = 10.132.0.3

testapp_IP = 35.233.78.211
testapp_port = 9292

### Дополнительное задание 1
#### Листинг **startup script**:
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

### Дополнительное задание 2
#### Удалить правило файера:

    gcloud compute firewall-rules delete default-puma-server


#### Добавить правило файера:

    gcloud compute firewall-rules create default-puma-server \
        --network default \
        --action allow \
        --direction ingress \
        --rules tcp:9292 \
        --source-ranges 0.0.0.0/0 \
        --priority 50 \
        --target-tags puma-server

