require 'test_helper'
 
class ReceiptRulesTest < ActiveSupport::TestCase
  setup do
    @receipt = receipts(:basic)
  end

  test 'should initialize test receipt rules' do
    rules = Rules::ReceiptRules.new('ma', 'municipal')

    assert_not rules.nil?
    assert rules.is_a? Rules::ReceiptRules
  end

  test 'should run basic check' do
    rules = Rules::ReceiptRules.new('ma', 'municipal')
    actions = rules.check(@receipt, Donor.get(@receipt.name, @receipt.campaign_id))

    assert actions.length == 0
  end
end