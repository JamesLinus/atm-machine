require 'logger'

class CardLogger
  def self.log(card_number)
    if @card_logger.nil?
      file = File.new("card - #{card_number}.log", 'a')
      @card_logger = Logger.new file
      @card_logger.level = Logger::INFO
      @card_logger.datetime_format = '%Y-%m-%d %H:%M:%S '
    end
    @card_logger
  end
end
