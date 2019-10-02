defmodule ExpertsWeb.PageController do
  use ExpertsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
