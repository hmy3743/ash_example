defmodule Core.Review.ReviewTag do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  relationships do
    belongs_to :review, Core.Review.Review, primary_key?: true, allow_nil?: false

    belongs_to :tag, Core.Classification.Tag,
      api: Core.Classification,
      primary_key?: true,
      allow_nil?: false
  end

  postgres do
    table "review_tag"
    repo Core.Repo

    references do
      reference :review, deferrable: :initially
      reference :tag, deferrable: :initially
    end
  end

  actions do
    defaults [:create, :read, :destroy]
  end
end
