require 'json'

class PACReportJSON
  attr_reader :data

  def initialize(state, report, campaign, users, committee)
    @report = report
    @campaign = campaign
    @users = users
    @committee = committee

    if state.to_s == 'ma'
      @data = PacJSON::MaPacReportJSON.new(report, campaign, users, committee).data
    end
  end

  def save(filename)
    File.open(filename, 'w') { |file| file.write(JSON.generate(data)) }
  end
end
