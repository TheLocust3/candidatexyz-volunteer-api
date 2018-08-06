require 'test_helper'
 
class LiabilityTest < ActiveSupport::TestCase

  test 'should create liability with minimum information' do
    liability = Liability.new( to_whom: 'Test Test', purpose: 'A purpose', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_incurred: DateTime.new(2018, 1, 1, 1, 0), amount: 50, campaign_id: '1234' )

    assert liability.save
  end

  test "shouldn't create empty liability" do
    liability = Liability.new

    assert_not liability.save
  end
end