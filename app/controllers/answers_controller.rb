class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @ask = Ask.find(params[:ask_id])
  end

  def edit
  end

  def create
    @ask = Ask.find(answer_params[:ask_id])
    if @ask.answered?
      flash[:error] = "Error: sorry, that request has already been answered"
      redirect_to root_path
    else
      @answer = @ask.build_answer(answer_params)

      if valid_recaptcha? && @answer.save
        if @ask.type == "MentorAsk"
          redirect_to thank_you_mentor_path
        else
          redirect_to thank_you_pair_answer_path
        end
      else
        render action: 'new'
      end
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer, notice: 'Answer was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @answer.destroy
      redirect_to answers_url
  end

  private

    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:name, :email, :ask_id)
    end
    
    def valid_recaptcha?
      verify_recaptcha(model: @answer,
                       message: "Captcha verification failed, please try again")
    end

end
