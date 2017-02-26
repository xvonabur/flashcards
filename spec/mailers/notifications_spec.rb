# frozen_string_literal: true
require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  describe 'pending_cards' do
    let!(:user) { create(:user) }
    let(:mail) { described_class.pending_cards(user.id) }

    it 'renders the subject' do
      expect(mail.subject).to eq('Come back! We have cookies!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['buddy@cards.com'])
    end

    it 'assigns @email for html version' do
      expect(mail.html_part.body.encoded).to match(user.email)
    end

    it 'assigns @email for text version' do
      expect(mail.text_part.body.encoded).to match(user.email)
    end
  end
end
