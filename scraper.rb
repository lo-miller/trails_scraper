require "httparty" 
require "nokogiri"
require 'csv'

# downloading the target web page 
response = HTTParty.get("https://www.scrapingcourse.com/ecommerce/")

# response = HTTParty.get("https://www.scrapingcourse.com/ecommerce/", { 
# 	headers: { 
# 		"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
# 	}, 
# })

# parsing the HTML document returned by the server 
document = Nokogiri::HTML(response.body)

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