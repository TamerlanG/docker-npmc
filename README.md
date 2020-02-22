# Добро пожаловать!
Репозиторий позволяет развернуть стек контейнеров в __Docker__. Будет создано пять контейнеров:
* [MariaDB](https://mariadb.org/) - ответвление от системы управления базами данных __MySQL__, разрабатываемое сообществом под лицензией GNU GPL;
* [PHPMyAdmin](https://www.phpmyadmin.net/) - веб-приложение с открытым кодом, написанное на языке __PHP__ и представляющее собой веб-интерфейс для администрирования СУБД __MySQL__
* [Composer](https://getcomposer.org/) - это пакетный менеджер уровня приложений для языка программирования __PHP__, который предоставляет средства по управлению зависимостями в __PHP-приложении__;
* [PHP-FPM](https://www.php.net/manual/ru/install.fpm.php) - является альтернативной реализацией __PHP FastCGI__ с несколькими дополнительными возможностями обычно используемыми для высоконагруженных сайтов;
* [NGINX](https://nginx.org/ru/) - веб-сервер и почтовый прокси-сервер, работающий на __Unix-подобных__ операционных системах.

## Установка
1. Создайте директорию для __Docker__ проектов (если еще не создавали) в домашнюю директорию ```mkdir ~/Dockers```;
2. Зайдите в директорию ```cd ~/Dockers``` и клонируйте репозиторий ```git clone https://github.com/btn441/docker-npmc.git``` или через ssh ```git clone git@github.com:btn441/docker-npmc.git```;
3. Создайте директорию ```mkdir ~/Backends``` где будут хранится проекты.
4. Теперь давайте добавим в конец строчку ```127.0.0.1 example.test``` в файл ```sudo nano /etc/hosts```. Мы для себя откроет домен __example.test__;
5. Отлично! Давайте теперь зайдем ```cd ~/docker-npmc/nginx/sites/``` и посмотрим файлы ```ls```. Мы видим __example.conf__. Для каждого проекта создаем и редактируем данные конфиги (копируем данный файл, переименовываем и редактируем);
6. По идеи всё! Осталось почитать документацию ниже, о том как с этим всем работать __;)__

## Docker
Репозиторий предпологает, что у нас установленны ```docker``` и ```docker-compose```. </br>
Чтобы не писать перед __Docker__ командами __sudo__, добавьте вашего пользователя в группу ```docker```. </br>
Полезные комманды, для __Docker__:
* ```docker-composer up``` - запустить __Docker__ (не в фоне);
* ```docker ps``` - посмореть активные контейнеры;
* ```docker exec -tiu {user_name} {name_container} bash -l``` - зайти в контейнер (```{name_container}``` - название контейнера).

## Makefile (юзаем команды не входя в docker)
Внимание! Если вы идете против README.md, посмотрите код Makefile. Нужно будет настроить под себя.</br>
Вы можете использовать __Docker__ не выходя из проекта и прямо от туда использовать команды в терминале.</br>
Для установки __Makefile__, пропишите следущее: </br> 
```echo 'alias docker-make="make -f ~/Dockers/docker-npmc/Makefile"' >> ~/.bashrc```

Команды выполнять в корне проекта и пишите вначале ```make ...```
| Команда | Аргументы | Описание |
|:-|:-|:-:|
| make php | - | Зайти в bash php-fpm |
| make composer | - | Зайти в bash composer |
| make nginx | - | Зайти в bash nginx |
| make phpmyadmin | - | Зайти в bash phpmyadmin |
| make database | - | Зайти в bash database |
| make migrate | - | Применить миграцию |
| make migrate-create var=test | var (название миграции) | Создать миграцию |
| make install | - | Установить зависимости |

## Доступ к контейнеру (работа с юзерами)
Т.к. мы должны иметь контакт с проектом (создать миграцию или обновить зависимости), нам необходимо заходить в контейнера. Ниже таблица, частых кейсов по заходу в контейнер:
| Контейнер | Задача | Пользователь |
|:-:|:--:|:-:|
| composer | Обновить зависимости | user |
| php-fpm | Создание миграций | user |
| nginx | Зайти в контейнер | root 
| database | Зайти в контейнер | root |
| phpmyadmin | Зайти в контейнер | root |

### Изменить/Добавить пользователя
В __Dockerfile__ можно найти под командой ```RUN``` строку ```useradd```, ```groupadd``` или ```adduser```</br>
Там по стандарту __UID|GID__ 1000 (основной юзер системы __не root__). Можно найти информацию по __UID|GID__ по данной команде ```id``` и там можно копировать необходимую для вас информацию. Ниже таблица, что к чему. 
| Идентификатор | Описание |
|:-:|:-:|
| UID | ID юзера |
| GID | ID группы |

## NGINX
Все новые домены для проектов не забывайте записывать в ```/etc/hosts```! Пример ```127.0.0.1 examlpe.test```. </br>
Все наши домены должны оканчиваться на __.test__ (не обязательно).</br>
Каждый новый проект клонируется в директорию ```cd ~/Backends/``` и добавляется новый конфиг в __NGINX__ ```cd ~/Docker/docker-npmc/nginx/sites/```. Ну и не забываем про ```/etc/hosts```.

## Composer
Зависимости можно обновлять через контейнер __composer__. </br>
Зайдите в контейнер ```docker exec -tiu root backends_composer_1 bash -l```, выберите проект ```ls && cd example``` и вводите команды связанные с __composer__.

## PHP-FPM
С проектом __PHP__ можно общаться через контейнер __php-fpm__. </br>
Зайдите в контейнер ```docker exec -tiu root backends_php-fpm_1 bash -l```, выберите проект ```ls && cd example``` и вводите команды связанные с __php-fpm__.

## Database
БД у нас будет использоваться __MariaDB__.</br>
Логи: __root__</br> 
Пароль: __docker__

## PHPMyAdmin
Чтобы делать изменения напрямую в __MariaDB__, у нас есть __PHPMyAdmin__.</br>
Ссылка http://localhost:8765

# Проблемы (просто следуйте рекомендациям ниже и всё будет хорошо)
1. Если вы устанавливаете пакеты через __composer__ используйте флаг ```--ignore-platform-reqs```;
