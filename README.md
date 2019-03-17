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
gem 'mini_racer', platforms: :ruby
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
$ docker-compose up -d
```

Unknown database 'app_name_development'が表示された場合はデータベースを作成する

```
$ docker-compose run web rake db:create
```

# マイグレーション

# カラム追加

```
$ rails g migration クラス名 カラム名:データ型( カラム名:データ型)
$ rails g migration AddUser notification_flag:boolean author:string
```

# データ型の変更

```
$ rails g migration change_datatype_カラム名 _ of _ テーブル名
$ rails g migration change_datatype_notification_allowed_of_user
```

* ...
