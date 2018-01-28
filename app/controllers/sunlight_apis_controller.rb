class SunlightApisController < ApplicationController
  include ProcessApiRequests
  before_action :check_valid_action, :check_valid_options

  def process_request
    process_api_request(action_param, other_params)
  end

  private

  def action_param
    params[:requestAction]
  end

  def other_params
    params[:sunlight_api].except(:requestAction)
  end

  def check_valid_action
    if VALID_ACTIONS_AND_OPTIONS.keys.exclude?(action_param)
      (render json: { message: 'Not a valid action'}, status: :not_acceptable) && return
    end
  end

  def check_valid_options
    if (VALID_ACTIONS_AND_OPTIONS[action_param] - other_params.keys).present?
      (render json: { message: 'Missing required options for actions'}, status: :not_acceptable) && return
    end
  end

end
