require 'api_response'
require 'graph_helper_lib'
class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def check_required_parameters(*args)
    args.collect {|arg_item|
      I18n.t("errors.#{arg_item}") if params[arg_item].blank?
    }.reject(&:nil?)
  end

  def graph_parameters(collection, *args)
    args.collect {|arg_item|
      params[arg_item] = collection[arg_item]
    }.reject(&:nil?)
  end
end
