module Rapidfire
  class AnswerGroupBuilder < Rapidfire::BaseService
    attr_accessor :user, :question_group, :questions, :answers, :params

    def initialize(params = {})
      super(params)
      build_answer_group
    end

    def to_model
      @answer_group
    end

    def save!(options = {})
      params.each do |question_id, answer_attributes|
        if answer = @answer_group.answers.find { |a| a.question_id.to_s == question_id.to_s }
          text = answer_attributes[:answer_text]
          answer.follow_up_answer_text = answer_attributes[:follow_up_answer_text]
          # in case of checkboxes, values are submitted as an array of
          # strings. we will store answers as one big string separated
          # by delimiter.
          answer.answer_text =
            if text.is_a?(Array)
              stripped_answers = strip_checkbox_answers(text)
              stripped_answers.join(Rapidfire.answers_delimiter)
            else
              text
            end
        end
      end

      @answer_group.save!(**options)
    end

    def save(options = {})
      save!(options)
    rescue ActiveRecord::ActiveRecordError => e
      # repopulate answers here in case of failure as they are not getting updated
      @answers = @question_group.questions.collect do |question|
        @answer_group.answers.find { |a| a.question_id == question.id }
      end
      false
    end

    private
    def build_answer_group
      @answer_group = AnswerGroup.new(user: user, question_group: question_group)
      @questions = @question_group.questions.by_position
      @answers = @questions.collect do |question|
        @answer_group.answers.build(question_id: question.id)
      end
    end

    def strip_checkbox_answers(text)
      removed_empties = text.reject(&:blank?).reject { |t| t == "0" }
      removed_empties.collect { |t| t.strip }
    end
  end
end
