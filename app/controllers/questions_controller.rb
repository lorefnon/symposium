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

  def new
    @que = Question.new
  end

  def show
    return unless protect_against_missing do
      @que = Question.find params[:id]
    end
    respond_with @que
  end

  def create
    @que = Question.new params[:question]
    @que.creator = current_user
    if @que.save
      respond_to do |format|
        format.html {
          flash[:success] = "Question created successfully"
          redirect_to :action => :show, :id => @que.id
        }
        format.json {
          render :json => @que
        }
      end
    else
      err_str = "Question could not be created"
      respond_to do |format|
        format.html {
          flash[:error] = err_str
          redirect_to :action => :edit, :id => @que.id
        }
        format.json {
          render :json => {:error => err_str}, :status => 500
        }
      end
    end
  end

  def destroy
    return unless protect_against_missing do
      @que = Question.find params[:id]
    end
    authorize_action_for @que
    if @que.destroy
      respond_to do |format|
        format.html {
          flash[:success] = "Question successfully deleted"
          redirect_to :controller => :questions, :action => :index
        }
        format.json {
          render :json => {:success => "Question deleted"}
        }
      end
    else
      err_str = "Question could not be deleted"
      respond_to do |format|
        format.html {
          flash[:error] = err_str
          redirect_to :controller => :questions, :action => :index
        }
        format.json {
          render :status => 500, :json => {:error => err_str}
        }
      end
    end
  end

  def edit
    return unless protect_against_missing do
      @que = Question.find params[:id]
    end
    authorize_action_for @que
  end

  def update
    return unless protect_against_missing do
      @que = Question.find params[:id]
    end
    authorize_action_for @que
    if @que.update_attributes params[:question]
      respond_to do |format|
        format.html {
          flash[:success] = "Question was submitted"
          redirect_to :action => :show
        }
        format.json { render :json => @que }
      end
    else
      err_str = "Question could not be updated"
      flash[:error] = err_str
      respond_to do |format|
        format.html { redirect_to :action => :edit }
        format.json { render :status => 500, :json => {
            :error => err_str,
            :details => @user.errors
          }
        }
      end
    end
  end
end
