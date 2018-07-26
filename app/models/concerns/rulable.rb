module Rulable
  extend ActiveSupport::Concern

  def handle_rules(rules, record)
    rules.each do |rule|
      if rule[:action] == 'require'
        handle_require(rule, record)
      elsif rule[:action] == 'stop'
        handle_stop(rule, record)
      end
    end
  end

  private
  def handle_require(rule, record)
    if record.send(rule[:attribute]).nil? || record.send(rule[:attribute]).empty?
      record.errors.add(rule[:attribute], rule[:message])
    end
  end

  def handle_stop(rule, record)
    errors.add(rule[:action], rule[:message])
  end
end
