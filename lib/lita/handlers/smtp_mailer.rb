require 'mail'
require 'pry'

module Lita
  module Handlers
    class SmtpMailer < Handler
      Lita.register_handler(self)

      route /^email\s+(\d+)$/i,
        :send_email,
        command: true,
        help: { 'email N' => 'prints N + N' }

      def deliver_email(to_address:, message_body:)
        options = { :address              => "smtp.gmail.com",
                    :port                 => 587,
                    :user_name            => 'dpritchett@gmail.com',
                    :password             => ENV.fetch('SMTP_PASSWORD'),
                    :authentication       => 'plain',
                    :enable_starttls_auto => true  }



        Mail.defaults do
          delivery_method :smtp, options
        end

        result = Mail.deliver do
          to to_address
          from to_address
          subject 'testing sendmail'
          body message_body
        end
      end

      def send_email(response)
        result = deliver_email to_address: 'dpritchett@gmail.com', message_body: 'testing sendmail'
        response.reply 'OK'
      end
    end
  end
end
