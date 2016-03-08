module Rapidfire
  module Questions
    class RangeInput < Rapidfire::Question
      validate :range_attributes
      

      def options
        answer_options.split(Rapidfire.answers_delimiter)
      end

      def validate_answer(answer)
        super(answer)

        if rules[:presence] == "1" || answer.answer_text.present?
          gt_or_lt = {}
          if rules[:greater_than_or_equal_to].present?
            gt_or_lt[:greater_than_or_equal_to] = rules[:greater_than_or_equal_to].to_i
          end
          
          if rules[:less_than_or_equal_to].present?
            gt_or_lt[:less_than_or_equal_to] = rules[:less_than_or_equal_to].to_i
          end

          answer.validates_numericality_of :answer_text, gt_or_lt
        end
      end

      def range_attributes
        if rules[:minimum].empty?
          errors.add(:miminum, "Please set a minimum value for range")
        end
        if rules[:maximum].empty?
          errors.add(:maximum, "Please set a maximum value for range")
        end
        if rules[:increment].empty?
          errors.add(:increment, "Please set an increment for range")
        end
      end
    end
  end
end
