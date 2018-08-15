class Rule
    attr_reader :raw_rule

    def initialize(raw_rule)
        @raw_rule = raw_rule
    end

    def check(data)
        object = data[raw_rule['type'].to_sym]
        if object.nil?
            return []
        end

        result = run_extra_checks(object)
        unless result
            return []
        end

        object = result

        attribute = object.send(raw_rule['attribute'])
        if attribute.nil?
            return []
        end

        if eval_threshold(attribute, raw_rule['attribute'], raw_rule['threshold'])
            return raw_rule.children.select { |child| child.element? }.map do |child|
                RuleAction.create(child).execute
            end
        end

        []
    end

    private
    def run_extra_checks(object)
        keys = raw_rule.keys
        keys = keys - ['type', 'attribute', 'threshold']

        for key in keys
            # TODO: time has some extra logic to it that I haven't written
            if key != 'to_person'
                if object.method(key).parameters.length == 0
                    if object.send(key) != raw_rule[key]
                        return false
                    end
                else
                    result = object.send(key, raw_rule[key])

                    object = result
                end
            end
        end

        object
    end

    def eval_threshold(attribute, attribute_type, threshold)
        method, value = threshold.split(' ')

        if attribute_type == 'amount' || attribute_type == 'value'
            return attribute.send(method, Money.new(value.to_i * 100)) # in cents
        end

        return attribute.send(method, value.to_i)
    end
end
