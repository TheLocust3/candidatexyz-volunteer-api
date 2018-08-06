require 'test_helper'
 
class ContactTest < ActiveSupport::TestCase
  test 'should create contact with minimum information' do
    contact = Contact.new( email: 'test@gmail.com', zipcode: '01867', campaign_id: '1234' )

    assert contact.save
  end

  test 'should create contact with maximum information' do
    contact = Contact.new( email: 'test@gmail.com', first_name: 'Test', last_name: 'Test', zipcode: '01867', phone_number: '7813155580', campaign_id: '1234' )

    assert contact.save
  end

  test 'should create contact with nice phone number' do
    contact = Contact.new( email: 'test@gmail.com', zipcode: '01867', phone_number: '(781)-315-5580', campaign_id: '1234' )

    assert contact.save
    assert contact.phone_number == '7813155580'
  end

  test "shouldn't create empty contact" do
    contact = Contact.new

    assert_not contact.save
  end

  test "shouldn't create contact with bad phone number" do
    contact = Contact.new( email: 'test@gmail.com', zipcode: '01867', phone_number: 'bad phone number', campaign_id: '1234' )

    assert_not contact.save
  end

  test "shouldn't create contact with bad email" do
    contact = Contact.new( email: 'testgmail.com', zipcode: '01867', campaign_id: '1234' )

    assert_not contact.save
  end

  test "shouldn't create contact with zipcode" do
    contact = Contact.new( email: 'test@gmail.com', zipcode: '123456', campaign_id: '1234' )

    assert_not contact.save
  end
end