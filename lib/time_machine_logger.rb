require 'yaml'

class TimeMachineLogger

  attr_reader :logger

  def initialize
    @logger = Logger.new(YAML.load_file('config.yml')['file_path'])
    logger.level = YAML.load_file('config.yml')['level']
  end

end
