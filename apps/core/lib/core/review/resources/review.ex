defmodule Core.Review.Review do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :image, :ci_string, allow_nil?: false, default: "/images/default/review.webp"
    attribute :name, :ci_string, allow_nil?: false
    attribute :score, :integer, allow_nil?: false
    attribute :contents, {:array, :string}, allow_nil?: false, default: []
    timestamps(allow_nil?: false)
  end

  relationships do
    belongs_to :writer, Core.Account.User do
      api Core.Account
      allow_nil? false
    end

    has_many :tags_join_assoc, Core.Review.ReviewTag

    many_to_many :tags, Core.Classification.Tag do
      api Core.Classification
      through Core.Review.ReviewTag
      source_attribute_on_join_resource :review_id
      destination_attribute_on_join_resource :tag_id
    end
  end

  actions do
    defaults [:read]

    create :create do
      primary? true
      argument :tags, {:array, :string}, allow_nil?: false, default: []
      change &Ash.Changeset.manage_relationship(&1, :writer, &2.actor, type: :append)

      change fn changeset, _context ->
        Ash.Changeset.manage_relationship(
          changeset,
          :tags,
          changeset
          |> Ash.Changeset.get_argument(:tags)
          |> Enum.map(&%{name: &1}),
          on_lookup: :relate,
          on_no_match: :create,
          on_match: :ignore,
          on_missing: :unrelate
        )
      end
    end
  end

  postgres do
    table "review"
    repo Core.Repo
  end

  graphql do
    type :review

    queries do
      list :reviews, :read
    end

    mutations do
      create :create_review, :create
    end
  end
end
