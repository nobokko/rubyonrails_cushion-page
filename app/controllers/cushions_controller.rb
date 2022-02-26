# rails generate controller cushions index show
require "cgi"

class CushionsController < ApplicationController
  def index
    sample_url = 'https://duckduckgo.com/?params=<br>#hash'
    @urlescaped_url = CGI.escape(sample_url)
    @htmlescaped_url = CGI.escapeHTML(sample_url)
  end

  def cushion
    @urlescaped_url = params[:url]
    @url = CGI.unescape(@urlescaped_url)
    @htmlescaped_url = CGI.escapeHTML(@url)
  end
end
