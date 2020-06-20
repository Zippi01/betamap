class ParserCreate < ApplicationService
  require 'open-uri'
  require 'nokogiri'

  attr_reader :page

  def initialize(page, source)
    @page = page
    @source = source["url"]
  end

  def call
    @page.css('div.add-cnt-div').each do |link|
      @product_id = link['id'].split('_').last.to_i
    end

    puts "Product id:", @product_id
    @parse_url = Nokogiri::HTML(open("https://ek.ua/mtools/dot_output/mui_review.php?idg_=#{@product_id}&p_start_=1&p_end_=11000&callback=jQuery2240861719138234045_1582799940686&_=1582799940688"),  nil, Encoding::UTF_8.to_s)
    @parse_url.css("div.\'review-comment'\ span").each do |link|
      puts link.content
      # word = link.content.split(" ")
      # word.each do |element|
      #   puts element.gsub(/[!@%&",?.]/,'').downcase
      # end
      # @parser_site = ParserSite.new(:comment => link.content.to_s, :url => source["url"])
      # @parser_site.save
    end

    # get_id_product_from_url
    # puts @source
    # @pages.times do |i|
    #   @parse_url = "https://product-api.rozetka.com.ua/v2/comments/get?front-type=xl&goods=#{@source}&page=#{i}&sort=date&limit=10&lang=ru"
    #   puts @parse_url
    # end
    # @parse_url = "https://product-api.rozetka.com.ua/v2/comments/get?front-type=xl&goods=#{@source}&page=#{1}&sort=date&limit=10&lang=en"
    # @parse_url = Nokogiri::HTML.parse(open(@parse_url))
    # @parse_url.css('pre').each do |link|
    #   puts link.content
    # end
    # @test_url = @parse_url #.scan(/\"comments\":\[{\"\w+\":\w+,\"\w+\":\"[а-яА-яa-zA-Z ]+\",\"\w+\":\w+,\"\w+\":\"\w+\",\"\w+\":\"[а-яА-яa-zA-Z ,?.ёЁ]+\"/)
    # puts @test_url
  end
end
