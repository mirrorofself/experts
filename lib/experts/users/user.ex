defmodule Experts.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  @moduledoc """
  A schema for users.
  """

  schema "users" do
    field :name, :string

    pow_user_fields()

    timestamps()
  end

  @doc false
  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:name])
    |> Ecto.Changeset.validate_required([:name])
  end
end
