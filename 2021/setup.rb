require 'fileutils'

if ARGV.length > 0
  foldername = ARGV[0].downcase.gsub(/[^a-z0-9]/, '')
  unless File.exist?(foldername)
    FileUtils.mkdir_p foldername
    `cp main.rb #{foldername}`
    `cd #{foldername} && ruby main.rb setup`
  end
end
