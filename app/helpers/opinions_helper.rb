module OpinionsHelper
  def opinion_box target
    already_upvoted = target.upvoters.include? current_user
    already_downvoted = target.downvoters.include? current_user
    already_flagged = target.flaggers.include? current_user
    already_voted = already_upvoted or already_downvoted

    locals = {
      :target => target,
      :upvote_count => target.upvotes.length,
      :downvote_count => target.downvotes.length,
      :upvote_title => "Upvote",
      :downvote_title => "Downvote",
      :flag_title => "Flag",
      :upvote_class => "",
      :downvote_class => "",
      :upvote_method => if already_upvoted then "delete"
                        elsif already_voted then "put"
                        else "post" end,
      :downvote_method => if already_downvoted then "delete"
                          elsif already_voted then "put"
                          else "post" end,
      :flag_method => if already_flagged then "delete"
                      elsif already_voted then "put"
                      else "post" end
    }

    if not user_signed_in?
      locals[:upvote_title] = "login to " + locals[:upvote_title]
      locals[:downvote_title] = "login to " + locals[:downvote_title]
      locals[:upvote_class] = "disabled"
      locals[:downvote_class] = "disabled"
    elsif already_upvoted
      locals[:upvote_title] = "Undo Upvote"
      locals[:upvote_class] = "chosen"
    elsif already_downvoted
      locals[:downvote_title] = "Undo Downvote"
      locals[:downvote_class] = "chosen"
    elsif already_flagged
      locals[:flag_title] = "Undo flag"
    end

    render :partial => "opinions/opinion_box", :locals => locals
  end
end
