class CashMachine
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

    pin = get_pin

    if inserted_card.pin_correct?(pin)
      display_menu
    else
      puts 'The PIN number you entered is incorrect.'
    end
  end

  private

  def get_pin
    puts 'Please enter your PIN and press ENTER'
    gets.chomp
  end

  def display_menu
    puts 'Please select the operation:'
    puts '1. Display Current balance'
    puts '2. Withdraw money'
    puts '3. Deposit money'
  end
end

class Card
  attr_reader :account, :pin

  def initialize(account)
    @pin = '1234'
    @account = account
  end

  def check_balance
    account.balance
  end

  def pin_correct?(entered_pin)
    pin == entered_pin
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
