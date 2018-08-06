require 'test_helper'
 
class MessageTest < ActiveSupport::TestCase
  test 'should create message with minimum information' do
    message = Message.new( email: 'test@gmail.com', first_name: 'Test', last_name: 'Test', subject: 'A Subject', message: 'A message body', campaign_id: '1234' )

    assert message.save
  end

  test "shouldn't create empty message" do
    message = Message.new

    assert_not message.save
  end

  test "shouldn't create message with bad email" do
    message = Message.new( email: 'testgmail.com', first_name: 'Test', last_name: 'Test', subject: 'A Subject', message: 'A message body', campaign_id: '1234' )

    assert_not message.save
  end
end