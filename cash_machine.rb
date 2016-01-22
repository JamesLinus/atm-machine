class CashMachine
  attr_reader :available_cash

  def initialize
    @available_cash = 10000
  end

  def start
    pin = get_pin

    if pin.correct?
      display_menu
    else
      puts 'The PIN number you entered is incorrect.'
    end
  end

  private

  def get_pin
    puts 'Please enter your PIN'
  end

  def display_menu
    puts 'Please select the operation:'
    puts '1. Display Current balance'
    puts '2. Withdraw money'
    puts '3. Deposit money'
  end
end

def Card
  attr_reader :account

  def initialize(account)
    @pin = 1234
    @account = account
  end

  def check_balance
    account.get_balance
  end
end

def Account
  attr_accessor :balance

  def initialize(balance)
    @balance = balance
  end

  def get_balance
    balance
  end

  def add_funds(amount)
    balance += amount
  end
end
