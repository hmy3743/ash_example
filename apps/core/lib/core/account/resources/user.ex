defmodule Core.Account.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true

    timestamps(allow_nil?: false)
  end

  relationships do
    has_many :reviews, Core.Review.Review do
      api Core.Review
      destination_attribute :writer_id
    end
  end

  authentication do
    api Core.Account

    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password
        confirmation_required? false
        register_action_name :sign_up
        sign_in_action_name :sign_in
      end
    end

    tokens do
      enabled? true
      token_resource Core.Account.Token

      signing_secret fn _, _ ->
        Application.fetch_env(:core, :token_signing_secret)
      end
    end
  end

  actions do
    defaults [:read]

    read :get_by_email do
      get_by :email
    end

    read :viewer do
      manual fn _query, _, context ->
        {:ok, [context.actor]}
      end
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  postgres do
    table "user"
    repo Core.Repo
  end

  code_interface do
    define_for Core.Account
    define :read, action: :read
    define :sign_up, action: :sign_up
    define :get_by_email, action: :get_by_email, args: [:email]
  end

  graphql do
    type :user
    hide_fields([:hashed_password])

    queries do
      read_one(:user_by_email, :get_by_email)
      read_one(:viewer, :viewer, allow_nil?: false)
    end

    mutations do
      create :sign_up, :sign_up
    end
  end

  policies do
    bypass action(:sign_up) do
      authorize_if always()
    end

    bypass action(:sign_in) do
      authorize_if always()
    end

    policy always() do
      forbid_unless actor_present()
      authorize_if always()
    end
  end
end
