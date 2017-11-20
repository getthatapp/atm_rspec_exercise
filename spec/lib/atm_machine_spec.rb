require_relative '../spec_helper'

RSpec.describe AtmMachine do |

	|describe 'basic class properties' do

		context "initialization" do
			let(:machine) { AtmMachine.new }

			it "initialize instance of a class" do
				expect(machine).to be_instance_of(AtmMachine)
			end

			it "has balance property" do
				expect{machine.balance}.not_to raise_error(NoMethodError)
			end

			it "has default balance set to 0" do
				expect(machine.balance).not_to eq nil
				expect(machine.balance).to eq 0
			end

			let(:machine_with_balance) { AtmMachine.new(1000) }
			it "allows to set starting balance on initialization" do
				expect(machine_with_balance.balance).to eq 1000
			end

			it "blocks when trying to set balance after initialization" do
				expect{(machine.balance = 2000)}.to raise_error(NoMethodError)
			end

			it "has transaction limit property" do
				expect{(machine.transaction_limit)}.not_to raise_error(NoMethodError)
			end

			it "has default transaction limit value" do
				expect(machine.transaction_limit).not_to eq nil
				expect(machine.transaction_limit).to eq 500
			end

			it "blocks when trying to set transaction_limit on initialization" do
				expect{(AtmMachine.new(1000, 2000))}.to raise_error(ArgumentError)
			end

			it "blocks when trying to set transaction_limit after initialization" do
				expect{(machine.trasnaction_limit(1000))}.to raise_error(NoMethodError)
			end

		end
	end

	describe "class methods" do
		
		context "withdraw method" do
			let(:machine) { AtmMachine.new(1000) }

			it "has withdraw method" do
				expect{(machine.withdraw(100, 1234))}.not_to raise_error(NoMethodError)
			end

			it "reduces account balance by the given amount" do
				expect(machine.balance).to eq 1000
				machine.withdraw(100, 1234)
				expect(machine.balance).to eq 900
			end

			let(:empty_machine) { AtmMachine.new(0) }
			it "blocks withdraw when account is empty" do
				expect(empty_machine.balance).to eq 0
				expect{(empty_machine.withdraw(100, 1234))}.to raise_error(AtmMachine::AccountEmptyError)
			end

			let(:almost_empty_machine) { AtmMachine.new(50) }
			it "blocks withdraw when withdrawn amount is greater than account balance" do
				expect(almost_empty_machine.balance).to eq 50
				expect{(almost_empty_machine.withdraw(100, 1234))}.to raise_error(AtmMachine::NoSufficientFoundsError)
			end

		end

		context "deposit method" do
			let(:machine) { AtmMachine.new(1000) }

			it "has deposit method" do
				expect{(machine.deposit(100))}.not_to raise_error(NoMethodError)
			end

			it "adds given amount to the account balance" do
				expect(machine.balance).to eq 1000
				machine.deposit(100, 1234)
				expect(machine.balance).to eq 1100
			end
		end

	end

	describe "user authorization" do

		context "pin number" do
			let(:machine) { AtmMachine.new(1000) }
			it "has pin number set but not accessible" do
				expect{(machine.pin)}.to raise_error(AtmMachine::InaccessiblePinError)
			end

			it "has authorization information" do
				expect{(machine.authorized_user)}.not_to raise_error(NoMethodError)
			end

			it "has default authorization flague set to false on class init" do
				expect(machine.authorized_user).to eq false
			end

			it "validates user with a pin on any action" do
				expect{(machine.withdraw(100, 1234))}.not_to raise_error(ArgumentError)
				expect{(machine.deposit(100, 1234))}.not_to raise_error(ArgumentError)
			end

			it "authorizes user with a given pin on any action" do
				expect{(machine.withdraw(100, 1111))}.to raise_error(AtmMachine::WrongPinError)
				expect{(machine.deposit(100, 1111))}.to raise_error(AtmMachine::WrongPinError)
			end

			it "performs withdraw after pin authorization" do
				expect(machine.balance).to eq 1000
				machine.withdraw(100, 1234)
				expect(machine.authorized_user).to eq true
				expect(machine.balance).to eq 900
			end

			it "performs deposit after pin authorization" do
				expect(machine.balance).to eq 1000
				machine.deposit(100, 1234)
				expect(machine.authorized_user).to eq true
				expect(machine.balance).to eq 1100
			end
		end
	end

		
end