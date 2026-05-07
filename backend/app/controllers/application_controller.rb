# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.is_a?(User) && resource.admin?

    super
  end
end
