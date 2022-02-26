# rails generate controller cushions index show
require "cgi"

class CushionsController < ApplicationController
  def index
    sample_url = 'https://duckduckgo.com/?params=<br>#hash'

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
