defmodule ExpertsWeb.PageControllerTest do
  use ExpertsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Expert Advice"
  end
end
