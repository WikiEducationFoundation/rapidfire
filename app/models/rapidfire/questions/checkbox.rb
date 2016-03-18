module Rapidfire
  module Questions
    class Checkbox < Rapidfire::Question
      include Rapidfire::QuestionHelper
      validate :answer_options_presence

      def options
        answer_options.split(Rapidfire.answers_delimiter)
      end

      def validate_answer(answer)
        super(answer)

        if rules[:presence] == "1" || answer.answer_text.present?
          answer.answer_text.split(Rapidfire.answers_delimiter).each do |value|
            answer.errors.add(:answer_text, :invalid) unless options.include?(value)
          end
        end
      end
    end
  end
end
