require 'mail'
require 'pry'

module Lita
  module Handlers
    class SmtpMailer < Handler
      # insert handler code here

      Lita.register_handler(self)

      def deliver_mail(to_adddress:, message_body:)
        options = { :address              => "smtp.gmail.com",
                    :port                 => 587,
#                    :domain               => 'your.host.name',
                    :user_name            => 'dpritchett@gmail.com',
                    :password             => ENV.fetch('SMTP_PASSWORD'),
                    :authentication       => 'plain',
                    :enable_starttls_auto => true  }



        Mail.defaults do
          delivery_method :smtp, options
        end

        result = Mail.deliver do
          to to_address
          from 'dpritchett@gmail.com'
          subject 'testing sendmail'
          body message_body
        end
      end

      def send_email(response)
        binding.pry

        result = deliver_email to_adddress: 'dpritchett@gmail.com', message_body: 'testing sendmail'
        response.reply 'OK'
      end

      route /^email\s+(\d+)$/i,
        :send_email,
        command: true,
        help: { 'email N' => 'prints N + N' }


      def double(response)
        n = response.matches.first.first
        n = Integer(n)

        response.reply "#{n} + #{n} = #{n+n}"
      end
    end
  end
end
