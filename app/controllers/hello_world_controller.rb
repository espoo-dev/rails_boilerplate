class HelloWorldController < ApplicationController
  def public_method
    render plain: "This method does not need authentication"
  end
end
