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
