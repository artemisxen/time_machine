require 'yaml'

module TimeMachineLogger
  module_function
  def config
    YAML.load_file('config.yml')
  end

  def logger
    Logger.new(config["file_path"])
  end
end
