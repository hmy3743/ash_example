defmodule Core.Classification.Tag do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id
    attribute :name, :ci_string, allow_nil?: false
  end

  relationships do
    many_to_many :reviews, Core.Review.Review do
      api Core.Review
      through Core.Review.ReviewTag
      source_attribute_on_join_resource :tag_id
      destination_attribute_on_join_resource :review_id
    end
  end

  identities do
    identity :unique_name, [:name]
  end

  actions do
    defaults [:read]
  end

  postgres do
    table "tag"
    repo Core.Repo
  end

  graphql do
    type :tag

    queries do
      list(:tags, :read)
    end
  end

  policies do
    policy always() do
      forbid_unless actor_present()
      authorize_if always()
    end
  end
end
