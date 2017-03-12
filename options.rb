require "slop"

LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO


# Managed the command line arguments
opts = Slop.parse do |o|
  o.on '--test', 'run with default values' do
    @test = true
  end
  o.on '--debug', 'run in debug mode' do
    LOGGER.level = Logger::DEBUG
  end
  o.on '-v', '--version', 'print the version' do
    puts '1.0'
  end
  o.on '-n', '--name', 'enter actor name' do
    @actor = opts[:name]
  end

end

if @test
  puts "test mode"
else
  puts "test mode off"
end

LOGGER.debug("Debugging on") if LOGGER.level == Logger::DEBUG
