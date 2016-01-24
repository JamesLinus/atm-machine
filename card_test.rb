require 'minitest/autorun'
require_relative 'card'

class CardTest < MiniTest::Unit::TestCase
  describe Card do
    before do
      @card = Card.new('1234')
    end

    it 'creates a card with a given pin' do
      @card.pin.must_equal '1234'
    end

    describe '#get_balance' do
      it 'returns balance from of account tied with card' do
        @card.get_balance.must_equal 1000
      end
    end

    describe '#pin_correct?' do
      it 'returns true if PIN matches the one on card' do
        @card.pin_correct?('1234').must_equal true
      end

      it 'returns false if PIN does not match the one on card' do
        @card.pin_correct?('2345').must_equal false
      end
    end

    describe '#disabled?' do
      it 'shows if card is disabled' do
        @card.disabled?.must_equal false

        @card.disable

        @card.disabled?.must_equal true
      end
    end

    describe '#withdraw' do
      it 'withdraws given amount from attached account' do
        @card.withdraw(100)

        @card.get_balance.must_equal 900
      end
    end

    describe '#deposit' do
      it 'deposits given amount to attached account' do
        @card.deposit(100)

        @card.get_balance.must_equal 1100
      end
    end
  end
end