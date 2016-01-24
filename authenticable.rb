module Authenticable
  def authenticated_by_pin(card)
    pin = get_pin

    card.pin_correct?(pin)
  end

  def get_pin
    puts 'Please enter your PIN and press ENTER.'
    gets.chomp
  end
end
