require 'open-uri'
require 'nokogiri'

# TODO: remove, fixed in ruby 3.2
# https://github.com/ruby/ruby/commit/fa2e1b67e548cb5653b66909a2bc3d6b9eae98e3
Net::HTTPTemporaryRedirect = Net::HTTPPermanentRedirect

class Show
  TV = 'https://www.ceskatelevize.cz'
  TV_TODAY = TV + '/tv-program/'

  def today(show_title)
    find_topics(show_title) #rescue false # freestyle
  end

  private

  def find_topics(show_title)
    date = Date.today.strftime('%d.%m.%Y')
    tv_today = URI.open(TV_TODAY + date + '/').read
    tv_today_html = Nokogiri::HTML(tv_today)

    link = tv_today_html.css('a').find {|el| el.text.match?(show_title)}
    return false if link.nil?

    today = URI.open(TV + link.attributes['href'].value).read
    today_html = Nokogiri::HTML(today)
    description_el = today_html.css('div[class^=description] p').first
    return false if description_el.nil?

    description_el.text
  end
end