require_relative "lib/player"

start = Time.now
player = Player.new(100000)
player.run_test
timing = Time.now - start  
puts "Time took #{timing}"