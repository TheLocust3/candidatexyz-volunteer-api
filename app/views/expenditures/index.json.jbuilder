json.contacts @expenditures do |expenditure|
    json.partial! 'expenditures/expenditure', expenditure: expenditure
end
