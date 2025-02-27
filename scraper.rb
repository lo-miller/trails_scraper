require "httparty" 
require "nokogiri"
require 'csv'

# downloading the target web page 
# response = HTTParty.get("https://www.scrapingcourse.com/ecommerce/")
# response = HTTParty.get("https://www.alltrails.com/us/oregon")
# response = HTTParty.get("https://www.alltrails.com/explore?mobileMap=true&b_br_lat=42.409100246994285&b_br_lng=-116.9855834652293&b_tl_lat=45.9410508860702&b_tl_lng=-124.74697653477108")

# response = HTTParty.get("https://www.alltrails.com/explore?mobileMap=true&b_br_lat=42.409100246994285&b_br_lng=-116.9855834652293&b_tl_lat=45.9410508860702&b_tl_lng=-124.74697653477108", { 
# 	headers: { 
# 		"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
# 	}, 
# })
response = HTTParty.get("https://www.alltrails.com/us/oregon", { 
	headers: { 
		"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36" 
	}, 
})


# parsing the HTML document returned by the server 
document = Nokogiri::HTML(response.body)
p document

# defining a data structure to store the scraped data 
Product = Struct.new(:url, :image, :name, :price)

# selecting all HTML product elements 
html_products = document.css("li.product")

# initializing the list of objects 
# that will contain the scraped data 
products = [] 
 
# iterating over the list of HTML products 
html_products.each do |html_product| 
	# extracting the data of interest 
	# from the current product HTML element 
	url = html_product.css("a").first.attribute("href").value 
	image = html_product.css("img").first.attribute("src").value 
	name = html_product.css("h2").first.text 
	price = html_product.css("span").first.text 
 
	# storing the scraped data in a Product object 
	product = Product.new(url, image, name, price) 
 
	# adding the Product to the list of scraped objects 
	products.push(product) 
end

# defining the header row of the CSV file 
csv_headers = ["url", "image", "name", "price"] 
CSV.open("output.csv", "wb", write_headers: true, headers: csv_headers) do |csv| 
	# adding each product as a new row 
	# to the output CSV file 
	products.each do |product| 
		csv << product 
	end 
end


# print response
# print document