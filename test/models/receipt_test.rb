require 'test_helper'
 
class ReceiptTest < ActiveSupport::TestCase

  test 'should create receipt with minimum information' do
    receipt = Receipt.new( name: 'Test Test', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.new(2018, 1, 1, 1, 0), amount: 50, campaign_id: '1234' )

    assert receipt.save
  end

  test "should create receipt with maximum information" do
    receipt = Receipt.new( email: 'test@gmail.com', phone_number: '7813155580', name: 'Test Test', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.new(2018, 1, 1, 1, 0), amount: 50, receipt_type: 'donation', occupation: 'Occupation', employer: 'Employer', campaign_id: '1234' )

    assert receipt.save
  end

  test "shouldn't create empty receipt" do
    receipt = Receipt.new

    assert_not receipt.save
  end

  test "shouldn't create receipt with bad email" do
    receipt = Receipt.new( email: 'testgmail.com', name: 'Test Test', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.new(2018, 1, 1, 1, 0), amount: 50, campaign_id: '1234' )

    assert_not receipt.save
  end

  test "shouldn't create receipt with bad phone number" do
    receipt = Receipt.new( phone_number: 'bad phone number', name: 'Test Test', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.new(2018, 1, 1, 1, 0), amount: 50, campaign_id: '1234' )

    assert_not receipt.save
  end
end