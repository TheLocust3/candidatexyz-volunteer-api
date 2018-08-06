require 'test_helper'
 
class AnalyticEntryTest < ActiveSupport::TestCase
  test 'should create analytic entry with minimum information' do
    analytic_entry = AnalyticEntry.new( payload: { data: 'data' }, campaign_id: '1234' )

    assert analytic_entry.save
  end

  test 'should create analytic entry with maximum information' do
    analytic_entry = AnalyticEntry.new( payload: { data: 'data' }, campaign_id: '1234', ip: 'an ip address' )

    assert analytic_entry.save
  end

  test "shouldn't create empty analytic entry" do
    analytic_entry = AnalyticEntry.new

    assert_not analytic_entry.save
  end
end