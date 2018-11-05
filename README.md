# OlegGlushchenko_infra_10
- Созданы роли для управления конфигурацией инстанса с MongoDB и инстанса приложения. Изменены плейбуки app.yml и db.yml для запуска ролей. Работоспособность ролей проверена через запуск "плейбука плейбуков" (site.yml)
- Созданы два окружения stage и prod. Указано окружение по умолчанию (прописывается в ansible.cfg). Определили переменные групп хостов для каждого окружения.
- Организовали плейбуки согласно best practies. Улучшили ansible.cfg. Произвели проверку окружений stage и prod после внесенных изменений.
- Провели работу с комьюнити ролями, в ходе которой:
    - установили jdauphant.nginx через requirements.yml, размещенного в директории каждого из окружений
    - разрешили 80 порт через terraform (модуль vpc)
    - прописав вызов jdauphant.nginx в плейбуке app, проверили работоспособность nginx (ЗАМЕТКА jdauphant.nginx требует python-apt для работы в режиме --check - python-apt must be installed to use check mode). Сайт открывается через 80 порт.
- Разобрали работу ansible vault: для каждого окружения создали свой набор логин\пароль, зашифровали их vault'ом, создали плейбук для добавления пользователей в инстансы (all). (Помни для редактирования переменных нужно использовать команду ansible-vault edit file, для расшифровки - ansible-vault decrypt file)
- Выполнено задание со *. Скрипт dynamic_inventory.sh скопирован в каждую директорию stage и prod. Скрипт использует утилилиту terraform-inventory и путь до tfstate файла в нужном окружении terraform'а. Для развертывания state с динамическими инстансами используются ansible.cfg. Для развертывания prod придется использовать ключ -i c путем до скрипта (запуск проводить в директории ansible)



# OlegGlushchenko_infra_09
- Создан плейбук reddit_app.yml с тасками изменения конфигурации на хосте с БД и хосте с приложением
- В созданном плейбуке добавлен handler для перезапуска сервиса mongod при смене конфигурации, а также перезапуска вебсервера
- Добавлены таски для деплоя приложения
- Создан плейбук reddit_app2.yml в котором создано 3 сценария: для БД, для вебсервера, для деплоя приложения.
- Плейбуки reddit_app.yml и reddit_app2.yml переименованы в reddit_app_one_play.yml и reddit_app_multiple_plays.yml соответственно.
- Создан "плейбук плейбуков" site.yml, который объединяет db.yml, app.yml, deploy.yml.
- Создан и интергрирован в пакер плейбук для пакера
- Выполнено задание со *. Для динамического инвентори использована утилита terraform-inventory (https://github.com/adammck/terraform-inventory), которая должна забирать сведения о хостах из tfstatе'а. Есть особенности использования этой утилиты: 
    - запускать утилиту рекомендуют из директории с окружением, т.е. там, где есть tfstate (не очень удобный вариант).   
    - утверждают, что с удаленным (remoute state) тоже должна работать (у меня, при хранении стейта в бакете не захотела)
    - путь до нее не более 3 директорий вложенности (/path/to/terraform-inventory, с большим кол-ом у меня не заработала)
    - чтобы исправить "фичу" из предыдущего пункта рекомендуют создать баш-скрипт, в котором необходимо связать terraform-inventory и tfstate (в данном проекте - dynamic_inventory.sh)
    - именно dynamic_inventory.sh должен формировать json со списоком инстансов, поэтому его и следует прописывать в cfg файл.   


# OlegGlushchenko_infra_08

- Был установлен с помощью pip и файла requirements.txt пакет ansible (для установки требуется помимо pip еще setuptools)
- С помощью файла inventory проверили доступность инфраструктуры, запущенной через terraform окружения stage
- Для удаления избыточности inventory, упрощения конфигурации повторящийся конфиг из inventory перенесли в ansible.cfg 
- Создали группы серверов в inventory
- Перевели inventory в формат YAML
- При выполнении команд необходимо помнить:
    - что модуль command, выполяет команды не используя shell, поэтому в нем не работает перенаправление потоков;
    - для корректной отработки команд необходимо правильнее использовать специализированные модули systemd, service, git. Их применение дает более информативный вывод, защищает от "падения" команды в ошибку
- Реализован простейший плейбук, в котором клонируется репозиторий в домашнюю директорию. При первом запуске плейбук выполнится с состоянием changed=0, т.к. в домашней директории уже есть директория reddit. Если reddit удалить и запустить плейбук заново, он завершится с состоянием changed=1
- Выполнено задание со *. Написан скрипт inventory.py (сделан исполняемым, написан для python 2.7), который формирует json cо списком хостов. Запуск проверки хостов (пинга) динамическим inventory: ansible all -m ping -i inventory.py. Реализация inventory.py топорная и примитивная, создана только для понимания процесса работы динамического inventory.

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

