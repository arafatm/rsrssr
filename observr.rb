Dir.glob('test/*/*.rb') do |f|
  system("bundle exec ruby #{f}")
end

watch( 'test/(.*)\.rb' ) { |md| system("bundle exec ruby #{md[0]} --notify") }
watch( 'app/(.*)/(.*).rb' ) do |md| 
  system("bundle exec ruby #{md[0].sub('app', 'test')} --notify") 
  #system("echo 'testing #{md[0].sub('app', 'test')}'")
end
