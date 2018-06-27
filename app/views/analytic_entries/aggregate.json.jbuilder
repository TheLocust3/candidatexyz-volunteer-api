json.analytic_entries @analytic_entries do |analytic_entry|
    json.datetime analytic_entry[:datetime]
    json.hits analytic_entry[:hits]
end
