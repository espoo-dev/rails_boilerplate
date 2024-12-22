# frozen_string_literal: true

require "csv"

module HandleFileHelper
  def rows_to_json(file)
    file_parsed = parse_csv(file)
    build_response(file_parsed)
  end

  def parse_csv(file)
    CSV.parse(file.read)
  end

  def encode_string(string)
    string.force_encoding("ISO-8859-1").encode("UTF-8")
  end

  def build_response(parsed_file)
    json_response = {}
    parsed_file.each_with_index do |row, index|
      json_response["row_#{index + 1}"] = encode_string(row.join(","))
    end

    json_response
  end
end
