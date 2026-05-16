defmodule PentoWeb.PageController do
  use PentoWeb, :controller

  alias Pento.Accounts.Scope

  def home(%{assigns: %{current_scope: %Scope{user: %{}}}} = conn, _params) do
    conn
    |> redirect(to: ~p"/guess")
    |> halt()
  end

  def home(conn, _params) do
    render(conn, :home)
  end
end
