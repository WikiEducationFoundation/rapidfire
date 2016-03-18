module Rapidfire
  module QuestionHelper
    def answer_options_presence
      if answer_options.empty? && course_data_type.nil? || answer_options.empty? && course_data_type.empty?
        errors.add(:answer_options, "Answer Options are required unless data is specified")
      end
    end
  end
end
