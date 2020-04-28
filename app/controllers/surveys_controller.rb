class SurveysController < RespondentController
  before_action :require_respondent!
  before_action :set_survey, only: [:show, :thank_you]

  # # GET /surveys
  # def index
  #   @surveys = Survey.all
  # end

  # GET /surveys/1
  def show
    return redirect_to(survey_step_path(1)) unless params.has_key?(:step) && (1..7).include?(params[:step].to_i)

    render params[:step]
  end

  # # GET /surveys/new
  # def new
  #   @survey = Survey.new
  # end

  # # GET /surveys/1/edit
  # def edit
  # end

  # # POST /surveys
  # def create
  #   @survey = Survey.new(survey_params)

  #   if @survey.save
  #     redirect_to @survey, notice: 'Survey was successfully created.'
  #   else
  #     render :new
  #   end
  # end

  # # PATCH/PUT /surveys/1
  # def update
  #   if @survey.update(survey_params)
  #     redirect_to @survey, notice: 'Survey was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # # DELETE /surveys/1
  # def destroy
  #   @survey.destroy
  #   redirect_to survey_url, notice: 'Survey was successfully destroyed.'
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = current_respondent.survey
      @organization = current_respondent.organization
    end

    # Only allow a trusted parameter "white list" through.
    def survey_params
      params.require(:survey).permit(:data)
    end
end
