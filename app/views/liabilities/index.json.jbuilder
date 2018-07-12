json.liabilities @liabilities do |liability|
    json.partial! 'liabilities/liability', liability: liability
end
