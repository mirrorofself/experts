defmodule ExpertsWeb.Router do
  use ExpertsWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html", "js"]
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

    resources("/questions", QuestionController, only: [:create, :edit, :update, :delete]) do
      resources("/answers", AnswerController, only: [:create])
    end

    resources("/answers", AnswerController, only: [:show, :edit, :update, :delete])
  end

  scope "/", ExpertsWeb do
    pipe_through :browser

    get "/", QuestionController, :index
    resources("/questions", QuestionController, only: [:new, :show])
  end
end
