json.reports @reports do |report|
    json.partial! 'reports/report', report: report, base_url: @base_url
end
