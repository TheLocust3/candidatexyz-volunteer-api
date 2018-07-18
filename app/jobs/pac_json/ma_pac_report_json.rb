require 'json'

module PacJSON
  class MaPacReportJSON

    attr_reader :data

    def initialize(report, campaign, users, committee)
      @report = report
      @campaign = campaign
      @users = users
      @committee = committee

      @data = Hash.new
      @data['ma'] = Hash.new
      @data['ma'][@report.report_type] = Hash.new
      @data['ma'][@report.report_type]['textfield'] = Hash.new

      generate
    end

    private
    def data_main
      data['ma'][@report.report_type]
    end

    def generate
      generate_candidate
      generate_committee
      generate_chair
      generate_treasurer
    end

    def generate_candidate
      candidate = @users.select { |user| user['position'] == 'Candidate' }.first

      data_main['textfield']['txtCandName[0]'] = "#{candidate['firstName']} #{candidate['lastName']}"

      data_main['textfield']['txtCandAddress[0]'] = candidate['address']
      data_main['textfield']['txtCandCity[0]'] = candidate['city']
      data_main['textfield']['txtCandState[0]'] = candidate['state']

      data_main['textfield']['txtCandEmail[0]'] = candidate['email']
      data_main['textfield']['txtCandPhone[0]'] = candidate['phoneNumber']

      data_main['textfield']['txtOffice[0]'] = @committee.office
      data_main['textfield']['txtDistrict[0]'] = @committee.district
    end

    def generate_committee
      data_main['textfield']['txtCommName[0]'] = @committee.name

      data_main['textfield']['txtCommAddress[0]'] = @committee.address
      data_main['textfield']['txtCommCity[0]'] = @committee.city
      data_main['textfield']['txtCommState[0]'] = @committee.state

      data_main['textfield']['txtCommPhone[0]'] = @committee.phone_number
    end

    def generate_chair
      chair = @users.select { |user| user['position'] == 'Chair' }.first

      data_main['textfield']['txtChairName[0]'] = "#{chair['firstName']} #{chair['lastName']}"
      data_main['textfield']['txtChairAddress[0]'] = chair['address']
      data_main['textfield']['txtChairCity[0]'] = chair['city']
      data_main['textfield']['txtChairState[0]'] = chair['state']

      data_main['textfield']['txtChairPhone[0]'] = chair['phoneNumber']
    end

    def generate_treasurer
      treasurer = @users.select { |user| user['position'] == 'Treasurer' }.first

      data_main['textfield']['txtTreasName[0]'] = "#{treasurer['firstName']} #{treasurer['lastName']}"
      data_main['textfield']['txtTreasAddress[0]'] = treasurer['address']
      data_main['textfield']['txtTreasCity[0]'] = treasurer['city']
      data_main['textfield']['txtTreasState[0]'] = treasurer['state']

      data_main['textfield']['txtTreasPhone[0]'] = treasurer['phoneNumber']
      data_main['textfield']['txtChairPhone[1]'] = treasurer['email']
    end
  end
end