# frozen_string_literal: true

# spec/models/acts_as_paranoid_factories_spec.rb
require "rails_helper"

RSpec.describe "ApplicationRecord" do
  FactoryBot.factories.each do |factory|
    it_behaves_like "acts_as_paranoid", factory.build_class
  end
end
