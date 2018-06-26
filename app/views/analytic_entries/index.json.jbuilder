json.analytic_entries @analytic_entries do |analytic_entry|
    json.partial! 'analytic_entries/analytic_entry', analytic_entry: analytic_entry
end
