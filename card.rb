require_relative 'account'
require_relative 'card_logger'

class Card
  attr_reader :pin, :number
  attr_accessor :disabled

  def initialize(pin)
    @pin = pin
    @number = '1234567890098765'
    @disabled = false
  end

  def get_balance
    CardLogger.log(number).info 'Successfully checked balance.'
    account.balance
  end

  def pin_correct?(entered_pin)
    pin == entered_pin
  end

  def disabled?
    disabled
  end

  def disable
    CardLogger.log(number).info 'Card has been disabled.'
    self.disabled = true
  end

  def withdraw(amount)
    CardLogger.log(number).info "Successfully withdrawn #{amount} PLN."
    account.withdraw(amount)
  end

  def deposit(amount)
    CardLogger.log(number).info "Successfully deposited #{amount} PLN."
    account.add_funds(amount)
  end

  def safe_number
    number[12..-1]
  end

  private

  def account
    @account ||= Account.new(1000)
  end
end
