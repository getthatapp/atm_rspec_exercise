class AtmMachine
	attr_reader :balance, :transaction_limit, :authorized_user

	class AccountEmptyError < StandardError; end
	class NoSufficientFoundsError < StandardError; end
	class InaccessiblePinError < StandardError; end
	class WrongPinError < StandardError; end

	def initialize(balance = 0)
		@balance = balance
		@transaction_limit = 500
		@pin = 1234
		@authorized_user = false
	end

	def withdraw(amount, pin = nil)
		authorize(pin)
		raise AccountEmptyError if @balance <= 0
		raise NoSufficientFoundsError if @balance < amount
		@balance -= amount
	end

	def deposit(amount, pin = nil)
		authorize(pin)
		@balance += amount
	end

	def pin
		raise InaccessiblePinError
	end

	private
	def authorize(given_pin)
		@authorized_user = given_pin == @pin
		raise WrongPinError unless authorized_user
	end
end
