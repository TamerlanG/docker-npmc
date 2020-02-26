# Добро пожаловать!
Репозиторий позволяет развернуть стек контейнеров в __Docker__. Будет создано пять контейнеров:
* [MariaDB](https://mariadb.org/) - ответвление от системы управления базами данных __MySQL__, разрабатываемое сообществом под лицензией GNU GPL;
* [PHPMyAdmin](https://www.phpmyadmin.net/) - веб-приложение с открытым кодом, написанное на языке __PHP__ и представляющее собой веб-интерфейс для администрирования СУБД __MySQL__
* [Composer](https://getcomposer.org/) - это пакетный менеджер уровня приложений для языка программирования __PHP__, который предоставляет средства по управлению зависимостями в __PHP-приложении__;
* [PHP-FPM](https://www.php.net/manual/ru/install.fpm.php) - является альтернативной реализацией __PHP FastCGI__ с несколькими дополнительными возможностями обычно используемыми для высоконагруженных сайтов;
* [NGINX](https://nginx.org/ru/) - веб-сервер и почтовый прокси-сервер, работающий на __Unix-подобных__ операционных системах.

## Установка
Скачайте из [релизов](https://github.com/btn441/docker-npmc/releases) необходимую вам версию. Файл является bash скриптом. Файл загружает репозиторий и делает правильную структуры, для работы с данной конфигурацией __Docker'а__.

## Docker
Полезные комманды, для __Docker__:
* ```docker-composer up``` - запустить __Docker__ (не в фоне);
* ```docker ps``` - посмореть активные контейнеры;
* ```docker-compose build``` - сбилдить;
* ```docker exec -tiu {user_name} {name_container} bash -l``` - зайти в контейнер (```{name_container}``` - название контейнера).

## Makefile (юзаем команды не входя в docker)
Внимание! Если вы идете против README.md, посмотрите код Makefile. Нужно будет настроить под себя.</br>
Вы можете использовать __Docker__ не выходя из корня проекта и прямо от туда использовать команды в терминале.</br>

Команды выполнять в корне проекта и пишите вначале ```docker-npmc ...```
| Команда | Аргументы | Описание |
|:-|:-|:-:|
| docker-npmc php | - | Зайти в bash php-fpm |
| docker-npmc composer | - | Зайти в bash composer |
| docker-npmc nginx | - | Зайти в bash nginx |
| docker-npmc phpmyadmin | - | Зайти в bash phpmyadmin |
| docker-npmc database | - | Зайти в bash database |
| docker-npmc migrate | - | Применить миграцию (нужно быть в корне проекта) |
| docker-npmc migrate-create a=test | a (название миграции) | Создать миграцию (нужно быть в корне проекта) |
| docker-npmc new a=test | a (название проекта) | Сгенерировать конфиг nginx и записать домен в /etc/hosts |
| docker-npmc install | - | Установить зависимости (нужно быть в корне проекта) |

## Database
БД у нас __MariaDB__.</br>
Логи: __root__</br> 
Пароль: __docker__

## PHPMyAdmin
Чтобы делать изменения напрямую в __MariaDB__, у нас есть __PHPMyAdmin__.</br>
Ссылка http://localhost:8765

## Доступ к контейнеру (работа с юзерами)
Ниже таблица, частых кейсов по заходу в контейнер:
| Контейнер | Задача | Пользователь |
|:-:|:--:|:-:|
| composer | Обновить зависимости | user |
| php-fpm | Создание миграций | user |
| nginx | Зайти в контейнер | root |
| database | Зайти в контейнер | root |
| phpmyadmin | Зайти в контейнер | root |

### Изменить/Добавить пользователя
В __Dockerfile__ можно найти под командой ```RUN``` строку ```useradd```, ```groupadd``` или ```adduser```</br>
Там по стандарту __UID|GID__ 1000 (основной юзер системы __не root__). Можно найти информацию по __UID|GID__ по данной команде ```id``` и там можно копировать необходимую для вас информацию. Ниже таблица, что к чему. 
| Идентификатор | Описание |
|:-:|:-:|
| UID | ID юзера |
| GID | ID группы |

## Общая информация

### NGINX
Все новые домены для проектов записывать в ```/etc/hosts```! Пример ```127.0.0.1 examlpe.test```. </br>
Все наши домены должны оканчиваться на __.test__ (не обязательно, но рекомендуется).</br>
Добавляйте новый конфиг в __NGINX__ ```cd ~/docker-npmc/docker/nginx/sites/```. В директории есть пример ```example.conf```.

### Composer
Зависимости можно обновлять через контейнер __composer__. </br>
Зайдите в контейнер ```docker-compose exec -u root composer bash -l```, выберите проект ```ls && cd example``` и вводите команды связанные с __composer__.

### PHP-FPM
С проектом __PHP__ можно общаться через контейнер __php-fpm__. </br>
Зайдите в контейнер ```docker-compose exec -u user php-fpm bash -l```, выберите проект ```ls && cd example``` и вводите команды связанные с __php-fpm__.

# Проблемы (просто следуйте рекомендациям ниже и всё будет хорошо)
1. Если вы устанавливаете пакеты через __composer__ используйте флаг ```--ignore-platform-reqs```;
