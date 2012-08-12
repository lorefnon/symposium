class ApplicationController < ActionController::Base
  protect_from_forgery

  def model_class; controller_name.classify.constantize end

  # xhr_content, flash_type, flash_content, redir_config, json_status, json_hash
  def respond_to_all config
    respond_to do |format|
      format.html {
        if config.has_param? :xhr_content and request.xhr?
          render :text => config[:xhr_content]
          return
        end
        if config.has_param? :flash_content
          flash[config[:flash_type]] = config[:flash_content]
        end
      }

      if config.has_param? :json_hash
        json_response = { :json => config[:json_hash] }
        json_response[:status] = config[:status] if config.has_param? :status
        format.json {
          render json_response
        }
      end
    end
  end

  def retrieve_inst
    protect_against_missing do
      @inst = model_class.find params[:id]
    end
  end

  def protect_against_missing
    unless params.has_key? :id
      declare_not_found
      return false
    end
    begin
      yield
    rescue ActiveRecord::RecordNotFound, NameError
      declare_not_found
      return false
    end
    true
  end

  def declare_not_found
    decl_str = "We couldn't find what you were looking for";
    respond_to_all({
      :xhr_content => "<div class='alert alert-error'>#{decl_str}</div>",
      :flash_type => :error,
      :flash_content => "#{decl_str} Why not try finding by name ?",
      :redir_config => { :action => :index },
      :status => :not_found,
      :json_hash => {:error => "#{decl_str}"}
    })
  end

  def show
    if retrieve_inst then respond_with @inst else declare_not_found end
  end

  def edit
    declare_not_found unless retrieve_inst
    authorize_action_for @inst
  end

  def update
    declare_not_found unless retrieve_inst
    authorize_action_for @inst
    if @inst.update_attributes params[self.class.name.downcase.to_sym]
      respond_to_all({
                       :flash_type => :success,
                       :flash_content => "Question was submitted",
                       :redir_config => { :action => :show },
                       :json_hash => @inst.to_json
                     })
    else
      respond_to_all({
                       :flash_type => :error,
                       :flash_content => "Update failed",
                       :redir_content => { :action => :edit },
                       :status => 500,
                       :json_hash => {
                         :error => "Update failed",
                         :details => @inst.errors
                       }
                     })
    end
  end
end
