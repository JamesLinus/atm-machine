require 'logger'

class ATMLogger
  def self.log
    if @logger.nil?
      file = File.new('machine.log', 'a')
      @logger = Logger.new file
      @logger.level = Logger::INFO
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @logger
  end
end
