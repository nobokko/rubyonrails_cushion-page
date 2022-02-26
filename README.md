# README

以下、Zennへ投稿した記事の転載です。

最新は 

https://zenn.dev/nobokko/articles/tech_ruby_rails_cushion

# きっかけ

LINEのRuby系のオプチャにてクッションページが上手く作れないという方が居たので作ってみました。

# クッションページとは？

アダルトサイトの年齢確認のページのような、**本来のURLの表示の前にユーザに再度アクセスの意思を問い合わせるページ**を指してクッションページと呼ぶ事が多いようです。

外部リンクに対してクッションページが存在する場合は、ユーザーへの移動確認の他に、**クリックのアクセス解析**や**広告枠の確保**などが目的の場合もあるようです。^[少なくともクリックのアクセス解析目的であれば、今どきはもっと他にやりようがあるので、それが目的の導入であれば微妙かと思います。]

ここでは本文中のリンクをクリックした際にそのリンク先に本当に移動してもよいか問い合わせるクッションページを作成します。

# 手順

## 事前準備

### Docker

https://zenn.dev/nobokko/articles/tech_ruby_rails_firststep

と同様のDockerfile & docker-compose.yml を使用しています。

### Railsプロジェクトの作成

コンテナ内の展開先で以下のコマンドを叩いていきます。

今回はクッションページを作ることが主目的なのでできるだけ使わないものは省かれるようにオプションを選択してみたつもり^[まだまだ省けそうな気配はあります]です。

```bash
rails _6.1.4.1_ new . --force --minimal --skip-activerecord --skip-test
```

同ディレクトリで以下のコマンドを実行してブラウザで http://localhost:3000/ にアクセスするととりあえず動作していることが確認できました。

```bash
rails s -p 3000 -b '0.0.0.0'
```

### クッションページの作成

クッションページなのでコントローラー名は「cushions」^[最後に「s」を付けるとルーティングヘルパーが利用しやすくなるのかと思いましたがそうでもなかったです。]としました。

showにクッションページの本体を作成します。

indexにはクッションページへのリンクのサンプルを配置するので一緒に作成します。

```bash
rails generate controller cushions index show
```

上記コマンドでルーティングも自動的に設定してくれるのですが、今回の目的に沿った形に書き換えます。

```ruby:config/routes.rb
Rails.application.routes.draw do
  root to: 'cushions#index'
  get 'cushions/', to: 'cushions#index'
  get 'cushions/:url', to: 'cushions#show', constraints: { url: /.+/ }
end
```

- / や /cushions/ にアクセスした場合はクッションページへのリンクのサンプルページを表示します
- /cushions/にパラメータが付いている場合はそれをURLと判断してクッションページを表示します

ここが本題です。

上記コマンドで生成されているはずのコントローラとビューを先に確認してください。

```ruby:app/controllers/cushions_controller.rb
# rails generate controller cushions index show
require "cgi"

class CushionsController < ApplicationController
  def index
    # 「<br>」は検索条件、「#hash」はハッシュです。
    sample_url = 'https://duckduckgo.com/?q=<br>&ia=web#hash'

    @plain_url = sample_url
    @urlescaped_url = CGI.escape(sample_url)
  end

  def show
    @urlescaped_url = params[:url]
    @url = CGI.unescape(@urlescaped_url)
  end
end
```

```erb:app/views/cushions/index.html.erb
<h1>Cushions#index</h1>
<p>Find me in app/views/cushions/index.html.erb</p>
<%= link_to @plain_url, "/cushions/#{@urlescaped_url}", { :target => "_blank" } %>(通常は別のタブが開きます)
```

```erb:app/views/cushions/show.html
<h1>Cushions#show</h1>
<p>Find me in app/views/cushions/show.html.erb</p>
<%= link_to @url, @url %>は当サイトではない外部のページです。
```

大切な点は
- URLを埋め込む際に事前にエスケープ、もしくはエンコードをしておく
- クッションページではそれに対応するアンエスケープ、もしくはデコードをする

ことです。

処理の流れとしては
1. コントローラで事前に表示するページのURLを抽出し、それらをエスケープしたうえでURLをクッションページに差し替える
2. サンプルページの方では、外部リンクのURLを表示はするけど、実際のリンク先はクッションページにする
3. クッションページのコントローラでパラメータのURLをエスケープされる前のURLに戻す
4. クッションページでは普通にリンクを張る

となります。

## 補足

### config/routes.rb のクッションページの設定に関して

URLには通常、ドメインなどの区切り文字として「.（ドット）」が使用されます。

一方でRailsのルーティングでも意味があり、「.」以下はformat（拡張子的なもの）扱いされます。

したがって、クッションページにURLを含める際は
- 「.」が無い状態（BASE64エンコードするなど）にする
- 「.」が含まれていてもルーティングでformat扱いされないようにする

のどちらかが必要になります。

今回は「constraints」を個別に設定することで「.」が含まれていてもルーティングでformat扱いされないようにすることとしました。

### ソース全体

クッションページの作成 セクション以降で作成されるファイル全体は以下のGitHubリポジトリに置いてあります。

https://github.com/nobokko/rubyonrails_cushion-page

# まとめ

- 本来のリンク先URLをURL以外の形に変形して
- クッションページへそれを渡して
- クッションページで元の状態に戻す

お疲れさまでした。