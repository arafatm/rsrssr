require 'colorize'

# Run all tests on commit
def watch_commits
  watch( '.git/COMMIT_EDITMSG' ) do |md| 
    run_all
  end
end

def watch_tests
  watch( 'test/(.*)/(.*).rb' ) do |md| 
    puts "\n\n--------------- #{md[0]}".colorize(:cyan)
    run_test md[0]
  end
end

def watch_app
  watch( 'app/(.*)/(.*).rb' ) do |md| 
    puts "\n\n--------------- #{md[0]}".colorize(:cyan)
    run_test md[0].sub('app', 'test')
  end
end

def puts_screen(status, details, color)
  screen = %Q{screen -X hardstatus alwayslastline }
  time = Time.now.strftime("%I:%M")
  status ||= "Running ..."
  status = status[0..52]

  if color == :light_red
    color = '%{= rw}'
  elsif color == :light_yellow
    color = '%{= yw}'
  elsif color == :light_green
    color = '%{= gk}'
  else
    color = '%{= wk}'
  end

  msg = ''
  if details != nil
    msg = msg + "%{= dG} #{details[0]}"
    msg = msg + "/%{= dG}#{details[1]}"
    msg = msg + "/%{= dR}#{details[2]}"
    msg = msg + "/%{= dR}#{details[3]}"
    msg = msg + "/%{= dy}#{details[4]}"
    msg = msg + "/%{= dy}#{details[5]}"
    msg = msg + "/%{= dy}#{details[6]}"
  end

  system %Q{#{screen}'#{color}#{time} #{status}%=#{msg} '}
end

def puts_results(output, color, details, filename)
  result = output.split("\n")

  puts_screen(filename, details, nil)

  screened = false
  result.each do |line|
    if line =~ /^.* => .*/
      puts line.colorize(color)
      puts_screen(line, details, color)
      screened = true
    elsif line =~ /^\d+ tests, .*/
      puts line.colorize(color)
    else
      puts line
    end
    puts_screen(filename, details, color) unless screened
  end
end

def parse_tests(filename, output)
  result = output.split("\n").grep(/\d+ tests, .*/)
  details = result.to_s.scan(/\d+/)
  fails = details.slice(2..3).any? { |f| f.to_i > 0 }
  pendings = details.slice(4..6).any? { |f| f.to_i > 0 }

  if(fails)
    puts_results(output, :light_red, details, filename)
  elsif(pendings)
    puts_results(output, :light_yellow, details, filename)
  else
    puts_results(output, :light_green, details, filename)
    return true
  end
  return false
end

def run_test(file)
  unless File.exist?(file)
    puts "Test File #{file} not created".colorize(:light_red).red
    puts_screen("#{file} not created", nil, :light_red)
    system("screen -X hardstatus alwayslastline '%{b dR} #{file} not created%='")
    return
  end

  puts_screen file, nil, nil

  output = `bundle exec ruby #{file}`
  parse_tests(file, output)
end

def run_all
  puts_screen "Running ALL ...", nil, nil
  output = `bundle exec rake tests`
  if parse_tests("ALL", output)
    system("git push")
  end
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

#run_all
watch_tests
watch_app

