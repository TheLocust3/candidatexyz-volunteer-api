require 'test_helper'
 
class ExpenditureTest < ActiveSupport::TestCase

  test 'should create expenditure with minimum information' do
    expenditure = Expenditure.new( paid_to: 'Test Test', purpose: 'A purpose', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_paid: DateTime.new(2018, 1, 1, 1, 0), amount: 50, campaign_id: '1234' )

    assert expenditure.save
  end

  test "shouldn't create empty expenditure" do
    expenditure = Expenditure.new

    assert_not expenditure.save
  end
end