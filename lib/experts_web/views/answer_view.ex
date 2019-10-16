defmodule ExpertsWeb.AnswerView do
  use ExpertsWeb, :view

  alias Experts.Posts.Answer

  def can_manage?(conn, %Answer{} = answer) do
    case Pow.Plug.current_user(conn) do
      nil -> false
      user -> user.id == answer.user.id
    end
  end
end
