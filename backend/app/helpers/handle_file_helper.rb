# frozen_string_literal: true
require 'csv'

module HandleFileHelper
  def set_rows_to_json(file)
    file_parsed = parse_file_csv(file)
    set_response(file_parsed)
  end

  def parse_file_csv(file)
    CSV.parse(file.read)
  end

  def encode_string(string)
    string.force_encoding("ISO-8859-1").encode("UTF-8")
  end

  def set_response(parsed_file)
    json_response = {}
    parsed_file.each_with_index { |row,index| json_response.merge!("row_#{index + 1}": encode_string(row.join(','))) }

    json_response
  end
end
