# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version  
2.5.1

* System dependencies

* Configuration  
Gemfileの変更

```
gem 'therubyracer', platforms: :ruby
```

```
$ docker-compose build
```

* Database creation  
config/database.ymlの設定

```
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: root
  password: password
  host: db
...
```
* passwordをdocker-compose.ymlの「MYSQL_ROOT_PASSWORD」と同じにする
* hostをdocker-compose.ymlの「depends_on」と同じにする

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

```
$ docker-compose up
```

* ...
