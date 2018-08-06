require 'test_helper'
 
class NotificationTest < ActiveSupport::TestCase
  test 'should create notification' do
    notification = Notification.new( title: 'Title', body: 'Body', link: 'www.google.com', campaign_id: '1234' )

    assert notification.save
  end

  test "shouldn't create empty notification" do
    notification = Notification.new

    assert_not notification.save
  end
end