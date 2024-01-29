defmodule GraphqlWeb.Router do
  use GraphqlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GraphqlWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :graphql do
    plug :actor_from_session
    plug AshGraphql.Plug
  end

  scope "/" do
    pipe_through :graphql

    forward "/graphql", Absinthe.Plug,
      schema: Graphql.Schema,
      before_send: {__MODULE__, :graphql_before_send}

    forward "/graphiql",
            Absinthe.Plug.GraphiQL,
            schema: Graphql.Schema,
            interface: :playground,
            before_send: {__MODULE__, :graphql_before_send}
  end

  def graphql_before_send(conn, %Absinthe.Blueprint{} = blueprint) do
    if token = blueprint.execution.context[:token] do
      put_resp_cookie(conn, "auth_token", token, http_only: true)
    else
      conn
    end
  end

  def actor_from_session(conn, _opts) do
    with conn <- fetch_cookies(conn),
         token when is_binary(token) <- conn.cookies["auth_token"],
         {:ok, token} <-
           Core.Account.Token
           |> Ash.Query.for_read(:get_token, %{token: token})
           |> Core.Account.read_one(),
         {:ok, actor} <- AshAuthentication.subject_to_user(token.subject, Core.Account.User) do
      Ash.PlugHelpers.set_actor(conn, actor)
    else
      _ -> conn
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:graphql_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GraphqlWeb.Telemetry
      # forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
