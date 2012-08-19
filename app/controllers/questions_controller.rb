class QuestionsController < ApplicationController
  before_filter :authenticate_user! , :except => [:index, :show]
  authorize_actions_for Question, :except => [:index, :show]
  respond_to :json, :html

  def index
    params[:page] = 1 unless params.has_key? :page

    @questions = Question.includes :tags
    if params.has_key? :tags
      tags = params[:tags].split(" ")
      len = tags.length
      tags.each do |tag| tag.strip end
      @questions = @questions.where :tags => {:name => tags}
    end

    @questions = @questions.paginate(:page => params[:page]).order("created_at DESC")
    respond_with @questions
  end

  def accept_ans
    protect_against_missing(:id) do
      @inst.accepted_ans = Answer.find params[:id]
      if @inst.save
        respond_to do |format|
          format.html {
            flash[:success] = "Answer accepted"
            redirect_to :action => :show
          }
          format.json {
            render :json => @inst
          }
        end
      else
        respond_to do |format|
          format.html {
            flash[:error] = "Could not accept the answer"
            redirect_to :action => :show
          }
          format.json {
            render :json => {
              :error => "Error while accepting answer",
              :details => @inst.errors,
            }, :status => 500
          }
        end
      end
    end
  end
end
