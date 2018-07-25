require 'nokogiri'

module Rules

    class RulesOrganizer
        attr_reader :rules

        def initialize

        end


    end

    class Rules
        attr_reader :state, :type, :rules_type, :raw_xml, :raw_rules

        def initialize(state, type, rules_type)
            @state = state
            @type = type

            read_rules
        end

        def check()

        end

        private
        def read_rules
            raw_xml = Nokogiri::XML(File.read("#{state}/#{type}/#{rules_type}.xml"))
            
            raw_rules = raw_xml.xpath('//rule').map {|rule|
                Rules::Rule.new(rule)
            }
        end
    end

    class DonationRules < Rules

        def initialize(state, type)
            super(state, type, 'donation')
        end

        # donation is a Receipt or InKind
        def check(donation, donor)
            raw_rules.each {|rule|
                rule.check({ 'donation': donation, 'donor': donor })
            }
        end
    end

    class ReceiptRules < Rules

        def initialize(state, type)
            super(state, type, 'receipt')
        end

        def check(receipt)
            raw_rules.each {|rule|
                rule.check({ 'receipt': receipt })
            }
        end
    end
    
    class InKindRules < Rules

        def initialize(state, type)
            super(state, type, 'in_kind')
        end

        def check(in_kind)
            raw_rules.each {|rule|
                rule.check({ 'in_kind': in_kind })
            }
        end
    end

    class ExpenditureRules < Rules

        def initialize(state, type)
            super(state, type, 'expenditure')
        end

        def check(expenditure)
            raw_rules.each {|rule|
                rule.check({ 'expenditure': expenditure })
            }
        end
    end
end