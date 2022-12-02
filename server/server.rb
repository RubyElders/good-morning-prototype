require 'sinatra'
require_relative 'holidays'
require_relative 'national_days'
require_relative 'bio'
require_relative 'weather'
require_relative 'home_alone'
require_relative 'good_morning'

get '/' do
  "Dobré ráno!"
end

get '/today/home_alone' do
  content_type :json

  {}.merge(
    Holidays.new.today,
    NationalDays.new.today,
    {bio: Bio.new.today},
    Weather.new.today,
    {content: HomeAlone.new.today},
    {header: 'Dnešní témata Sama doma:'}
  ).to_json
end

get '/today/good_morning' do
  content_type :json

  {}.merge(
    Holidays.new.today.merge,
    NationalDays.new.today,
    {bio: Bio.new.today},
    Weather.new.today,
    {content: GoodMorning.new.today},
    {header: 'Dnešní témata Dobrého rána:'}
  ).to_json
end
