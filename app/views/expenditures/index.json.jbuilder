json.expenditures @expenditures do |expenditure|
    json.partial! 'expenditures/expenditure', expenditure: expenditure
end
