defmodule ExpertsWeb.Router do
  use ExpertsWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", ExpertsWeb do
    pipe_through [:browser, :protected]

    resources("/questions", QuestionController)
  end

  scope "/", ExpertsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
