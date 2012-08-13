class AnswersController < ApplicationController
  before_filter :authenticate_user! , :except => [:show]
  authorize_actions_for Answer, :except => [:index, :show]
  respond_to :json, :html

  def new
    print params.to_json
    return unless protect_against_missing :question_id do
      @que = Question.find params[:question_id]
    end
    @ans = @que.answers.build
  end

  def create
    declare_not_found unless params.has_key? :answer and
      params.has_key? :question_id
    return unless protect_against_missing :question_id do
      @que = Question.find params[:question_id]
    end
    @ans = @que.answers.build params[:answer]
    @ans.creator = current_user
    if @ans.save
      respond_to do |format|
        format.html {
          flash[:success] = "Creation successful"
          redirect_to :action => :show, :id => @ans.id
        }
        format.json {
          render :json => @ans
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Creation failed"
          redirect_to :action => :edit, :id => @ans.id
        }
        format.json {
          render :json => {:error => "Creation failed"}, :status => 500
        }
      end
    end
  end
end
