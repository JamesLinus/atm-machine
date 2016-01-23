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

    inserted_card = Card.new(Account.new(1000))

    puts inserted_card.disabled?

    pin = get_pin

    if inserted_card.pin_correct?(pin) && !inserted_card.disabled?
      loop do
        display_menu

        selected_option = gets.chomp

        break if AVAILABLE_OPTIONS.include? selected_option
      
        puts 'Please enter 1, 2, 3 or 0'
      end
    elsif inserted_card.disabled?
      puts 'This card has been disabled. Please contact your bank to enable it.'
    else
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
    puts '1. Display Current balance'
    puts '2. Withdraw money'
    puts '3. Deposit money'
    puts '0. Exit'
  end
end

class Card
  attr_reader :account, :pin, :disabled

  def initialize(account)
    @pin = '1234'
    @account = account
    @disabled = false
  end

  def check_balance
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
end

class Account
  attr_reader :balance

  def initialize(balance)
    @balance = balance
  end

  def add_funds(amount)
    balance += amount
  end
end

CashMachine.new.start
