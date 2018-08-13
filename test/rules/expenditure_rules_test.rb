require 'test_helper'
 
class ExpenditureRulesTest < ActiveSupport::TestCase
  setup do
    @expenditure = expenditures(:basic)
  end

  test 'should initialize test expenditure rules' do
    rules = Rules::ExpenditureRules.new('ma', 'municipal')

    assert_not rules.nil?
    assert rules.is_a? Rules::ExpenditureRules
  end

  test 'should run basic check' do
    rules = Rules::ExpenditureRules.new('ma', 'municipal')
    actions = rules.check(@expenditure)

    assert actions.length == 0
  end
end