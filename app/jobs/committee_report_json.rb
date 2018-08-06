require 'json'

class CommitteeReportJSON
  attr_reader :data

  def initialize(state, report, campaign, users, committee)
    @report = report
    @campaign = campaign
    @users = users
    @committee = committee

    if state.to_s == 'ma'
      if campaign['officeType'] == 'Municipal'
        @data = CommitteeJSON::MAMunicipalCommitteeReportJSON.new(report, campaign, users, committee).data
      elsif campaign['officeType'] == 'State'
        @data = CommitteeJSON::MAStateCommitteeReportJSON.new(report, campaign, users, committee).data
      end
    end
  end

  def save(filename)
    File.open(filename, 'w') { |file| file.write(JSON.generate(data)) }
  end
end
