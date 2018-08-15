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

        unless run_extra_checks(object)
            return []
        end

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
            result = object.method(key).parameters.length == 0 ? object.send(key) : object.send(key, raw_rule[key])

            # TODO: time has some extra logic to it that I haven't written
            if key != 'time' && key != 'to_person' && result != raw_rule[key]
                return false
            end
        end

        return true
    end

    def eval_threshold(attribute, attribute_type, threshold)
        method, value = threshold.split(' ')

        if attribute_type == 'amount' || attribute_type == 'value'
            return attribute.send(method, Money.new(value.to_i * 100)) # in cents
        end

        return attribute.send(method, value.to_i)
    end
end
