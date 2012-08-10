module QuestionsHelper
  def qbox que
    render :partial => "questions/qbox", :locals => {:que => que}
  end
end
