require 'test_helper'
 
class CommitteeTest < ActiveSupport::TestCase
  test 'should create committee with minimum information' do
    committee = Committee.new( name: 'Test Committee', email: 'test@gmail.com', phone_number: '781-315-5580', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', zipcode: '01867', office: 'Office', district: 'District', bank: 'Reading Cooperative Bank', campaign_id: '1234' )

    assert committee.save
  end

  test "shouldn't create committee with bad phone number" do
    committee = Committee.new( name: 'Test Committee', email: 'test@gmail.com', phone_number: 'bad number', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', zipcode: '01867', office: 'Office', district: 'District', bank: 'Reading Cooperative Bank', campaign_id: '1234' )

    assert_not committee.save
  end

  test "shouldn't create committee with bad email" do
    committee = Committee.new( name: 'Test Committee', email: 'testgmail.com', phone_number: '781-315-5580', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', zipcode: '01867', office: 'Office', district: 'District', bank: 'Reading Cooperative Bank', campaign_id: '1234' )

    assert_not committee.save
  end

  test "shouldn't create committee with zipcode" do
    committee = Committee.new( name: 'Test Committee', email: 'test@gmail.com', phone_number: '781-315-5580', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', zipcode: 'bad zipcode', office: 'Office', district: 'District', bank: 'Reading Cooperative Bank', campaign_id: '1234' )

    assert_not committee.save
  end
end