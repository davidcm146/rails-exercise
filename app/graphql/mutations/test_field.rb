module Mutations
  class TestField < BaseMutation
    argument :name, String, required: true

    field :message, String, null: false

    def resolve(name:)
      { message: "Hello World #{name}" }
    end
  end
end
