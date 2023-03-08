require 'sinatra'
require_relative 'holidays'
require_relative 'national_days'
require_relative 'bio'
require_relative 'weather'
require_relative 'show'

WEEKEND_SHOWS = {
  'Toulavá kamera' => 'Kam nás zavede Toulavá kamera?',
  /Československý filmový týdeník/ => 'Československý filmový týdeník nabízí:',
  /Toulky Českem/ => 'Dnešní témata pořadu Toulky Českem:',
  'Studio 6 víkend' => 'Co nás čeká ve Studiu 6 o víkendu:',
  'Krásné živé památky' => 'Kudy nás dnes provede Mirek Vladyka:'

}

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
    {content: Show.new.today('Sama doma')},
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
    {content: Show.new.today('Dobré ráno')},
    {header: 'Dnešní témata Dobrého rána:'}
  ).to_json
end

get '/today/weekend' do
  content_type :json

  begin
    show = WEEKEND_SHOWS.lazy.map do |show, header|
      { content: Show.new.today(show), header: header }
    end.filter { |hash| hash[:content] }.next
  rescue StopIteration
    show = { content: '', header: "Nic nedávaj :'(" }
  end

  {}.merge(
    Holidays.new.today.merge,
    NationalDays.new.today,
    {bio: Bio.new.today},
    Weather.new.today,
    {content: show[:content]},
    {header: show[:header]}
  ).to_json
end
