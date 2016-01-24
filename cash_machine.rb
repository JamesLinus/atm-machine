require_relative 'authenticable'
require_relative 'card'
require_relative 'atm_logger'

class CashMachine
  include Authenticable

  AVAILABLE_OPTIONS = ['0', '1', '2', '3']
  MENU = %q{
    Please select the operation:

    1. Display current balance
    2. Withdraw money
    3. Deposit money
    0. Exit
  }

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
    
    handle_card(inserted_card)
  end

  private

  def handle_card(card)
    if authenticated_by_pin(card) && !card.disabled?
      ATMLogger.log.info "Inserted card number ending in #{card.safe_number}"
      handle_correct_card_and_pin(card)
    elsif card.disabled?
      ATMLogger.log.info "Inserted disabled card ending in #{card.safe_number}"
      puts 'This card has been disabled. Please contact your bank to enable it.'
    else
      ATMLogger.log.info "PIN for card ending in #{card.safe_number} was incorrect. Card was disabled."
      puts 'The PIN number you entered is incorrect. The card has been disabled.'
      card.disable
    end
  end

  def display_menu
    puts MENU
  end

  def handle_correct_card_and_pin(card)
    selected_option = get_user_input

    case selected_option
    when '1'
      check_balance(card)
    when '2'
      withdraw_money(card)
    when '3'
      deposit_money(card)
    when '0'
      ATMLogger.log.info "Exit successful."
      puts 'Exiting'
    end
  end

  def another_operation?(card)
    puts 'Would you like to perform another operation? (y/n)'

    button_pressed = gets.chomp

    if button_pressed.downcase == 'y'
      handle_correct_card_and_pin(card)
    else
      puts 'Have a nice day!'
    end
  end

  def get_user_input
    loop do
      display_menu

      selected_option = gets.chomp

      return selected_option if AVAILABLE_OPTIONS.include? selected_option
    
      puts "\nPlease enter 1, 2, 3 or 0\n"
    end
  end

  def check_balance(card)
    ATMLogger.log.info "Successfully checked balance for card ending in #{card.safe_number}."
    puts "\nYour Balance: #{card.get_balance}\n"
    another_operation?(card)
  end

  def withdraw_money(card)
    puts 'How much money would you like to withdraw?'

    amount = gets.chomp.to_i

    if amount > card.get_balance
      ATMLogger.log.info "Attempted to retrieve more money than available on card #{card.safe_number}."
      puts "Sorry. You don't have enough money on your account to withdraw #{amount} PLN"
      another_operation?(card)
    elsif amount > available_cash
      ATMLogger.log.info "Attempted to retrieve more money than available in cash machine #{card.safe_number}."
      puts 'Sorry. There is currently not enough cash available in this ATM Machine to withdraw such amount.'
      another_operation?(card)
    else
      ATMLogger.log.info "Successfully withdrawn money for card #{card.safe_number}."        
      puts "Withdrawing #{amount} PLN"
      card.withdraw(amount)
      another_operation?(card)
    end
  end

  def deposit_money(card)
    puts 'How much money would you like to deposit?'

    amount = gets.chomp.to_i

    ATMLogger.log.info "Successfully deposited money for card ending in #{card.safe_number}."
    puts "Depositing #{amount} PLN"
    card.deposit(amount)

    another_operation?(card)
  end
end

CashMachine.new.start
