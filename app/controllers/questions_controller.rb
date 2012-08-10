class QuestionsController < ApplicationController
  before_filter :authenticate_user! , :except => [:index, :show]
  authorize_actions_for Question, :except => [:index, :show]
  respond_to :json, :html

  def index
    params[:page] = 1 unless params.has_key? :page

    @questions = Question
    if params.has_key? :tags
      tags = params[:tags].split(",")
      len = tags.length
      [1...len].each do |i|
        tags[i] = tags[i].strip
      end
      @questions = @questions.where :tags => {:name => tags}
    end

    @questions = @questions.paginate :page => params[:page]
    respond_with @questions
  end

  def new
    @que = Question.new
  end

  def show
    @que = Question.find params[:id]
    respond_with @que
  end

  def create
    @que = Question.new params[:question]
    @que.creator = current_user
    @que.save
    redirect_to :action => :show, :id => @que.id
  end

  def destroy
    print "hello world"
  end

  def edit
  end
end
