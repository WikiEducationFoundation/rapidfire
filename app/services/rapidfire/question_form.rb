module Rapidfire
  class QuestionForm < Rapidfire::BaseService
    AVAILABLE_QUESTIONS =
      [
       Rapidfire::Questions::Checkbox,
       Rapidfire::Questions::Date,
       Rapidfire::Questions::Long,
       Rapidfire::Questions::Numeric,
       Rapidfire::Questions::Radio,
       Rapidfire::Questions::Select,
       Rapidfire::Questions::Short,
       Rapidfire::Questions::Text,
       Rapidfire::Questions::RangeInput
      ]

    QUESTION_TYPES = AVAILABLE_QUESTIONS.inject({}) do |result, question|
      question_name = question.to_s.split("::").last
      result[question_name] = question.to_s
      result
    end

    attr_accessor :question_group, :question,
      :type, :question_text, :answer_options, :answer_presence,
      :answer_minimum_length, :answer_maximum_length,
      :answer_greater_than_or_equal_to, :answer_less_than_or_equal_to, :answer_grouped, :answer_grouped_question,
      :answer_range_minimum, :answer_range_maximum, :answer_range_increment, :follow_up_question_text, :conditionals

    delegate :valid?, :errors, :to => :question

    def initialize(params = {})
      from_question_to_attributes(params[:question]) if params[:question]
      super(params)
      @question ||= question_group.questions.new
    end

    def save
      @question.new_record? ? create_question : update_question
    end

    private
    def create_question
      klass = nil
      if QUESTION_TYPES.values.include?(type)
        klass = type.constantize
      else
        errors.add(:type, :invalid)
        return false
      end

      @question = klass.create(to_question_params)
    end

    def update_question
      @question.update_attributes(to_question_params)
    end

    def to_question_params
      {
        :type => type,
        :question_group => question_group,
        :question_text  => question_text,
        :answer_options => answer_options,
        :follow_up_question_text => follow_up_question_text,
        :conditionals => conditionals,
        :validation_rules => {
          :presence => answer_presence,
          :grouped => answer_grouped,
          :grouped_question => answer_grouped_question,
          :minimum  => answer_minimum_length,
          :maximum  => answer_maximum_length,
          :range_minimum  => answer_range_minimum,
          :range_maximum  => answer_range_maximum,
          :range_increment    => answer_range_increment,
          :greater_than_or_equal_to => answer_greater_than_or_equal_to,
          :less_than_or_equal_to    => answer_less_than_or_equal_to
        }
      }
    end

    def from_question_to_attributes(question)
      self.type = question.type
      self.question_group  = question.question_group
      self.question_text   = question.question_text
      self.answer_options  = question.answer_options
      self.follow_up_question_text = question.follow_up_question_text
      self.conditionals = question.conditionals
      self.answer_presence = question.rules[:presence]
      self.answer_grouped = question.rules[:grouped]
      self.answer_grouped_question = question.rules[:grouped_question]
      self.answer_minimum_length = question.rules[:minimum]
      self.answer_maximum_length = question.rules[:maximum]
      self.answer_range_minimum = question.rules[:range_minimum]
      self.answer_range_maximum = question.rules[:range_maximum]
      self.answer_range_increment = question.rules[:range_increment]
      self.answer_greater_than_or_equal_to = question.rules[:greater_than_or_equal_to]
      self.answer_less_than_or_equal_to    = question.rules[:less_than_or_equal_to]
    end
  end
end
