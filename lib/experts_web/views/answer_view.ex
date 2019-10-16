defmodule ExpertsWeb.AnswerView do
  use ExpertsWeb, :view

  alias Experts.Posts.Answer

  def can_manage?(conn, %Answer{} = answer) do
    Pow.Plug.current_user(conn).id == answer.user.id
  end
end
