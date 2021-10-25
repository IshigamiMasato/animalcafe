# ANIMAL CAFE

![スクリーンショット 2021-10-03 20 14 58](https://user-images.githubusercontent.com/80932192/135751201-333a8916-3326-4566-b491-4b44bc163827.png)

## animal cafeとは？
animal cafeとは自分が行ったことのある動物カフェを投稿して、他の人と動物カフェを共有できるサービスです。 

休日に動物カフェに癒されに行きたい時などは、エリア検索ですぐに近くの動物カフェを見つけることもできます。

さらに、検索して気になった動物カフェはブックマークしたり、実際に行ったことのある店舗にはクチコミを投稿できます。  

## 作成の背景
動物カフェを検索する際不便に感じることがあると友人から聞き、その問題をポートフォリオで解決しようと考えたのがanimal cafe作成のきっかけです。不便に感じていた点は具体的に、動物カフェを検索すると店舗ごとのホームーページはあるものの動物カフェのみが集まったサイトが少なく、検索のしづらさを感じるといったものでした。大型グルメサイトなどには情報がまとまって掲載されているものの、その他の飲食店に埋もれてしまっていることや、レビューが少なく実際の店舗の様子がわかりづらいことから不便さを感じているようでした。以上のことから、動物カフェにしぼったまとめサイトを作成すれば問題解決できると考え、animal cafe作成に至りました。

## 使い方(gif)
* 店舗投稿  
![新規投稿](https://user-images.githubusercontent.com/80932192/134137400-002ef2b5-9171-46c0-b799-32650001559b.gif)  

* 気になるお店をブックマーク  
![ブックマーク](https://user-images.githubusercontent.com/80932192/134141139-8814d1ed-3118-4cab-9e0d-7175bea4a512.gif)  

* 行ったお店にクチコミ  
![クチコミ](https://user-images.githubusercontent.com/80932192/134141690-cf0250f4-c064-466d-abd1-9a05b8795912.gif)  

## アプリURL
https://dry-dawn-42498.herokuapp.com  
※ログイン画面からゲストログインできます。

## こだわった点
■UI操作性の向上  
・画面幅によってレイアウトが崩れないようレスポンシブデザインの徹底  
・ブックマークボタンの非同期通信化  
■保守性の向上  
・テストコード  (247spec)  
・GitHub Actionsによるテストとデプロイの自動化  
・viewコードのパーシャル化  
■検索性の向上  
・エリア検索とタグ検索

## 機能一覧
* ユーザー登録機能
* ユーザーログイン機能
* ゲストログイン機能
* ユーザー認証機能
* ユーザー詳細機能
* ユーザー一覧機能
* パスワード再設定機能
* 店舗投稿機能
* 店舗詳細機能
* 店舗編集・削除機能
* 店舗検索機能
* ページネーション(will_paginate)
* 画像投稿機能(Active Storage)
* 画像スライド機能(slick)
* Googlemap表示機能(Google Maps Javascript API)
* 店舗住所からの緯度経度変換(Geocoding API)
* ブックマーク機能(ajax)
* レビュー機能

## 環境・使用技術

### バックエンド
* Ruby 2.6.7
* Rails 6.1.4

### フロントエンド
* Bootstrap 5.0.0-beta3
* Font-awesome
* SCSS
* JavaScript
* jQuery
* Webpack

### 本番環境
* Heroku
* AWS S3
* GitHub Actionsによる自動テスト、自動デプロイ

### テストツール
* RSpec (247spec)
  * model spec ... モデルのバリデーションやメソッドなどのテスト
  * request spec ... リクエストのレスポンスとControllerのロジック部分のテスト
  * system spec ... UIの統合テスト
* RuboCop-airbnb

## ER図
<img width="1053" alt="animalcafe_er_diagram" src="https://user-images.githubusercontent.com/80932192/132515995-4e2b0199-569e-4991-9db4-7825baeb5435.png">
