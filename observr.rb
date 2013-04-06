require 'colorize'

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

def puts_results(output, color)
  result = output.split("\n")

  result.each do |line|
    if line =~ /^.* => .*/
      puts line.colorize(color)
    elsif line =~ /^\d+ tests, .*/
      puts line.colorize(color)
    else
      puts line
    end
  end
end
def parse_tests(filename, output)
  result = output.split("\n").grep(/\d+ tests, .*/)
  details = result.to_s.scan(/\d+/)
  fails = details.slice(2..3).any? { |f| f.to_i > 0 }
  pendings = details.slice(4..6).any? { |f| f.to_i > 0 }

  screen = %Q{screen -X hardstatus alwayslastline }
  time = Time.now.strftime("%I:%M %p")
  msg = "#{details[0]} T" +
    " : #{details[1]} A" +
    " : #{details[2]} F" +
    " : #{details[3]} E" +
    " : #{details[4]} P" +
    " : #{details[5]} O" +
    " : #{details[6]} N"

  if(fails)
    puts_results(output, :light_red)
    system %Q{#{screen}'%{= rw}#{time} #{filename}%=#{msg} '}
  elsif(pendings)
    puts_results(output, :light_yellow)
    system %Q{#{screen}'%{= yw}#{time} #{filename}%=#{msg} '}
  else
    puts_results(output, :light_green)
    system %Q{#{screen}'%{= gk}#{time} #{filename}%=#{msg} '}
    return true
  end
  return false

end

def run_test(file)
  unless File.exist?(file)
    puts "Test File #{file} not created".colorize(:light_red).red
    system("screen -X hardstatus alwayslastline '%{b dR} #{file} not created%='")
    return
  end

  output = `bundle exec ruby #{file}`
  if parse_tests(file, output)
    run_all
  end
end

def run_all
  system("echo '\n\n---------------------------------------- Suite'")
  output = `bundle exec rake tests`
  parse_tests("ALL", output)
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

