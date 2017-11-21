require "spec_helper"

describe Lita::Handlers::SmtpMailer, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }

  subject { described_class.new(robot) }
  
  describe ':send_email' do
    it { is_expected.to route("Lita email 2") }
    it { is_expected.to route("Lita email    22") }
    it { is_expected.to route("Lita email 4") }

    it { is_expected.to_not route("Lita email two") }
    it { is_expected.to_not route("Lita email 1e4") }

    it 'succeeds' do
      result = subject.deliver_email(to_address: 'dpritchett@gmail.com', message_body: 'hello daniel')
      result.error_status == nil
    end

    it 'emails numbers' do
      send_message 'Lita email 2'
      expect(replies.last).to eq('2 + 2 = 4')
    end
  end
end
