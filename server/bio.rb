require 'net/http'
require 'nokogiri'

class Bio

  PRAGUE = "https://www.meteocentrum.cz/kvalita-ovzdusi/praha"

  def today
    bio
  end

  private

  def html
    uri = URI.parse(PRAGUE)
    response = Net::HTTP.get_response(uri)
    response.body
  end

  def parsed_html
    Nokogiri::HTML(html)
  end

  def bio
    parsed_html.css('.air-quality')[0]["data-quality"]
  end
end
