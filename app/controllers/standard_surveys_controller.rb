class StandardSurveysController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def edit
    @form = UpdateStandardSurveyForm.new(standard_survey: standard_survey, otp: params[:otp])
  end

  def update
    @form = UpdateStandardSurveyForm.new(standard_survey_params)
    @form.standard_survey = standard_survey

    if @form.submit
      render :update
    else
      render :edit
    end
  end

  def not_found
    render :not_found
  end

  private

    def standard_survey
      @_standard_survey = StandardSurvey.to_complete.find_by!(public_token: params[:id])
    end


    def standard_survey_params
      params.require(:update_standard_survey_form).permit(:body_temperature, :cohabitants_recent_change, :breathing_difficulty_borg_scale, :heartbeats_per_minute, :recent_chest_pain, :agreed_containment, :agreed_containment_comment, :respiratory_rate_in_cycles_per_minute, :recent_cold_chill, :otp)
    end

end