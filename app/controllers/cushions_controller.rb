# rails generate controller cushions index show
require "cgi"

class CushionsController < ApplicationController
  def index
    # 「<br>」は検索条件、「#hash」はハッシュです。
    sample_url = 'https://duckduckgo.com/?q=<br>&ia=web#hash'

    @plain_url = sample_url
    @urlescaped_url = CGI.escape(sample_url)
    # @htmlescaped_url = CGI.escapeHTML(sample_url)
  end

  def show
    @urlescaped_url = params[:url]
    @url = CGI.unescape(@urlescaped_url)
    # @htmlescaped_url = CGI.escapeHTML(@url)
  end
end
