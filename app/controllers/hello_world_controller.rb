# frozen_string_literal: true

class HelloWorldController < ApplicationController
  before_action :authenticate_user!, only: :private_method

  def public_method
    render plain: "This method does not need authentication"
  end

  def private_method
    render plain: "This method needs authentication"
  end
end
