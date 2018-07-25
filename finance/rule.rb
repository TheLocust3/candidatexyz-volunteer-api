module Rules

    class Rules
        attr_reader :raw_rule

        def initialize(raw_rule)
            @raw_rule = raw_rule
        end

        def check(data)
            object = data[raw_rule['type']]
            if object.nil?
                puts "ERROR: Object isn't found in data array!"

                return 0
            end

            unless run_extra_checks
                return -1
            end

            attribute = object.send(data[raw_rule['attribute']])
            if attribute.nil?
                puts "ERROR: Attribute isn't found in data array!"

                return 0
            end

            if eval_threshold(attribute, raw_rule['threshold'])
                return raw_rule.children.map { |child|
                    "Violated #{raw_rule['type']} is #{raw_rule['treshold']} and #{Rules::Action.create(child).execute}"
                }
            end

            []
        end

        private
        def run_extra_checks
            keys = raw_rule.keys
            keys = keys - ['type', 'attribute', 'threshold']

            for key in keys
                if object.send(key) != raw_rule[key]
                    return false
                end
            end

            return true
        end

        def eval_threshold(attribute, threshold)
            method, value = threshold.split(' ')

            return attribute.send(method, value)
        end
    end
end