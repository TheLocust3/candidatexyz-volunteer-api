require 'test_helper'
 
class LiabilityRulesTest < ActiveSupport::TestCase
  setup do
    @liability = liabilities(:basic)
  end

  test 'should initialize test receipt rules' do
    rules = Rules::LiabilityRules.new('ma', 'municipal')

    assert_not rules.nil?
    assert rules.is_a? Rules::LiabilityRules
  end

  test 'should run basic check' do
    rules = Rules::LiabilityRules.new('ma', 'municipal')
    actions = rules.check(@liability)

    assert actions.length == 0
  end
end