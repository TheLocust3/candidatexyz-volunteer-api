class CommitteesController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    include CandidateXYZ::Concerns::Request

    before_action :authenticate
    before_action :authenticate_campaign_id
    before_action :authenticate_admin, only: [ :create, :update, :destroy ]
    before_action :authenticate_superuser, only: [ :index ]

    def index
        @committees = Committee.all

        render
    end

    def get_campaign_committee
        @committee = Committee.where( :campaign_id => @campaign_id ).first

        if @committee.nil?
            not_found
        else
            report_variables
            
            render 'show'
        end
    end

    def show
        @committee = Committee.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @committee.nil?
            not_found
        else
            report_variables

            render
        end
    end

    def create
        if Committee.where( :id => params[:id], :campaign_id => @campaign_id ).length > 0
            render_error("Can't create more than 1 committee")
            return
        end

        parameters = create_params(params)
        parameters[:campaign_id] = @campaign_id
        @committee = Committee.new(parameters)

        if @committee.save
            campaign = get("#{Rails.application.secrets.auth_api}/campaigns/#{@campaign_id}")

            report_type = Report.REPORT_TYPES[campaign['state'].downcase.to_sym].select { |report_type| report_type[:reportClass] == 'pac' && report_type[:officeType] == campaign['officeType'] && report_type[:name] == 'Creation' }.first

            report = Report.new( :report_type => report_type[:value], :official => true, :report_class => 'pac', :campaign_id => @campaign_id, :data => { :committee_id => @committee.id } )

            if report.save
                Notification.create!( :title => 'Committee formation report being processed', :body => 'Committee formation documents are being generated', :link => "/finance/reports/#{report.id}", :campaign_id => @campaign_id )

                auth_headers = {
                  uid: request.headers['uid'],
                  client: request.headers['client'],
                  'access-token': request.headers['access-token']
                }
                PACCreationReportJob.perform_later(auth_headers, report, @campaign_id)

                report_variables

                render 'show'
            else
                render_errors(report)
            end
        else
            render_errors(@committee)
        end
    end

    def update
        @committee = Committee.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @committee.update(update_params(params))
            render 'show'
        else
            render_errors(@committee)
        end
    end

    def destroy
        committee = Committee.where( :id => params[:id], :campaign_id => @campaign_id ).first

        Report.all.map { |report|
            if report.data['committee_id'] == committee.id
                report.destroy
            end
        }

        committee.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:name, :email, :phone_number, :address, :city, :state, :country, :zipcode, :office, :district, :bank)
    end

    def update_params(params)
        params.permit(:name, :email, :phone_number, :address, :city, :state, :country, :zipcode, :office, :district, :bank)
    end

    def report_variables
        @report = @committee.report
        @base_url = "https://s3.amazonaws.com/#{Rails.application.secrets.project_name}-public/reports/#{@campaign_id}"
    end
end
