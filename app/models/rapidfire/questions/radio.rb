module Rapidfire
  module Questions
    class Radio < Select
      include Rapidfire::QuestionHelper
      validate :answer_options_presence
    end
  end
end
