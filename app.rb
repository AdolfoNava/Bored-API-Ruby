require "sinatra"
require "sinatra/reloader"
require 'http'
class Activity

  def initialize(name, link, type, id, price, accessibility, participants)
    @name = name
    @link = link
    @type = type
    @id = id
    @price = price
    @accessibility = accessibility
    @participants = participants
  end
  def display
    return "#{@name}, #{@link}, #{@type}, #{@id}, #{@price}, #{@accessibility}, #{@participants}"
  end

end

get("/") do
  erb(:main)
end
post('/submitResults') do
  #url =
  @activities = []
  mainURL = "http://www.boredapi.com/api/activity?";
  @type_selected = params['type']
  @price_selected = params['price'].to_f
  @accessibility_selected = params['accessibility'].to_f
  @participants_selected = params['participants'].to_i
  if @accessibility_selected > 0.0
    mainURL += "maxaccessibility=#{@accessibility_selected}&"
  end 
  if @price_selected > 0.0
    mainURL += "maxprice=#{@price_selected}&"
  end
  if @participants_selected > 0
    mainURL+="participants=#{@participants_selected}&"
  end
  if @type_selected != 'no preference' 
    mainURL+="type=#{@type_selected}"
  end
  #httpget =  
  @data = JSON.parse((HTTP.get(mainURL).to_s)) 
  if(@data['error'] != 'No activity found with the specified parameters')
    @activity = Activity.new(@data['activity'], @data['link'], @data["type"], @data['key'], @data['price'], @data['accessibility'], @data["participants"])
    @activities.push(@activity);
  end
  @results = @activities[0].display
  erb(:calledResults)
end
