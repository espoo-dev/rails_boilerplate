# frozen_string_literal: true

module SchoolContracts
  class Index < ApplicationContract
    params do
      required(:school_name_like).filled(:string)
    end
  end
end
