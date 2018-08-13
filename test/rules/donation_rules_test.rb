require 'test_helper'
 
class DonationRulesTest < ActiveSupport::TestCase
  setup do
    @receipt = receipts(:basic)
    @in_kind = in_kinds(:basic)
  end

  test 'should initialize test donation rules' do
    rules = Rules::DonationRules.new('ma', 'municipal')

    assert_not rules.nil?
    assert rules.is_a? Rules::DonationRules
  end

  test 'should run basic check on receipt' do
    rules = Rules::DonationRules.new('ma', 'municipal')
    actions = rules.check(@receipt, Donor.get(@receipt.name, @receipt.campaign_id))

    assert actions.length == 0
  end

  test 'should run basic check on in kind' do
    rules = Rules::DonationRules.new('ma', 'municipal')
    actions = rules.check(@in_kind, Donor.get(@in_kind.from_whom, @in_kind.campaign_id))

    assert actions.length == 0
  end
end