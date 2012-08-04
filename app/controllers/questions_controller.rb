class QuestionsController < ApplicationController
  before_filter :authenticate_user! , :except => :index

  def index
  end

  def new
    @que = Question.new
  end
end
