def watch_tests
  watch( 'test/(.*)\.rb' ) do |md| 
    system("echo '======================================== #{md[0]}'")
    puts %x[bundle exec ruby #{md[0]} --notify]
  end
end

def watch_app
  watch( 'app/(.*)/(.*).rb' ) do |md| 
    system("echo '======================================== #{md[0]}'")
    system("bundle exec ruby #{md[0].sub('app', 'test')} --notify") 
  end
end

def run_all
  system("bundle exec rake")
end

# Ctrl-\
Signal.trap('QUIT') do
  puts "\n--- Running all tests ---\n"
  run_all
  puts
end

# Ctrl-Z
Signal.trap('TSTP') do
  puts "\n--- Reloading watched files ---\n"
  watch_tests
  watch_app
end

# Ctrl-C
Signal.trap('INT') do 
  abort("\n--- Exiting ---\n") 
end

run_all
watch_tests
watch_app

