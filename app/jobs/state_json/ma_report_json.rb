require 'json'

module StateJSON
  class MAReportJSON
    @@PAGES = 7
    @@RECEIPTS = 25
    @@EXPENDITURES = 25
    @@IN_KINDS = 12
    @@LIABILITIES = 14

    attr_reader :data, :pages

    def initialize(report, receipts, expenditures, in_kinds, liabilities, campaign, users, committee, last_report)
      @report = report
      @receipts = receipts
      @expenditures = expenditures
      @in_kinds = in_kinds
      @liabilities = liabilities
      @campaign = campaign
      @users = users
      @committee = committee
      @last_report = last_report

      @data = Hash.new
      @data['ma'] = Hash.new
      @data['ma'][@report.report_type] = Hash.new

      @pages = @@PAGES

      generate
    end

    private
    def data_main
      data_ma[@report.report_type]
    end

    def data_ma
      data['ma']
    end

    def generate
      data_main['textfield'] = {
        'dtBegDate[0]': @report.beginning_date.strftime('%m/%d/%Y'),
        'dtEndDate[0]': @report.ending_date.strftime('%m/%d/%Y')
      }

      data_main['checkbox'] = {
        'cbCandWComm[0]': '/On'
      }

      if @report.report_type == 'M102_edit_8_prelim'
        data_main['checkbox']['cbPrePreliminary[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_8_elect'
        data_main['checkbox']['cbPreElection[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_30_after'
        data_main['checkbox']['cbPostElection[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_year_end'
        data_main['checkbox']['cbYearEnd[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_dissolution'
        data_main['checkbox']['cbDissolution[0]'] = '/On'
      end

      generate_candidate
      generate_committee
      generate_summary
      generate_receipts
      generate_expenditures
      generate_in_kinds
      generate_liabilities

      generate_schA_addon
      generate_schB_addon
    end

    def generate_candidate
      candidate = @users.select { |user| user['position'] == 'Candidate' }.first

      data_main['textfield']['txtCandName[0]'] = "#{candidate['firstName']} #{candidate['lastName']}"

      data_main['textfield']['txtOfficeDistrict[0]'] = "#{@committee['office']}, #{@committee['district']}"

      data_main['textfield']['txtCandAddress[0]'] = "#{candidate['address']}, #{candidate['city']}, #{candidate['state']}, #{candidate['country']}"
      data_main['textfield']['txtCandPhone[1]'] = candidate['email']
      data_main['textfield']['txtCandPhone[0]'] = candidate['phoneNumber']
    end

    def generate_committee
      data_main['textfield']['txtCommName[0]'] = @committee['name']

      treasurer = @users.select { |user| user['position'] == 'Treasurer' }.first

      data_main['textfield']['txtTreasurer[0]'] = "#{treasurer['firstName']} #{treasurer['lastName']}"

      data_main['textfield']['txtCommAddress[0]'] = "#{@committee['address']}, #{@committee['city']}, #{@committee['state']}, #{@committee['country']}"
      data_main['textfield']['txtCandPhone[2]'] = @committee['email']
      data_main['textfield']['txtCommPhone[0]'] = @committee['phoneNumber']
    end

    def generate_summary
      last_balance = Money.new(0)
      unless @last_report.nil?
        last_balance = @last_report.ending_balance
      end

      data_main['textfield']['txtBegBal[0]'] = last_balance.format

      positive = Money.new(0)
      @receipts.each { |receipt| positive += receipt.amount }
      data_main['textfield']['txtSumReceipts[0]'] = positive.format

      data_main['textfield']['txtSubtotal[0]'] = (positive + last_balance).format

      negative = Money.new(0)
      @expenditures.each { |expenditure| negative += expenditure.amount }
      data_main['textfield']['txtSumExpenditures[0]'] = negative.format

      data_main['textfield']['txtEndBal[0]'] = (positive + last_balance - negative).format

      total = Money.new(0)
      @in_kinds.each { |in_kind| total += in_kind.value }
      data_main['textfield']['txtSumInKinds[0]'] = total.format

      total = Money.new(0)
      @liabilities.each { |liability| total += liability.amount }
      data_main['textfield']['txtSumLiabilities[0]'] = total.format

      data_main['textfield']['txtCommBank[0]'] = @committee['bank']
    end

    def generate_receipts
      @receipts.select { |receipt| receipt.amount_cents > 5000 }[0..(@@RECEIPTS - 1)].each_with_index { |receipt, i|
        data_main['textfield']["dtRecDate#{i + 1}[0]"] = receipt.date_received.strftime('%m/%d/%Y')
        data_main['textfield']["txtRecNameAddress#{i + 1}[0]"] = "#{receipt.name}\n#{receipt.address}, #{receipt.city}, #{receipt.state}, #{receipt.country}"
        data_main['textfield']["txtRecAmount#{i + 1}[0]"] = receipt.amount.format
        data_main['textfield']["txtRecOccEmp#{i + 1}[0]"] = "#{receipt.occupation}\n#{receipt.employer}"
      }

      over_50 = Money.new(0)
      @receipts.each { |receipt| 
        if receipt.amount_cents > 5000
          over_50 += receipt.amount
        end
      }
      data_main['textfield']['txtItemizedRec1[0]'] = over_50.format
      data_main['textfield']['txtItemizedRec2[0]'] = over_50.format

      under_50 = Money.new(0)
      @receipts.each { |receipt|
        if receipt.amount_cents <= 5000
          under_50 += receipt.amount
        end
      }
      data_main['textfield']['txtUnitemizedRec1[0]'] = under_50.format
      data_main['textfield']['txtUnitemizedRec2[0]'] = under_50.format

      total = Money.new(0)
      @receipts.each { |receipt| total += receipt.amount }
      data_main['textfield']['txtTotalRec1[0]'] = total.format
      data_main['textfield']['txtTotalRec2[0]'] = total.format
    end

    def generate_expenditures
      @expenditures.select { |expenditure| expenditure.amount_cents > 5000 }[0..(@@EXPENDITURES - 1)].each_with_index { |expenditure, i|
        data_main['textfield']["dtExpDate#{i + 1}[0]"] = expenditure.date_paid.strftime('%m/%d/%Y')
        data_main['textfield']["txtVendor#{i + 1}[0]"] = expenditure.paid_to
        data_main['textfield']["txtVendorAddress#{i + 1}[0]"] = "#{expenditure.address}, #{expenditure.city}, #{expenditure.state}, #{expenditure.country}"
        data_main['textfield']["txtExpPurpose#{i + 1}[0]"] = expenditure.purpose
        data_main['textfield']["txtExpAmount#{i + 1}[0]"] = expenditure.amount.format
      }

      over_50 = Money.new(0)
      @expenditures.each { |expenditure| 
        if expenditure.amount_cents > 5000
          over_50 += expenditure.amount
        end
      }
      data_main['textfield']['txtItemizedExp1[0]'] = over_50.format
      data_main['textfield']['txtItemizedExp2[0]'] = over_50.format

      under_50 = Money.new(0)
      @expenditures.each { |expenditure|
        if expenditure.amount_cents <= 5000
          under_50 += expenditure.amount
        end
      }
      data_main['textfield']['txtUnitemizedExp1[0]'] = under_50.format
      data_main['textfield']['txtUnitemizedExp2[0]'] = under_50.format

      total = Money.new(0)
      @expenditures.each { |expenditure| total += expenditure.amount }
      data_main['textfield']['txtTotalExp1[0]'] = total.format
      data_main['textfield']['txtTotalExp2[0]'] = total.format
    end

    def generate_in_kinds
      # TODO: In kinds/liabilities over this number???
      @in_kinds.select { |in_kind| in_kind.value_cents > 5000 }[0..(@@IN_KINDS - 1)].each_with_index { |in_kind, i|
        data_main['textfield']["dtIkDate#{i + 1}[0]"] = in_kind.date_received.strftime('%m/%d/%Y')
        data_main['textfield']["txtIkName#{i + 1}[0]"] = in_kind.from_whom
        data_main['textfield']["txtIkAddress#{i + 1}[0]"] = "#{in_kind.address}, #{in_kind.city}, #{in_kind.state}, #{in_kind.country}"
        data_main['textfield']["txtIkDescription#{i + 1}[0]"] = in_kind.description
        data_main['textfield']["txtIkValue#{i + 1}[0]"] = in_kind.value.format
      }

      over_50 = Money.new(0)
      @in_kinds.each { |in_kind| 
        if in_kind.value_cents > 5000
          over_50 += in_kind.value
        end
      }
      data_main['textfield']['txtItemizedIk[0]'] = over_50.format

      under_50 = Money.new(0)
      @in_kinds.each { |in_kind|
        if in_kind.value_cents <= 5000
          under_50 += in_kind.value
        end
      }
      data_main['textfield']['txtUnitemziedIk[0]'] = under_50.format

      total = Money.new(0)
      @in_kinds.each { |in_kind| total += in_kind.value }
      data_main['textfield']['txtTotalIk[0]'] = total.format
    end

    def generate_liabilities
      @liabilities[0..(@@LIABILITIES - 1)].each_with_index { |liability, i|
        data_main['textfield']["dtLiabDate#{i + 1}[0]"] = liability.date_incurred.strftime('%m/%d/%Y')
        data_main['textfield']["txtLiabName#{i + 1}[0]"] = liability.to_whom
        data_main['textfield']["txtLiabAddress#{i + 1}[0]"] = "#{liability.address}, #{liability.city}, #{liability.state}, #{liability.country}"
        data_main['textfield']["txtLiabPurpose#{i + 1}[0]"] = liability.purpose
        data_main['textfield']["txtLiabAmount#{i + 1}[0]"] = liability.amount.format
      }

      total = Money.new(0)
      @liabilities.each { |liability| total += liability.amount }
      data_main['textfield']['txtTotalLiab[0]'] = total.format
    end

    def generate_schA_addon
      if @receipts.length < @@RECEIPTS
        return
      end

      over_50 = @receipts.select { |receipt| receipt.amount_cents > 5000 }
      for i in 1..(1 + @receipts.length / @@RECEIPTS)
        data_ma["schA_add_on-#{i}"] = Hash.new
        data_ma["schA_add_on-#{i}"]['textfield'] = Hash.new

        data_ma["schA_add_on-#{i}"]['textfield']['txtCommName1[0]'] = @committee['name']
        data_ma["schA_add_on-#{i}"]['textfield']['txtPageNumber1[0]'] = "#{@pages + 1}"
        data_ma["schA_add_on-#{i}"]['textfield']['txtCommName2[0]'] = @committee['name']
        data_ma["schA_add_on-#{i}"]['textfield']['txtPageNumber2[0]'] = "#{@pages + 2}"

        @pages += 2

        over_50_total = Money.new(0)
        @receipts.each { |receipt| 
          if receipt.amount_cents > 5000
            over_50_total += receipt.amount
          end
        }
        data_ma["schA_add_on-#{i}"]['textfield']['txtItemizedRec1[0]'] = over_50_total.format
        data_ma["schA_add_on-#{i}"]['textfield']['txtItemizedRec2[0]'] = over_50_total.format

        under_50_total = Money.new(0)
        @receipts.each { |receipt|
          if receipt.amount_cents <= 5000
            under_50_total += receipt.amount
          end
        }
        data_ma["schA_add_on-#{i}"]['textfield']['txtUnitemizedRec1[0]'] = under_50_total.format
        data_ma["schA_add_on-#{i}"]['textfield']['txtUnitemizedRec2[0]'] = under_50_total.format

        total = Money.new(0)
        @receipts.each { |receipt| total += receipt.amount }
        data_ma["schA_add_on-#{i}"]['textfield']['txtTotalRec1[0]'] = total.format
        data_ma["schA_add_on-#{i}"]['textfield']['txtTotalRec2[0]'] = total.format

        for j in 0..@@RECEIPTS
          receipt = over_50[j + i * @@RECEIPTS - 1]

          if receipt.nil?
            return
          end

          data_ma["schA_add_on-#{i}"]['textfield']["dtRecDate#{j + 1}[0]"] = receipt.date_received.strftime('%m/%d/%Y')
          data_ma["schA_add_on-#{i}"]['textfield']["txtRecNameAddress#{j + 1}[0]"] = "#{receipt.name}\n#{receipt.address}, #{receipt.city}, #{receipt.state}, #{receipt.country}"
          data_ma["schA_add_on-#{i}"]['textfield']["txtRecAmount#{j + 1}[0]"] = receipt.amount.format
          data_ma["schA_add_on-#{i}"]['textfield']["txtRecOccEmp#{j + 1}[0]"] = "#{receipt.occupation}\n#{receipt.employer}"
        end
      end
    end

    def generate_schB_addon
      if @expenditures.length < @@EXPENDITURES
        return
      end

      over_50 = @expenditures.select { |expenditure| expenditure.amount_cents > 5000 }
      for i in 1..(1 + @expenditures.length / @@EXPENDITURES)
        data_ma["schB_add_on-#{i}"] = Hash.new
        data_ma["schB_add_on-#{i}"]['textfield'] = Hash.new

        data_ma["schB_add_on-#{i}"]['textfield']['txtCommName1[0]'] = @committee['name']
        data_ma["schB_add_on-#{i}"]['textfield']['txtPageNumber1[0]'] = "#{@pages + 1}"
        data_ma["schB_add_on-#{i}"]['textfield']['txtCommName2[0]'] = @committee['name']
        data_ma["schB_add_on-#{i}"]['textfield']['txtPageNumber2[0]'] = "#{@pages + 2}"

        @pages += 2

        over_50_total = Money.new(0)
        @expenditures.each { |expenditure| 
          if expenditure.amount_cents > 5000
            over_50_total += expenditure.amount
          end
        }
        data_ma["schB_add_on-#{i}"]['textfield']['txtItemizedExp1[0]'] = over_50_total.format
        data_ma["schB_add_on-#{i}"]['textfield']['txtItemizedExp2[0]'] = over_50_total.format

        under_50_total = Money.new(0)
        @expenditures.each { |expenditure|
          if expenditure.amount_cents <= 5000
            under_50_total += expenditure.amount
          end
        }
        data_ma["schB_add_on-#{i}"]['textfield']['txtUnitemizedExp1[0]'] = under_50_total.format
        data_ma["schB_add_on-#{i}"]['textfield']['txtUnitemizedExp2[0]'] = under_50_total.format

        total = Money.new(0)
        @expenditures.each { |expenditure| total += expenditure.amount }
        data_ma["schB_add_on-#{i}"]['textfield']['txtTotalExp1[0]'] = total.format
        data_ma["schB_add_on-#{i}"]['textfield']['txtTotalExp2[0]'] = total.format

        for j in 0..@@EXPENDITURES
          expenditure = over_50[j + i * @@EXPENDITURES - 1]

          if expenditure.nil?
            return
          end


          data_ma["schB_add_on-#{i}"]['textfield']["dtExpDate#{j + 1}[0]"] = expenditure.date_paid.strftime('%m/%d/%Y')
          data_ma["schB_add_on-#{i}"]['textfield']["txtVendor#{j + 1}[0]"] = expenditure.paid_to
          data_ma["schB_add_on-#{i}"]['textfield']["txtVendorAddress#{j + 1}[0]"] = "#{expenditure.address}, #{expenditure.city}, #{expenditure.state}, #{expenditure.country}"
          data_ma["schB_add_on-#{i}"]['textfield']["txtExpPurpose#{j + 1}[0]"] = expenditure.purpose
          data_ma["schB_add_on-#{i}"]['textfield']["txtExpAmount#{j + 1}[0]"] = expenditure.amount.format
        end
      end
    end
  end
end