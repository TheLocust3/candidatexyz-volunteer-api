require 'test_helper'
 
class InKindRulesTest < ActiveSupport::TestCase
  setup do
    @in_kind = in_kinds(:basic)
  end

  test 'should initialize test in kind rules' do
    rules = Rules::InKindRules.new('ma', 'municipal')

    assert_not rules.nil?
    assert rules.is_a? Rules::InKindRules
  end

  test 'should run basic check' do
    rules = Rules::InKindRules.new('ma', 'municipal')
    actions = rules.check(@in_kind, Donor.get(@in_kind.from_whom, @in_kind.campaign_id))

    assert actions.length == 0
  end
end