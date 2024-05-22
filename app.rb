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
  def name
    # Return the value of this variable
    @name
  end
  def id
    @id
  end

  def accessibility
    @accessibility
  end
  def type
    @type
  end
  def link

    if @link != ''
      return @link
    end
    return false
  end
  def price
    @price
  end
  def participants
    @participants
  end
end

def should_display_toast?(val)
  if(val)
    return true
  else
    return false
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
  count = 0
  @broke = false
  while count < 3
    @data = JSON.parse((HTTP.get(mainURL).to_s)) 
    if(@data['error'] != 'No activity found with the specified parameters' && !@activities.any? { |element| element.id == @data['key'] })
      @activity = Activity.new(@data['activity'], @data['link'], @data["type"], @data['key'], @data['price'], @data['accessibility'], @data["participants"])
      @activities.push(@activity)
      count += 1
    #cookie
    else
      if !@activities.any? { |element| element.id == @data['key']}
        @message = 'Error occured because there was a duplicate detected'
      else
        @message = 'Could not find enough unique activities to do with your chosen information'
      end
      
      @broke = true
      break
    end
  end
  @results = @activities[0].display
  erb(:calledResults)
end
