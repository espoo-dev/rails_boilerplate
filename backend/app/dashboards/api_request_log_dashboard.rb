# frozen_string_literal: true

require "administrate/base_dashboard"

class ApiRequestLogDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String,
    deleted_at: Field::DateTime,
    duration_ms: Field::Number,
    ended_at: Field::DateTime,
    endpoint: Field::String,
    headers: Field::String.with_options(searchable: false),
    http_method: Field::String,
    payload: Field::String.with_options(searchable: false),
    response: Field::String.with_options(searchable: false),
    response_code: Field::Number,
    started_at: Field::DateTime,
    summary: Field::Text,
    user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    user
    endpoint
    http_method
    payload
    response
    response_code
    created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    user
    endpoint
    headers
    http_method
    payload
    response
    response_code
    started_at
    deleted_at
    duration_ms
    ended_at
    created_at
    updated_at
    summary
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    deleted_at
    duration_ms
    ended_at
    endpoint
    headers
    http_method
    payload
    response
    response_code
    started_at
    user
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how api request logs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(api_request_log)
  #   "ApiRequestLog ##{api_request_log.id}"
  # end
end
