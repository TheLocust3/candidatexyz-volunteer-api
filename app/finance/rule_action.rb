class RuleAction
    attr_reader :raw_action

    def self.create(raw_action)
        if raw_action.name == 'hide'
            HideAction.new(raw_action)
        elsif raw_action.name == 'stop'
            StopAction.new(raw_action)
        elsif raw_action.name == 'require'
            RequireAction.new(raw_action)
        else
            puts 'ERROR: Rule Action not found!'
            RuleAction.new(raw_action)
        end
    end

    def initialize(raw_action)
        @raw_action = raw_action
    end

    def execute
        return 'Action not found!'
    end
end

class HideAction < RuleAction

    def initialize(raw_action)
        super(raw_action)
    end

    def execute
        return { action: 'hide' }
    end
end

class StopAction < RuleAction

    def initialize(raw_action)
        super(raw_action)
    end

    def execute
        return { action: 'stop', message: raw_action['message'] }
    end
end

class RequireAction < RuleAction

    def initialize(raw_action)
        super(raw_action)
    end

    def execute
        return { action: 'require', attribute: raw_action['attribute'], message: raw_action['message'] }
    end
end
