class ZipcodeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        if value.nil? || value == ''
            return
        end

        unless value =~ /^[0-9]{5}(?:-[0-9]{4})?$/
            record.errors[attribute] << (options[:message] || "is not a zipcode")
        end
    end
end