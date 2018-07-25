module Rules

    def Action
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
                Action.new(raw_action)
            end
        end

        def initialize(raw_action)
            @raw_action = raw_action
        end

        def execute
            return 'Action not found!'
        end
    end

    def HideAction < Action

        def initialize(raw_action)
            super(raw_action)
        end

        def execute
            return 'must be hidden'
        end
    end

    def StopAction < Action

        def initialize
            super(raw_action)
        end

        def execute
            return 'must be stopped'
        end
    end

    def RequireAction < Action

        def initialize
            super(raw_action)
        end

        def execute
            return "#{raw_action['attribute']} is required"
        end
    end
end