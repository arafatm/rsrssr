require 'colorize'

def watch_tests
  watch( 'test/(.*)/(.*).rb' ) do |md| 
    system("echo '\n\n---------------------------------------- #{md[0]}'")
    #system("bundle exec ruby #{md[0]}")
    run_test md[0]
  end
end

def watch_app
  watch( 'app/(.*)/(.*).rb' ) do |md| 
    system("echo '\n\n---------------------------------------- #{md[0]}'")
    run_test md[0].sub('app', 'test')
  end
end

def run_test(file)
  unless File.exist?(file)
    puts "Test File #{file} not created".colorize(:light_red).red
    return
  end
  output = `bundle exec ruby #{file}`
  result = output.split("\n").grep(/\d+ tests, .*/)
  details = result.to_s.scan(/\d+/)
  fails = details.slice(2..3).any? { |f| f.to_i > 0 }
  if(fails)
    puts output.colorize(:light_red)
  else
    puts result.to_s.colorize(:light_green)
    run_all
  end
end

def run_all
  system("bundle exec rake")
end

# Ctrl-\
Signal.trap('QUIT') do
  puts "\n\n---------------------------------------- Reloading watched files ---\n"
  watch_tests
  watch_app
end

# Ctrl-Z
Signal.trap('TSTP') do
  puts "\n\n---------------------------------------- Running all tests ---\n"
  run_all
end

# Ctrl-C
#Signal.trap('INT') do 
#  abort("\n\n---------------------------------------- Exiting ---\n") 
#end

run_all
watch_tests
watch_app

