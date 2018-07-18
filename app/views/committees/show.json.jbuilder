json.partial! 'committees/committee', committee: @committee
json.report do
    json.partial! 'reports/report', report: @report, base_url: @base_url
end
