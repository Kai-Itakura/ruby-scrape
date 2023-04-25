require "csv"
require "mechanize"

agent = Mechanize.new
page = agent.get("https://www.buyma.com/r/_GUCCI-%E3%82%B0%E3%83%83%E3%83%81/")
elements = page.search(".product_name a")
urls = []

elements.each do |ele|
  urls << ele.get_attribute(:href)
end

data = []
urls.each do |url|
  page = agent.get(url)
  p "name: #{page.at("#item_h1 span").inner_text}"
  data << [
    page.at(".price_txt").inner_text,
    page.at(".free_txt").inner_text,
    page.at(".brand-link").inner_text,
  ]
  # sleep 1000
end

bom = %w[EF BB BF].map { |e| e.hex.chr }.join
csv_file = CSV.generate(bom) do |csv|
  data.each do |datum|
    csv << datum
  end
end

File.open("./scraped.csv", "w", force_quotes: true) do |file|
  file.write(csv_file.force_encoding("UTF-8"))
end
