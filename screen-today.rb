require 'uri'
require 'open-uri'
require 'json'
require 'cgi'
require 'timeout'

backend_url = ENV.fetch('DR_BACKEND_URL')

data = JSON.parse(URI.open(backend_url).read)
date = DateTime.now.strftime("%d. %m. %Y")
url = URI.parse("https://rubyelders.github.io/good-morning-prototype")
delimiter = / — | - /

text = "Dnes je #{data.fetch('national')}.\n\nMěsíc #{data.fetch('moon')}."
if data['content'] && !data['content'].empty?
  if data['content'].match?(delimiter)
    topics = data['content'].split(delimiter)
    header = data['header']
    text += "\n\n#{header}\n"
    topics.each do |topic|
      text += "► #{topic}\n"
    end
  else
    text += "\n\n#{header} #{data['content']}"
  end
end

params = {
  temp: "%s / %s °C" % data.values_at("temp_min", "temp_max"),
  bio: "BIO #{data.fetch("bio")}",
  name: data.fetch("name"),
  date: date,
  text: text
}

params = URI.encode_www_form(params)
url.query = params

print url.to_s

screen_cmd = "google-chrome --virtual-time-budget=10000 --hide-scrollbars --headless=new --screenshot=page.png --window-size=1200,748 '#{url.to_s}' --user-data-dir=/tmp/chrome"

Timeout::timeout(120) do
  exec screen_cmd
end
