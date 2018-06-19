class MailController < ApplicationController
    include Request
    include Authenticatable
    before_action :authenticate

    def send_to_contacts
        emails = []
        Contact.all.map { |contact|
            emails << contact
            token = Rails.application.message_verifier(:unsubscribe).generate(contact.id)

            substituted_subject = params[:subject].gsub('[FIRST_NAME]', contact.first_name)
            substituted_subject = substituted_subject.gsub('[LAST_NAME]', contact.last_name)

            processed_body = params[:body].gsub('[FIRST_NAME]', contact.first_name)
            processed_body = processed_body.gsub('[LAST_NAME]', contact.last_name)
            processed_body = processed_body.gsub('[TOKEN]', token.to_s)

            data = post("#{Rails.application.secrets.mailer_api}/campaign", { email: contact.email, subject: substituted_subject, body: processed_body })

            if data['status'].to_i >= 400
                render_error(data['error'])
            end
        }

        render_success
    end
end
