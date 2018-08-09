json.partial! 'committees/committee', committee: @committee
json.report do
    json.partial! 'reports/report', report: @committee.report, base_url: @base_url
end

unless @committee.dissolution_report.nil?
    json.dissolutionReport do
        json.partial! 'reports/report', report: @committee.dissolution_report, base_url: @base_url
    end
end
