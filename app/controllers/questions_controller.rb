class QuestionsController < SymposiumBaseController
  before_filter :authenticate_user! , :except => [:index, :show]
  authorize_actions_for Question, :except => [:index, :show]
  respond_to :json, :html

  def edit
    authorize_action_for @inst
    @tag_str = @inst.tags.reduce("") do |str, tag|
      str + " , " + tag.name
    end
  end

  def setup_tags
    if params.has_key? :suggested_tags
      tags = params[:suggested_tags].split(",").collect{|x| x.strip}
      tags.each do |tag_name|
        tag = Tag.where(:name => tag_name).first
        if tag.nil?
          if current_user.can_create? Tag
            @inst.tags << Tag.create({:name => tag_name, :creator => current_user})
          else
            @details ||= []
            @details.push "Creation of tag #{tag_name} was not permitted."
          end
        else
          @inst.tags << tag
        end
      end
    end
  end

  def create
    declare_not_found unless params.has_key? :question
    @inst = Question.new params[:question]
    @inst.creator = current_user
    setup_tags
    gen_creation_response @inst.save
  end

  def update
    declare_not_found unless params.has_key? :question
    authorize_action_for @inst
    setup_tags
    gen_updation_response @inst.update_attributes params[:question]
  end

  def index
    params[:page] = 1 unless params.has_key? :page

    # @questions = Question
    @questions = Question.includes :tags
    if params.has_key? :tags
      @tags = params[:tags].split(",").map{|t| t.strip}
      len = @tags.length
      @questions = @questions.where :tags => {:name => @tags}
    end

    @questions = @questions
      .paginate(:page => params[:page])
      .order("questions.created_at DESC")

    respond_with @questions
  end

  def accept_ans
    protect_against_missing(:answer_id) do
      @inst.accepted_ans = Answer.find params[:answer_id]
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
