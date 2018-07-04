# OlegGlushchenko_infra
OlegGlushchenko Infra repository

Подключение к someinternalhost
ssh -i ~/.ssh/gcp -A olegglushchenko@35.195.137.24 -t ssh olegglushchenko@10.132.0.3

Доп. задание.
Привести/дополнить ~/.ssh.conf до вида:
Host bastion 
        HostName 35.195.137.24
        Port 22 
        User olegglushchenko
        IdentityFile ~/.ssh/gcp
        ForwardAgent yes
        ProxyCommand none
Host someinternalhost
        HostName 10.132.0.3
        Port 22
	User olegglushchenko
	ProxyCommand ssh bastion -W %h:%p

Подключение до someinternalhost проводить коммандой - ssh someinternalhost
Бонус до bastion'а можно достучаться командой - ssh bastion 



bastion_IP = 35.195.137.24
someinternalhost_IP = 10.132.0.3
