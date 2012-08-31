class ModeratorsController < SymposiumBaseController
  before_filter :is_moderator, :except => [:index]
  def index
  end

  def new
  end

  def model_class_name; "User" end

  def retrieve_inst
    protect_against_missing do
      @inst = User.moderator.find params[:id]
    end
  end

  def dashboard
    params[:page] ||= 1
    @tags = @inst.moderated_tags.paginate :page => params[:page]
    if params.has_key? :main_tag_id
      @main_tag = Tag.find params[:main_tag_id]
    else
      @main_tag = @tags[0]
    end

    @flagged_questions = Question
      .includes(:opinions, :tags)
      .where(:opinions => {:optype => "flag"}, :tags => {:id => @main_tag.id})

    @flagged_answers = Answer
      .includes(:opinions, :question => [:tags])
      .where(:opinions => { :optype => "flag" },
             :question => { :tags => {:id => @main_tag.id }}
             )
  end

  private

  def is_moderator
    @inst.role == "moderator"
  end
end
