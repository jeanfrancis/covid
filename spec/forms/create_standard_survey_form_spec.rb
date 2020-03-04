require 'rails_helper'

RSpec.describe CreateStandardSurveyForm, type: :model do

  let(:patient) { create :patient }

  let(:attributes) do
    {
      patient: patient
    }
  end

  let(:form)        { CreateStandardSurveyForm.new(attributes) }
  let(:otp)         { 'otp' }

  before(:each) do
    allow(SendSms).to receive(:call)
    allow(patient).to receive(:generate_otp).and_return(otp)
  end

  context 'with valid attributes' do
    it 'creates a StandardSurvey' do
      expect {
        form.submit
      }.to change(StandardSurvey, :count).by(1)

      standard_survey = form.standard_survey

      expect(standard_survey.patient).to eq patient

      sms_message = "Bonjour, merci de remplir votre questionnaire de suivi : http://localhost:3000/standard_surveys/#{standard_survey.public_token}/edit?otp=#{otp}"

      expect(SendSms).to have_received(:call).with(patient.cellphone_number, sms_message).once
    end

    context 'with a full attributes patient' do
      let(:patient) { create :patient, last_name: "Depaulis", gender: "male" }

      it 'creates a StandardSurvey' do
        form.submit

        standard_survey = form.standard_survey

        sms_message = "Bonjour Mr Depaulis, merci de remplir votre questionnaire de suivi : http://localhost:3000/standard_surveys/#{standard_survey.public_token}/edit?otp=#{otp}"

        expect(SendSms).to have_received(:call).with(patient.cellphone_number, sms_message).once
      end

    end
  end

  context 'when patient is missing' do
    let(:patient) { nil }

    it 'prevents the creation' do
      expect {
        form.submit
      }.to_not change(StandardSurvey, :count)

      expect(SendSms).to_not have_received(:call)
    end
  end
end
