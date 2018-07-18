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
      generate_other
    end

    def generate_candidate
      candidate = @users.select { |user| user['position'] == 'Candidate' }.first

      data_main['textfield']['txtCandName[0]'] = "#{candidate['firstName']} #{candidate['lastName']}"

      data_main['textfield']['txtCandAddress[0]'] = candidate['address']
      data_main['textfield']['txtCandCity[0]'] = candidate['city']
      data_main['textfield']['txtCandState[0]'] = candidate['state']
      data_main['textfield']['txtCandZip[0]'] = candidate['zipcode']

      data_main['textfield']['txtCandEmail[0]'] = candidate['email']
      data_main['textfield']['txtCandPhone[0]'] = candidate['phoneNumber']
      data_main['textfield']['txtParty[0]'] = candidate['party']

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
      data_main['textfield']['txtChairZip[0]'] = chair['zipcode']

      data_main['textfield']['txtChairPhone[0]'] = chair['phoneNumber']
    end

    def generate_treasurer
      treasurer = @users.select { |user| user['position'] == 'Treasurer' }.first

      data_main['textfield']['txtTreasName[0]'] = "#{treasurer['firstName']} #{treasurer['lastName']}"
      data_main['textfield']['txtTreasAddress[0]'] = treasurer['address']
      data_main['textfield']['txtTreasCity[0]'] = treasurer['city']
      data_main['textfield']['txtTreasState[0]'] = treasurer['state']
      data_main['textfield']['txtTreasZip[0]'] = treasurer['zipcode']

      data_main['textfield']['txtTreasPhone[0]'] = treasurer['phoneNumber']
      data_main['textfield']['txtChairPhone[1]'] = treasurer['email']
    end

    def generate_other
      others = @users.select { |user| !(['Chair', 'Candidate', 'Treasurer'].include?(user['position']))  }

      if others.length == 0
        return
      end

      data_main['textfield']['txtOtherOfficer0Name[0]'] = "#{others[0]['firstName']} #{others[0]['lastName']} (#{others[0]['position']})"
      data_main['textfield']['txOtherOfficer0Address[0]'] = others[0]['address']
      data_main['textfield']['txtOtherOfficer0City[0]'] = others[0]['city']
      data_main['textfield']['txtOtherOfficer0State[0]'] = others[0]['state']
      data_main['textfield']['txtOtherOfficer0Zip[0]'] = others[0]['zipcode']

      data_main['textfield']['txtOtherOfficer0Phone[0]'] = others[0]['phoneNumber']
      
      if others.length == 1
        return
      end

      data_main['textfield']['txtOtherOfficer1Name[0]'] = "#{others[1]['firstName']} #{others[1]['lastName']} (#{others[1]['position']})"
      data_main['textfield']['txOtherOfficer1Address[0]'] = others[1]['address']
      data_main['textfield']['txtOtherOfficer1City[0]'] = others[1]['city']
      data_main['textfield']['txtOtherOfficer1State[0]'] = others[1]['state']
      data_main['textfield']['txtOtherOfficer1Zip[0]'] = others[1]['zipcode']

      data_main['textfield']['txtOtherOfficer1Phone[0]'] = others[1]['phoneNumber']
    end
  end
end