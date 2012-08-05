class QuestionsController < ApplicationController
  before_filter :authenticate_user! , :except => :index
  respond_to :json, :html

  def index
    page = if params.has_key? :page then params[:page] else 1 end
    entries = if params.has_key? :entries then params[:entries] else 10 end
    offset = entries*(page - 1)
    @questions = Question.limit(entries).offset(offset)
    if params.has_key? :tags
      raw_tags = params[:tags].split(",")
      tags = []
      raw_tags.each do |item|
        tags.push item.strip
      end
      @questions = @questions.where :tags => {:name => tags}
    end
    respond_with @questions
  end

  def new
    @que = Question.new
  end

  def show
  end

  def create
    @que = Question.new params[:question]
    @que.creator = current_user
    if @que.save
      render :text => "Successfully submitted"
    else
      redirect_to :action => "new"
    end
  end
end
