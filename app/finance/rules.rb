require 'pathname'
require 'nokogiri'

module Rules

    BASE_PATH = 'app/finance/rules'

    class RulesOrganizer
        attr_reader :rules

        def initialize
            @rules = Hash.new

            generate_rules
        end

        private
        def generate_rules
            Dir.glob("#{BASE_PATH}/*/").each do |state|
                if File.directory? state
                    state_name = File.basename(state)
                    @rules[state_name] = Hash.new

                    Dir.glob("#{BASE_PATH}/#{state_name}/*/").each do |type|
                        type_name = File.basename(type)

                        @rules[state_name][type_name] = Hash.new
                        
                        @rules[state_name][type_name]['donation'] = DonationRules.new(state_name, type_name)
                        @rules[state_name][type_name]['receipt'] = ReceiptRules.new(state_name, type_name)
                        @rules[state_name][type_name]['in_kind'] = InKindRules.new(state_name, type_name)
                        @rules[state_name][type_name]['expenditure'] = ExpenditureRules.new(state_name, type_name)
                    end
                end
            end
        end
    end

    class Rules
        attr_reader :state, :type, :rules_type, :raw_xml, :raw_rules

        def initialize(state, type, rules_type)
            @state = state
            @type = type
            @rules_type = rules_type

            read_rules
        end

        def check()

        end

        private
        def read_rules
            raw_xml = Nokogiri::XML(File.read("#{BASE_PATH}/#{state}/#{type}/#{rules_type}.xml"))
            
            @raw_rules = raw_xml.xpath('//rule').map do |rule|
                Rule.new(rule)
            end
        end
    end

    class DonationRules < Rules

        def initialize(state, type)
            super(state, type, 'donation')
        end

        # donation is a Receipt or InKind
        def check(donation, donor)
            raw_rules.map { |rule|
                rule.check({ donation: donation, donor: donor })
            }.flatten
        end
    end

    class ReceiptRules < Rules

        def initialize(state, type)
            super(state, type, 'receipt')
        end

        def check(receipt)
            raw_rules.map { |rule|
                rule.check({ receipt: receipt })
            }.flatten
        end
    end
    
    class InKindRules < Rules

        def initialize(state, type)
            super(state, type, 'in_kind')
        end

        def check(in_kind)
            raw_rules.map { |rule|
                rule.check({ in_kind: in_kind })
            }.flatten
        end
    end

    class ExpenditureRules < Rules

        def initialize(state, type)
            super(state, type, 'expenditure')
        end

        def check(expenditure)
            raw_rules.map { |rule|
                rule.check({ expenditure: expenditure })
            }.flatten
        end
    end
end