require "spec_helper"

describe Lita::Handlers::SmtpMailer, lita_handler: true do
  let(:robot) { Lita::Robot.new(registry) }

  subject { described_class.new(robot) }

  describe ':send_email' do
    it { is_expected.to route("Lita email dpritchett@gmail.com Hi daniel from lita tests") }
    it { is_expected.to route("Lita email dpritchett@gmail.com hello") }

    it { is_expected.to_not route("Lita email daniel") }
    it { is_expected.to_not route("Lita email dpritchett@gmail.com") }

    it 'emails numbers' do
      send_message 'Lita email dpritchett@gmail.com Hi daniel from lita tests'
      expect(replies.last.include?('dpritchett@gmail.com')).to be_truthy
    end
  end

  describe ':configure_smtp!' do
    before { subject.configure_smtp! }
    let(:settings) { Mail.delivery_method.settings }

    it 'should set a password' do
      expect(settings.fetch(:port)).to_not be_nil
    end

    it 'should set a port' do
      expect(settings.fetch(:port)).to eq(587)
    end
  end

  describe ':deliver_email smtp method' do
    it 'succeeds' do
      result = subject.deliver_email(to_address: 'dpritchett@gmail.com', message_body: 'hello daniel')
      result.error_status == nil
    end

    it 'is configured to raise exceptions on delivery failure' do
      result = subject.deliver_email(
        to_address: 'dpritchett+test_lita@gmail.com',
        message_body: 'hello from lita test')

      expect(result.raise_delivery_errors).to be_truthy
    end
  end
end
