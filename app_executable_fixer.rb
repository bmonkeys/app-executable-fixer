#!/usr/bin/ruby
# By Sven Pachnit (a BMonkey)
# www.bmonkeys.net
# Code License: http://opensource.org/licenses/MIT
# Icon License: http://www.iconfinder.com/icondetails/24775/128/application_executable_script_x_icon

# flush stdout after each output
STDOUT.sync = true

def pexit message, delay = 5
  puts message
  sleep delay
  exit 0
end

# our file
file = ARGV * " "

# probably initial start
exit 0 if !file || file.empty?

# check if file is an OS X application
if !(file.end_with?(".app") || file.end_with?(".app/"))
  pexit "Please drop an OS X application here"
end

# search executable
puts "Checking application"
choices = Dir.glob("#{file}/Contents/MacOS/*").select { |f| File.file?(f) }
exechoices = choices.select { |f| File.executable?(f) }

if choices.count != 1 && (exechoices.empty? || exechoices.count > 1)
  pexit "Can't determine executable!"
end

if exechoices.count == 1
  pexit "Application seems intact, nothing to do"
end

if exechoices.count == 0 && choices.count == 1
  # fix the file
  begin
    if File.chmod(0777, choices.first) == 1
      pexit "Application fixed! Have fun!"
    else
      raise StandardError, "File wasn't changed!"
    end
  rescue StandardError => e
    puts "Can't change file permissions!"
    sleep 3
    pexit e.message
  end
end

pexit "unhandled case (blame the developer)"
