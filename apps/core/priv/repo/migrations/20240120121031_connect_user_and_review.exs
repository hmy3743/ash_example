defmodule Core.Repo.Migrations.ConnectUserAndReview do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:review) do
      add :writer_id,
          references(:user,
            column: :id,
            name: "review_writer_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          null: false
    end
  end

  def down do
    drop constraint(:review, "review_writer_id_fkey")

    alter table(:review) do
      remove :writer_id
    end
  end
end