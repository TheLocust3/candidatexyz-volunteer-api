require 'json'

module StateJSON
  class MAReportJSON
    attr_reader :data

    def initialize(report, receipts, expenditures, in_kinds, liabilities, campaign, users, committee, last_report)
      @data = Hash.new

      @report = report
      @receipts = receipts
      @expenditures = expenditures
      @in_kinds = in_kinds
      @liabilities = liabilities
      @campaign = campaign
      @users = users
      @committee = committee
      @last_report = last_report

      generate
    end

    private
    def generate
      data['textfield'] = {
        'dtBegDate[0]': @report.beginning_date.strftime('%m/%d/%Y'),
        'dtEndDate[0]': @report.ending_date.strftime('%m/%d/%Y')
      }

      data['checkbox'] = {
        'cbCandWComm[0]': '/On'
      }

      if @report.report_type == 'M102_edit_8_prelim'
        data['checkbox']['cbPrePreliminary[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_8_elect'
        data['checkbox']['cbPreElection[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_30_after'
        data['checkbox']['cbPostElection[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_year_end'
        data['checkbox']['cbYearEnd[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_dissolution'
        data['checkbox']['cbDissolution[0]'] = '/On'
      end

      generate_candidate
      generate_committee
      generate_summary
      generate_receipts
      generate_expenditures
      generate_in_kinds
      generate_liabilities
    end

    def generate_candidate
      candidate = @users.select { |user| user['position'] == 'Candidate' }.first

      data['textfield']['txtCandName[0]'] = "#{candidate['firstName']} #{candidate['lastName']}"

      data['textfield']['txtOfficeDistrict[0]'] = "#{@committee['office']}, #{@committee['district']}"

      data['textfield']['txtCandAddress[0]'] = "#{candidate['address']}, #{candidate['city']}, #{candidate['state']}, #{candidate['country']}"
      data['textfield']['txtCandPhone[1]'] = candidate['email']
      data['textfield']['txtCandPhone[0]'] = candidate['phoneNumber']
    end

    def generate_committee
      data['textfield']['txtCommName[0]'] = @committee['name']

      treasurer = @users.select { |user| user['position'] == 'Treasurer' }.first

      data['textfield']['txtTreasurer[0]'] = "#{treasurer['firstName']} #{treasurer['lastName']}"

      data['textfield']['txtCommAddress[0]'] = "#{@committee['address']}, #{@committee['city']}, #{@committee['state']}, #{@committee['country']}"
      data['textfield']['txtCandPhone[2]'] = @committee['email']
      data['textfield']['txtCommPhone[0]'] = @committee['phoneNumber']
    end

    def generate_summary
      data['textfield']['txtBegBal[0]'] = @last_report.ending_balance.format

      positive = Money.new(0)
      @receipts.each { |receipt| positive += receipt.amount }
      data['textfield']['txtSumReceipts[0]'] = positive.format

      data['textfield']['txtSubtotal[0]'] = (positive + @last_report.ending_balance).format

      negative = Money.new(0)
      @expenditures.each { |expenditure| negative += expenditure.amount }
      data['textfield']['txtSumExpenditures[0]'] = negative.format

      data['textfield']['txtEndBal[0]'] = (positive + @last_report.ending_balance - negative).format

      total = Money.new(0)
      @in_kinds.each { |in_kind| total += in_kind.value }
      data['textfield']['txtSumInKinds[0]'] = total.format

      total = Money.new(0)
      @liabilities.each { |liability| total += liability.amount }
      data['textfield']['txtSumLiabilities[0]'] = total.format

      # TODO: Name of bank
    end

    def generate_receipts
      # TODO: What if greater than 27?
      @receipts.select { |receipt| receipt.amount_cents > 5000 }[0..24].each_with_index { |receipt, i|
        data['textfield']["dtRecDate#{i + 1}[0]"] = receipt.date_received.strftime('%m/%d/%Y')
        data['textfield']["txtRecNameAddress#{i + 1}[0]"] = "#{receipt.name}\n#{receipt.address}, #{receipt.city}, #{receipt.state}, #{receipt.country}"
        data['textfield']["txtRecAmount#{i + 1}[0]"] = receipt.amount.format
        data['textfield']["txtRecOccEmp#{i + 1}[0]"] = "#{receipt.occupation}\n#{receipt.employer}"
      }

      over_50 = Money.new(0)
      @receipts.each { |receipt| 
        if receipt.amount_cents > 5000
          over_50 += receipt.amount
        end
      }
      data['textfield']['txtItemizedRec1[0]'] = over_50.format
      data['textfield']['txtItemizedRec2[0]'] = over_50.format

      under_50 = Money.new(0)
      @receipts.each { |receipt|
        if receipt.amount_cents <= 5000
          under_50 += receipt.amount
        end
      }
      data['textfield']['txtUnitemizedRec1[0]'] = under_50.format
      data['textfield']['txtUnitemizedRec2[0]'] = under_50.format

      total = Money.new(0)
      @receipts.each { |receipt| total += receipt.amount }
      data['textfield']['txtTotalRec1[0]'] = total.format
      data['textfield']['txtTotalRec2[0]'] = total.format
    end

    def generate_expenditures
      @expenditures.select { |expenditure| expenditure.amount_cents > 5000 }[0..24].each_with_index { |expenditure, i|
        data['textfield']["dtExpDate#{i + 1}[0]"] = expenditure.date_paid.strftime('%m/%d/%Y')
        data['textfield']["txtVendor#{i + 1}[0]"] = expenditure.paid_to
        data['textfield']["txtVendorAddress#{i + 1}[0]"] = "#{expenditure.address}, #{expenditure.city}, #{expenditure.state}, #{expenditure.country}"
        data['textfield']["txtExpPurpose#{i + 1}[0]"] = expenditure.purpose
        data['textfield']["txtExpAmount#{i + 1}[0]"] = expenditure.amount.format
      }

      over_50 = Money.new(0)
      @expenditures.each { |expenditure| 
        if expenditure.amount_cents > 5000
          over_50 += expenditure.amount
        end
      }
      data['textfield']['txtItemizedExp1[0]'] = over_50.format
      data['textfield']['txtItemizedExp2[0]'] = over_50.format

      under_50 = Money.new(0)
      @expenditures.each { |expenditure|
        if expenditure.amount_cents <= 5000
          under_50 += expenditure.amount
        end
      }
      data['textfield']['txtUnitemizedExp1[0]'] = under_50.format
      data['textfield']['txtUnitemizedExp2[0]'] = under_50.format

      total = Money.new(0)
      @expenditures.each { |expenditure| total += expenditure.amount }
      data['textfield']['txtTotalExp1[0]'] = total.format
      data['textfield']['txtTotalExp2[0]'] = total.format
    end

    def generate_in_kinds
      @in_kinds.select { |in_kind| in_kind.value_cents > 5000 }[0..11].each_with_index { |in_kind, i|
        data['textfield']["dtIkDate#{i + 1}[0]"] = in_kind.date_received.strftime('%m/%d/%Y')
        data['textfield']["txtIkName#{i + 1}[0]"] = in_kind.from_whom
        data['textfield']["txtIkAddress#{i + 1}[0]"] = "#{in_kind.address}, #{in_kind.city}, #{in_kind.state}, #{in_kind.country}"
        data['textfield']["txtIkDescription#{i + 1}[0]"] = in_kind.description
        data['textfield']["txtIkValue#{i + 1}[0]"] = in_kind.value.format
      }

      over_50 = Money.new(0)
      @in_kinds.each { |in_kind| 
        if in_kind.value_cents > 5000
          over_50 += in_kind.value
        end
      }
      data['textfield']['txtItemizedIk[0]'] = over_50.format

      under_50 = Money.new(0)
      @in_kinds.each { |in_kind|
        if in_kind.value_cents <= 5000
          under_50 += in_kind.value
        end
      }
      data['textfield']['txtUnitemziedIk[0]'] = under_50.format

      total = Money.new(0)
      @in_kinds.each { |in_kind| total += in_kind.value }
      data['textfield']['txtTotalIk[0]'] = total.format
    end

    def generate_liabilities
      @liabilities[0..13].each_with_index { |liability, i|
        data['textfield']["dtLiabDate#{i + 1}[0]"] = liability.date_incurred.strftime('%m/%d/%Y')
        data['textfield']["txtLiabName#{i + 1}[0]"] = liability.to_whom
        data['textfield']["txtLiabAddress#{i + 1}[0]"] = "#{liability.address}, #{liability.city}, #{liability.state}, #{liability.country}"
        data['textfield']["txtLiabPurpose#{i + 1}[0]"] = liability.purpose
        data['textfield']["txtLiabAmount#{i + 1}[0]"] = liability.amount.format
      }

      total = Money.new(0)
      @liabilities.each { |liability| total += liability.amount }
      data['textfield']['txtTotalLiab[0]'] = total.format
    end
  end
end