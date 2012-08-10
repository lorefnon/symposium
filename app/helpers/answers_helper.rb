module AnswersHelper
  def ans_box ans
    render :partial => "answers/ans_box", :locals => {:ans => ans}
  end
end
