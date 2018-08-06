require 'test_helper'
 
class VolunteerTest < ActiveSupport::TestCase
  test 'should create volunteer with minimum information' do
    volunteer = Volunteer.new( email: 'test@gmail.com', first_name: 'Test', last_name: 'Test', zipcode: '01867', campaign_id: '1234' )

    assert volunteer.save
  end

  test 'should create volunteer with maximum information' do
    volunteer = Volunteer.new( email: 'test@gmail.com', first_name: 'Test', last_name: 'Test', address: '304 Franklin Street', city: 'Reading', state: 'State', zipcode: '01867', phone_number: '7813155580', campaign_id: '1234' )

    assert volunteer.save
  end

  test 'should create contact from volunteer' do
    volunteer = Volunteer.new( email: 'test@gmail.com', first_name: 'Test', last_name: 'Test', zipcode: '01867', campaign_id: '1234' )

    assert volunteer.save

    assert_not volunteer.contact.nil?
    assert volunteer.contact.email == 'test@gmail.com'
    assert volunteer.contact.first_name == 'Test'
    assert volunteer.contact.last_name == 'Test'
    assert volunteer.contact.zipcode == '01867'
  end

  test "shouldn't create empty volunteer" do
    volunteer = Volunteer.new

    assert_not volunteer.save
  end

  test "shouldn't create volunteer with bad email" do
    volunteer = Volunteer.new( email: 'testgmail.com', first_name: 'Test', last_name: 'Test', zipcode: '01867', campaign_id: '1234' )

    assert_not volunteer.save
  end
  
  test "shouldn't create volunteer with bad phone number" do
    volunteer = Volunteer.new( email: 'test@gmail.com', first_name: 'Test', last_name: 'Test', zipcode: '01867', phone_number: 'bad phone number', campaign_id: '1234' )

    assert_not volunteer.save
  end

  test "shouldn't create volunteer with bad zipcode" do
    volunteer = Volunteer.new( email: 'test@gmail.com', first_name: 'Test', last_name: 'Test', zipcode: '123456', campaign_id: '1234' )

    assert_not volunteer.save
  end
end