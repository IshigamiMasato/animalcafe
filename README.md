# ANIMAL CAFE

### animal cafeとは？
***
animal cafeとは自分が行ったことのある動物カフェを投稿して、他の人と動物カフェを共有できるサービスです。 

休日に動物カフェに癒されに行きたい時などは、エリア検索ですぐに近くの動物カフェを見つけることもできます。

さらに、検索して気になった動物カフェはブックマークしたり、実際に行ったことのある店舗にはクチコミを投稿できます。  

### 作成の背景
***
動物カフェは以前からありましたが、当時は猫カフェや犬カフェが主流でした。最近では、猫カフェや犬カフェ以外にも、ハリネズミカフェやフクロウカフェ、カワウソカフェなど多岐にわたる動物のカフェができています。さらに、その数は増加しており、動物カフェへの需要が高まっていると考えます。一方で、動物カフェを検索すると店舗ごとのホームページはあるものの、動物カフェのみが集まったサイトは少なく、検索のしづらさを実感しました。大型グルメサイトなどには情報が掲載されているものの、その他の飲食店に埋もれてしまっていることや、レビューが少なく実際の店舗の様子が分かりづらいことから、不便さも感じました。実際に動物カフェのまとめサイトが欲しいという声もありました。以上のことから、動物カフェに絞ったサイトを作ってみようと考え、animal cafeを作成しました。
### 使い方(gif)
***
* 店舗投稿  
![新規投稿](https://user-images.githubusercontent.com/80932192/134137400-002ef2b5-9171-46c0-b799-32650001559b.gif)  

* 気になるお店をブックマーク  
![ブックマーク](https://user-images.githubusercontent.com/80932192/134141139-8814d1ed-3118-4cab-9e0d-7175bea4a512.gif)  

* 行ったお店にクチコミ  
![クチコミ](https://user-images.githubusercontent.com/80932192/134141690-cf0250f4-c064-466d-abd1-9a05b8795912.gif)  

### ER図
***
<img width="1053" alt="animalcafe_er_diagram" src="https://user-images.githubusercontent.com/80932192/132515995-4e2b0199-569e-4991-9db4-7825baeb5435.png">

### こだわった点
***
* 動物カフェの情報を共有するだけでなく、実際に行った人のリアルの感想やお店の雰囲気をその投稿に反映させたかったのでクチコミ機能を投稿ページに取り入れました。
* PCからみても携帯から見てもレイアウトが崩れないようにレスポンシブ対応に気を使いました。
### 機能一覧
***
* ユーザー登録機能
* ユーザーログイン機能
* ユーザー認証機能
* パスワード再設定機能
* 店舗投稿機能
* 画像投稿機能(Active Storage)
* 画像スライド機能(slick)
* Googlemap表示機能(Google Maps Javascript API)
* 店舗住所からの緯度経度変換(Geocoding API)
* ブックマーク機能(ajax)
* レビュー機能
### heroku URL
***
https://dry-dawn-42498.herokuapp.com
### 言語・環境
***
- ruby 2.6.7  
- Rails 6.1.4
  - テストツール
    - rspec
    - rubocop-airbnb
