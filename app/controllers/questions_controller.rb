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

    @questions = @questions.paginate :page => params[:page]
    respond_with @questions
  end

end
