require 'test_helper'
 
class ReportTest < ActiveSupport::TestCase
  test 'should create report with minimum information' do
    report = Report.new( report_type: 'type', report_class: 'class', status: 'done', campaign_id: '1234' )

    assert report.save
  end

  test "shouldn't create empty report" do
    report = Report.new

    assert_not report.save
  end

  test 'should create finance report with dates' do
    report = Report.new( report_type: 'type', report_class: 'finance', status: 'done', data: { beginning_date: DateTime.new(2018, 1, 1), ending_date: DateTime.new(2018, 2, 1) }, campaign_id: '1234' )

    assert report.save
  end

  test "shouldn't create finance report without dates" do
    report = Report.new( report_type: 'type', report_class: 'finance', status: 'done', campaign_id: '1234' )

    assert_not report.save
  end

  test "shouldn't create finance report without beginning date before end date" do
    report = Report.new( report_type: 'type', report_class: 'finance', status: 'done', data: { beginning_date: DateTime.new(2018, 2, 1), ending_date: DateTime.new(2018, 1, 1) }, campaign_id: '1234' )

    assert_not report.save
  end
end