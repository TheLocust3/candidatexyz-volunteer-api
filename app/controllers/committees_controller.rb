class CommitteesController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable

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
            render 'show'
        end
    end

    def show
        @committee = Committee.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @committee.nil?
            not_found
        else
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
            report = Report.new( :report_type => 'cpf_m101_18', :official => true, :report_class => 'pac', :campaign_id => @campaign_id )

            if report.save
                auth_headers = {
                  uid: request.headers['uid'],
                  client: request.headers['client'],
                  'access-token': request.headers['access-token']
                }
                PACCreationReportJob.perform_later(auth_headers, report, @campaign_id)

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
        committee.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:name, :email, :phone_number, :address, :city, :state, :country, :office, :district, :bank)
    end

    def update_params(params)
        params.permit(:name, :email, :phone_number, :address, :city, :state, :country, :office, :district, :bank)
    end
end
