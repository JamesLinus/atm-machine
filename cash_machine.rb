require 'logger'

class CashMachine
  AVAILABLE_OPTIONS = ['0', '1', '2', '3']

  attr_reader :available_cash

  def initialize
    @available_cash = 10000
  end

  def start
    loop do
      puts 'Please insert card'
      puts
      puts "(press 'i' to insert card)"

      button_pressed = gets.chomp
      break if button_pressed.downcase == 'i'
    end

    inserted_card = Card.new('1234')
    card_number = inserted_card.number[12..-1]
    
    pin = get_pin

    if inserted_card.pin_correct?(pin) && !inserted_card.disabled?
      ATMLogger.log.info "Inserted card number ending in #{card_number}"
      handle_correct_card_and_pin(inserted_card)
    elsif inserted_card.disabled?
      ATMLogger.log.info "Inserted disabled card ending in #{card_number}"
      puts 'This card has been disabled. Please contact your bank to enable it.'
    else
      ATMLogger.log.info "PIN for card ending in #{card_number} was incorrect. Card was disabled."
      puts 'The PIN number you entered is incorrect. The card has been disabled.'
      inserted_card.disable
    end
  end

  private

  def get_pin
    puts 'Please enter your PIN and press ENTER.'
    gets.chomp
  end

  def display_menu
    puts 'Please select the operation:'
    puts
    puts '1. Display current balance'
    puts '2. Withdraw money'
    puts '3. Deposit money'
    puts '0. Exit'
  end

  def handle_correct_card_and_pin(inserted_card)
    selected_option = ''
    card_number = inserted_card.number[12..-1]

    loop do
      display_menu

      selected_option = gets.chomp

      break if AVAILABLE_OPTIONS.include? selected_option
    
      puts 'Please enter 1, 2, 3 or 0'
      puts
    end

    case selected_option
    when '1'
      ATMLogger.log.info "Successfully checked balance for card ending in #{card_number}."
      puts "\nYour Balance: #{inserted_card.get_balance}\n"
      another_operation?(inserted_card)
    when '2'
      puts 'How much money would you like to withdraw?'

      amount = gets.chomp.to_i

      if amount > inserted_card.get_balance
        ATMLogger.log.info "Attempted to retrieve more money than available on card #{card_number}."
        puts "Sorry. You don't have enough money on your account to withdraw #{amount} PLN"
        another_operation?(inserted_card)
      elsif amount > available_cash
        ATMLogger.log.info "Attempted to retrieve more money than available in cash machine #{card_number}."
        puts 'Sorry. There is currently not enough cash available in this ATM Machine to withdraw such amount.'
        another_operation?(inserted_card)
      else
        ATMLogger.log.info "Successfully withdrawn money for card #{card_number}."        
        puts "Withdrawing #{amount} PLN"
        inserted_card.withdraw(amount)
        another_operation?(inserted_card)
      end
    when '3'
      puts 'How much money would you like to deposit?'

      amount = gets.chomp.to_i

      ATMLogger.log.info "Successfully deposited money for card ending in #{card_number}."
      puts "Depositing #{amount} PLN"
      inserted_card.deposit(amount)

      another_operation?(inserted_card)
    when '0'
      ATMLogger.log.info "Exit successful."
      puts 'Exiting'
    end
  end

  def another_operation?(inserted_card)
    puts 'Would you like to perform another operation? (y/n)'

    button_pressed = gets.chomp

    if button_pressed.downcase == 'y'
      handle_correct_card_and_pin(inserted_card)
    else
      puts 'Have a nice day!'
    end
  end
end

class Card
  attr_reader :account, :pin, :number, :disabled

  def initialize(pin)
    @pin = pin
    @number = '1234567890098765'
    @disabled = false
  end

  def get_balance
    account.balance
  end

  def pin_correct?(entered_pin)
    pin == entered_pin
  end

  def disabled?
    disabled
  end

  def disable
    disabled = true
  end

  def withdraw(amount)
    account.withdraw(amount)
  end

  def deposit(amount)
    account.add_funds(amount)
  end

  def account
    @account ||= Account.new(1000)
  end
end

class Account
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  def add_funds(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end

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

CashMachine.new.start
