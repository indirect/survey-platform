class SurveyInvitationsController < ApplicationController
  before_action :require_organization!
  before_action :set_survey_invitation, only: [:show, :edit, :update, :destroy]

  # GET /survey_invitations
  def index
    @survey_invitations = @organization.survey_invitations.all
  end

  # GET /survey_invitations/1
  def show
    return redirect_to(survey_invitations_path)
  end

  # GET /survey_invitations/new
  def new
    @survey_invitation = @organization.survey_invitations.new
  end

  # GET /survey_invitations/1/edit
  def edit
  end

  # POST /survey_invitations
  def create
    SurveyInvitation.transaction do
      @survey_invitation = @organization.survey_invitations.new(survey_invitation_params)

      if twilio.enabled?
        sms_message = "Gotham Public Health: Unfortunately, you have tested positive for COVID-19. Please self-isolate for 7 days or until 3 days after you are completely better.\n\nTo help us stop COVID-19, please take this 10 minute survey to tell us who you have had contact with: #{survey_url}"

        twilio.client.messages.create(
          from: twilio.phone_number,
          to: @survey_invitation.phone,
          body: sms_message
        )
      end

      if @survey_invitation.save
        redirect_to @survey_invitation, notice: "Survey invitation was successfully created."
      else
        render :new
        raise ActiveRecord::Rollback, "Survey failed to save"
      end
    end
  end

  # PATCH/PUT /survey_invitations/1
  def update
    if @survey_invitation.update(survey_invitation_params)
      redirect_to @survey_invitation, notice: 'Survey invitation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /survey_invitations/1
  def destroy
    @survey_invitation.destroy
    redirect_to survey_invitations_url, notice: 'Survey invitation was successfully destroyed.'
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_survey_invitation
    @survey_invitation = @organization.survey_invitations.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def survey_invitation_params
    params.require(:survey_invitation).permit(:name, :email, :phone)
  end

end