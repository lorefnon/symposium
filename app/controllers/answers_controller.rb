class AnswersController < ApplicationController
  before_filter :authenticate_user! , :except => [:show]
  def show
  end
  def new
    @que = Question.find params[:question_id]
    @ans = @que.answers.build
  end
  def create
    @ans = Answer.new params[:answer]
    @ans.question = Question.find params[:question_id]
    @ans.creator_id = current_user.id
    @ans.save
    redirect_to :controller => "questions", :action => "show", :id => params[:question_id]
  end
end
