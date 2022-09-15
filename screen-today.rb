require 'uri'
require 'open-uri'
require 'json'
require 'cgi'

data = JSON.parse(URI.open("https://good-morning-backend.herokuapp.com/today").read)
date = DateTime.now.strftime("%d. %m. %Y")
url = URI.parse("https://simi.github.io/good-morning-prototype")

text = "Dnes je #{data.fetch('national')}.\n\nMěsíc #{data.fetch('moon')}."
if data['home_alone'] && !data['home_alone'].empty?
  if data['home_alone'].include?(' — ')
    topics = data['home_alone'].split(' — ')
    text += "\n\nDnešní témata Dobrého rána:\n"
    topics.each do |topic|
      text += "► #{topic}\n"
    end
  else
    text += "\n\nDnešní témata Sama doma: #{data['home_alone']}"
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

screen_cmd = "google-chrome --virtual-time-budget=10000 --hide-scrollbars --headless --screenshot=page.png --window-size=1200,675 '#{url.to_s}'"
exec screen_cmd
