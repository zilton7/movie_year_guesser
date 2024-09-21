require 'net/http'
require 'json'
require 'uri'
require 'pry'
require 'dotenv/load'

# API constants
AUTHORIZATION_TOKEN = ENV['TMDB_TOKEN']
IMAGE_BASE_URL = 'https://image.tmdb.org/t/p/w200'

# Method to download the image
def download_image(image_url, file_name)
  uri = URI(image_url)
  response = Net::HTTP.get_response(uri)

  # Create directories if they don't exist
  dir_name = File.dirname(file_name)
  FileUtils.mkdir_p(dir_name) unless File.directory?(dir_name)

  if response.is_a?(Net::HTTPSuccess)
    File.open(file_name, 'wb') do |file|
      file.write(response.body)
      puts "Image downloaded and saved as #{file_name}"
    end
  else
    puts "Failed to download image: #{response.message}"
  end
end

# Method to make the API request and process the image
def fetch_and_download_image(year)
  api_uri = "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&primary_release_year=#{year}&sort_by=popularity.desc&with_original_language=en"
  uri = URI(api_uri.to_s)
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = "Bearer #{AUTHORIZATION_TOKEN}"
  req['accept'] = 'application/json'

  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }

  if res.is_a?(Net::HTTPSuccess)
    data = JSON.parse(res.body)
    # Extracting the poster_path (assumes it's in 'results')
    if data['results'] && !data['results'].empty?
      data['results'].each.with_index do |result, index|
        poster_path = result['poster_path']
        if poster_path.nil?
          puts 'Poster path not available'
        else
          full_image_url = "#{IMAGE_BASE_URL}#{poster_path}"
          puts "Full image URL: #{full_image_url}"

          # Download the image
          # binding.irb
          file_path = Pathname.new(__dir__).join('..').join("assets/images/#{year}/#{index}.jpg")
          download_image(full_image_url, file_path)
        end
      end
    else
      puts 'No movie results found'
    end
  else
    puts "Failed to fetch data from API: #{res.message}"
  end
end

year = 1992
loop do
  fetch_and_download_image(year)
  year += 1
end
