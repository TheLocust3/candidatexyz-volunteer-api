require 'test_helper'
 
class ImageTest < ActiveSupport::TestCase
  test 'should create image' do
    image = Image.new( identifier: 'blah', url: 'www.google.com' )

    assert image.save
  end

  test "shouldn't create empty image" do
    image = Image.new

    assert_not image.save
  end
end