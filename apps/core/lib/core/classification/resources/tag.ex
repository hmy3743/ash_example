defmodule Core.Classification.Tag do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :name, :ci_string, allow_nil?: false
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
      list :tags, :read
    end
  end
end
