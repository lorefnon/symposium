module OpinionsHelper
  def opinion_box target
    already_upvoted = target.upvoters.include? current_user
    already_downvoted = target.downvoters.include? current_user
    already_voted = already_upvoted or already_downvoted

    locals = {
      :target => target,
      :upvote_count => Opinion.upvote.for(target).length,
      :downvote_count => Opinion.downvote.for(target).length,
      :upvote_title => "Upvote this answer",
      :downvote_title => "Downvote this answer",
      :upvote_class => "",
      :downvote_class => ""
    }

    if not user_signed_in?
      locals[:upvote_title] = "You need to login to " + locals[:upvote_title]
      locals[:downvote_title] = "You need to login to " + locals[:downvote_title]
      locals[:upvote_class] = "disabled"
      locals[:downvote_class] = "disabled"
    elsif already_upvoted
      locals[:upvote_title] = "Undo Upvote"
      locals[:upvote_class] = "chosen"
    elsif already_downvoted
      locals[:downvote_title] = "Undo Downvote"
      locals[:downvote_class] = "chosen"
    end

    render :partial => "opinions/opinion_box", :locals => locals
  end
end
