defmodule PentoWeb.Admin.UserActivityLive do
  use PentoWeb, :live_component

  alias PentoWeb.Presence

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_user_activity()}
  end

  defp assign_user_activity(socket) do
    assign(socket, :user_activity, Presence.list_products_and_users())
  end
end
