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

                return ["Object isn't found in data array!"]
            end

            attribute = object.send(data[raw_rule['attribute']])
            if attribute.nil?
                puts "ERROR: Attribute isn't found in data array!"

                return ["Attribute isn't found in data array!"]
            end

            if eval_threshold(attribute, raw_rule['threshold'])
                return raw_rule.children.map { |child|
                    "Violated #{raw_rule['type']} is #{raw_rule['treshold']} and #{Rules::Action.create(child).execute}"
                }
            end

            []
        end

        private
        def eval_threshold(attribute, threshold)
            method, value = threshold.split(' ')

            return attribute.send(method, value)
        end
    end
end