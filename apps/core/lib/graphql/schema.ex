defmodule Graphql.Schema do
  use Absinthe.Schema

  @apis [Core.Account, Core.Classification, Core.Review]

  use AshGraphql, apis: @apis

  query do
  end

  mutation do
    field :sign_in, type: :sign_in_result do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(fn _parent, args, _context ->
        read_user =
          Core.Account.User
          |> Ash.Query.for_read(:sign_in, args)
          |> Core.Account.read_one()

        with {:ok, user} <- read_user,
             %Core.Account.User{__metadata__: %{token: token}} <- user do
          Core.Account.Token
          |> Ash.Changeset.for_create(:store_token, %{token: token, purpose: "sign_in"})
          |> Core.Account.create!()

          {:ok, %{token: token}}
        else
          {:error, _} -> {:error, "Invalid email or password"}
        end
      end)

      middleware(fn resolution, _ ->
        case resolution.value do
          %{token: token} when is_binary(token) ->
            put_in(resolution.context[:token], token)

          _ ->
            resolution
        end
      end)
    end
  end

  object :sign_in_result do
    field(:token, non_null(:string))
  end
end
