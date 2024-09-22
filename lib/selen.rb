require 'selenium-webdriver'
require 'pry'

# Define the path to your local HTML file
html_file_path = "file://#{File.absolute_path('index_for_printshots.html')}"

# Set up Selenium to use Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no GUI)
options.add_argument('--window-size=540,960') # Set window resolution
options.add_argument('--force-device-scale-factor=2.0')

# Initialize the browser driver (in this case, Chrome)

dir_name = Dir.entries(File.absolute_path('lib/rendered/'))
              .select { |entry|
  File.directory?(File.join(File.absolute_path('lib/rendered/'),
                            entry)) && !['.', '..'].include?(entry)
}
              .count + 1
Dir.mkdir(File.absolute_path("lib/rendered/#{dir_name}"))

driver = Selenium::WebDriver.for :chrome, options: options

index = 0
10.times do
  # Open the local HTML file in the browser
  driver.navigate.to html_file_path
  # Take a screenshot and save it as 'screenshot.png'
  # binding.pry
  # sleep(2)

  driver.save_screenshot(File.absolute_path("lib/rendered/#{dir_name}/#{index}_a.png"))

  puts "Screenshot saved as #{index}_a.png"

  html_result_file_path = "file://#{File.absolute_path('result_for_printshots.html')}"
  answer = driver.find_element(css: '#img1 img').attribute('src').split('/images/')[1].split('/')[0]

  driver.navigate.to "#{html_result_file_path}?answer=" + answer
  # Take a screenshot and save it as 'screenshot.png'
  driver.save_screenshot(File.absolute_path("lib/rendered/#{dir_name}/#{index}_b.png"))

  puts "Screenshot saved as #{index}_b.png"
  index += 1
end
# Close the browser
driver.quit
