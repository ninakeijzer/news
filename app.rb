require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# Dark Sky & News API
ForecastIO.api_key = "c1e486d4c351be5069ab1f7f929d7239"
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=cba091e659a64ec393f048e20e96d814"
news = HTTParty.get(url).parsed_response.to_hash

get "/" do
  view "ask"
end

get "/news" do

    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates

    @forecast = ForecastIO.forecast(lat_long[0],lat_long[1]).to_hash
    @current_temperature = @forecast["currently"]["temperature"]
    @current_uvIndex = @forecast["currently"]["uvIndex"]
    @current_windSpeed = @forecast["currently"]["windSpeed"]
    @current_summary = @forecast["currently"]["summary"]

    @news = HTTParty.get(url).parsed_response.to_hash
    @newsarray = @news["articles"]
    @topheadlinearray = []
  @urlarray = []
  for articlenumber in @newsarray
    @topheadlinearray << articlenumber["title"]
    @urlarray << articlenumber["url"]
  end

    view "news"

end