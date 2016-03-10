module Rapidfire
  class QuestionResult < Rapidfire::BaseService
    include ActiveModel::Serialization

    attr_accessor :question, :results, :follow_up_results

    def active_model_serializer
      Rapidfire::QuestionResultSerializer
    end
  end
end
