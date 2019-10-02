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
end
