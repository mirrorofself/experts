defmodule Experts.EctoTag do
  @moduledoc """
  A custom ecto type for handling a list of tags in a string.
  """

  use Ecto.Type

  def type, do: {:array, :string}

  @doc """
  Converts a list of tags separated by a comma from a string to a list.
  """
  def cast(tags_string) when is_binary(tags_string) do
    tags =
      tags_string
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    {:ok, tags}
  end

  def cast(_), do: :error

  @doc """
  Joins a list of tags into a string separated by a comma.
  """
  def load(tags) when is_list(tags) do
    string =
      tags
      |> Enum.join(", ")

    {:ok, string}
  end

  @doc """
  Checks that all elements in a list are strings.
  """
  def dump(tags) when is_list(tags) do
    case Enum.all?(tags, &is_binary/1) do
      true -> {:ok, tags}
      false -> :error
    end
  end

  def dump(_), do: :error
end
