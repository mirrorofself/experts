defmodule Experts.Factory do
  @moduledoc """
  Sample data factories used in tests and in the seed file.
  """

  use ExMachina.Ecto, repo: Experts.Repo
  alias Experts.Users.User
  alias Pow.Ecto.{Schema.Password}

  def user_factory do
    password_hash = Password.pbkdf2_hash("Secret123")

    %User{
      name: "Christopher Alexander",
      email: "chris@example.com",
      password_hash: password_hash
    }
  end
end
