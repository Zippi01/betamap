class PlacesJob < ApplicationJob
  require 'open-uri'
  require 'nokogiri'
  require 'net/http'
  require 'uri'
  queue_as :default

  def perform(place_params, email)
    puts(place_params["name"])
    place = place_params["name"].split("; ")
    name = ""
    formatted_address = ""
    rating = ""
    user_ratings_total = ""

    place.each do |elem|
      page = Nokogiri::Slop(open("https://maps.googleapis.com/maps/api/place/details/xml?place_id=#{elem}&fields=name,rating,user_ratings_total,formatted_address&key=AIzaSyBZTzMEdD2iN5NkYojIHUeJtNi6_NIWla4"),  nil, Encoding::UTF_8.to_s)
      # puts page
      name += page.xpath("//name").text + "; "
      formatted_address += page.xpath("//formatted_address").text + "; "
      if (page.xpath("//rating").text != "")
        rating += page.xpath("//rating").text + "; "
        user_ratings_total += page.xpath("//user_ratings_total").text + "; "
      else
        rating += "0; "
        user_ratings_total += "0; "
      end
    end
    @@m = 50
    rate = rating.split("; ")
    rate = rate.map(&:to_f)
    comments_count = user_ratings_total.split("; ")
    comments_count = comments_count.map(&:to_f)
    place_name = name.split("; ")
    place_address = formatted_address.split("; ")
    @avarage_score = 0
    rate.each do |elem|
      @avarage_score += elem
    end
    @avarage_score /= rate.size
    my_hash = []
    rate.each_with_index do |elem, i|
      if(elem != 0)
        @rating = (comments_count[i] / comments_count[i] + @@m) * elem + (@@m / comments_count[i] + @@m) * @avarage_score
        my_hash << {rating: "#{@rating}", comment_count: "#{comments_count[i]}", rate: "#{elem}", name: "#{place_name[i]}", address: "#{place_address[i]}"}
      else
        @rating = 0
        my_hash << {rating: "#{@rating}", comment_count: "#{comments_count[i]}", rate: "#{elem}", name: "#{place_name[i]}", address: "#{place_address[i]}"}
      end
    end
    places_json = my_hash.to_json
    places_json = JSON[places_json].sort_by{ |e| e['rating'].to_i }
    places_json = places_json.reverse
    puts(places_json)
    PlaceMailer.welcome_email(places_json, email).deliver
  end
end
