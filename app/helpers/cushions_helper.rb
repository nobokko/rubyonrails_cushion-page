# rails generate helper cushions
require 'cgi'

#
# CushionsHelper
#
module CushionsHelper
  #
  # URLをエスケープする
  #
  # @param [string] raw_url url
  #
  # @return [string] escaped url
  #
  def cushions_escape(raw_url)
    CGI.escape(raw_url)
  end

  #
  # クッションURLを作成する
  #
  # @param [string] raw_url url
  #
  # @return [string] クッションURL
  #
  def cushions_url(raw_url)
    urlescaped_url = cushions_escape(raw_url)
    "/cushions/#{urlescaped_url}"
  end

  #
  # クッションURLを埋めたリンクタグを作成する（base : link_to）
  #
  # @param [string] raw_url url
  # @param [hash] html_options link_toに送るhash
  #
  # @return [string] クッションURLを埋めたリンクタグ
  #
  def cushions_link_to(raw_url, html_options = {})
    link_to raw_url, cushions_url(raw_url), { target: '_blank' }.merge(html_options || {})
  end
end
