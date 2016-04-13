module Rapidfire
  module Questions
    class Select < Rapidfire::Question
      include Rapidfire::QuestionHelper
      validate :answer_options_presence

      def options
        options = answer_options.split(Rapidfire.answers_delimiter)
        options.collect { |o| o.strip }
      end

      def validate_answer(answer)
        super(answer)
        return true unless course_data_type.nil?
        if rules[:presence] == "1" || answer.answer_text.present?
          answers = answer.answer_text.split("\r\n")
          answers.map do |a|
            unless options.include?(a)
              errors.add(:answer_text, "Invalid answer option")
            end
          end
        end
      end
    end
  end
end
