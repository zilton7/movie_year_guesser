require 'selenium-webdriver'
require 'pry'

quiz_name = 'GEO'
quiz_difficulty = 'Medium'

# Define the path to your local HTML file
html_intro_file_path = "file://#{File.absolute_path('quiz.html')}quiz_name=#{quiz_name}&quiz_difficulty=#{quiz_difficulty}"
html_file_path = "file://#{File.absolute_path('quiz.html')}"

# Set up Selenium to use Chrome
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run in headless mode (no GUI)
options.add_argument('--window-size=540,960') # Set window resolution
options.add_argument('--force-device-scale-factor=2.0')

unless Dir.exist?(File.absolute_path("lib/rendered/#{quiz_name}/"))
  Dir.mkdir(File.absolute_path("lib/rendered/#{quiz_name}/"))
end

dir_name = Dir.entries(File.absolute_path("lib/rendered/#{quiz_name}/"))
              .select { |entry|
  File.directory?(File.join(File.absolute_path("lib/rendered/#{quiz_name}/"),
                            entry)) && !['.', '..'].include?(entry)
}
                          .count + 1
Dir.mkdir(File.absolute_path("lib/rendered/#{quiz_name}/#{dir_name}"))

# Initialize the browser driver (in this case, Chrome)
driver = Selenium::WebDriver.for :chrome, options: options

driver.navigate.to html_intro_file_path

index = 0
10.times do
  # Open the local HTML file in the browser
  driver.navigate.to html_file_path
  # Take a screenshot and save it as 'screenshot.png'
  # sleep(2)

  driver.save_screenshot(File.absolute_path("lib/rendered/#{quiz_name}/#{dir_name}/#{index}_a.png"))

  puts "Screenshot saved as #{index}_a.png"

  correct = driver.find_element(:id, 'correct').attribute('data-correct')
  # binding.pry
  driver.find_element(:xpath, ".//*[contains(text(), '#{correct}')]").click

  driver.save_screenshot(File.absolute_path("lib/rendered/#{quiz_name}/#{dir_name}/#{index}_b.png"))

  puts "Screenshot saved as #{index}_b.png"
  index += 1
end
# Close the browser
driver.quit
