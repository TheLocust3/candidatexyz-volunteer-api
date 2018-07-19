class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.to_csv(attributes)
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |record|
        csv << attributes.map{ |attr| record.send(attr) }
      end
    end
  end
end
