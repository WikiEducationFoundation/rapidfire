module Rapidfire
  class QuestionGroup < ActiveRecord::Base
    has_many  :questions, -> { order("position ASC")}
    validates :name, :presence => true

    if Rails::VERSION::MAJOR == 3
      attr_accessible :name
    end
  end

  def reorder_questions

  end
end
