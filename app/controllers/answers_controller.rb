class AnswersController < ApplicationController
  before_filter :authenticate_user! , :except => [:show]
  authorize_actions_for Answer, :except => [:index, :show]
  respond_to :json, :html

  def show
    return unless protect_against_missing do
      @ans = Answer.find params[:id]
    end
    respond_with @ans
  end

  def new
    return unless protect_against_missing do
      @que = Question.find params[:question_id]
    end
    @ans = @que.answers.build
  end

  def create
    @ans = Answer.new params[:answer]

    return unless protect_against_missing do
      @ans.question = Question.find params[:question_id]
    end

    @ans.creator_id = current_user.id
    if @ans.save
      respond_to do |format|
        format.html {
          flash[:success] = "Answer added."
          redirect_to :controller => "questions", :action => "show", :id => params[:question_id]
        }
        format.json {
          render :json => @ans
        }
      end
    else
      err_str = "Answer could not be created"
      respond_to do |format|
        format.html {
          flash[:error] = err_str
          redirect_to :action => :edit, :id => @ans.id
        }
        format.json {
          render :json => {:error => err_str}, :status => 500
        }
      end
    end
  end

  def destroy
  end

  def edit
    return unless protect_against_missing do
      @ans = Answer.find params[:id]
    end
  end

  def update
    return unless protect_against_missing do
      @ans = Answer.find params[:id]
    end
    authorize_action_for @ans
    if @ans.update_attributes params[:answer]
      respond_to do |format|
        
      end
    else
  end

end
