require 'test_helper'
 
class InKindTest < ActiveSupport::TestCase

  test 'should create in kind with minimum information' do
    in_kind = InKind.new( from_whom: 'Test Test', description: 'A description', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.new(2018, 1, 1, 1, 0), value: 50, campaign_id: '1234' )

    assert in_kind.save
  end

  test "should create in kind with maximum information" do
    in_kind = InKind.new( email: 'test@gmail.com', phone_number: '7813155580', from_whom: 'Test Test', description: 'A description', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.new(2018, 1, 1, 1, 0), value: 50, campaign_id: '1234' )

    assert in_kind.save
  end

  test "shouldn't create empty in kind" do
    in_kind = InKind.new

    assert_not in_kind.save
  end

  test "shouldn't create in kind with bad email" do
    in_kind = InKind.new( email: 'testgmail.com', from_whom: 'Test Test', description: 'A description', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.new(2018, 1, 1, 1, 0), value: 50, campaign_id: '1234' )

    assert_not in_kind.save
  end

  test "shouldn't create in kind with bad phone number" do
    in_kind = InKind.new( phone_number: 'bad phone number', from_whom: 'Test Test', description: 'A description', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.new(2018, 1, 1, 1, 0), value: 50, campaign_id: '1234' )

    assert_not in_kind.save
  end
end