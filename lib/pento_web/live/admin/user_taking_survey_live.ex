defmodule PentoWeb.Admin.UserTakingSurveyLive do
  alias PentoWeb.Presence
  use PentoWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_total_taking_survey_users()}
  end

  defp assign_total_taking_survey_users(socket) do
    assign(socket, :total_user_taking_survey, Presence.list_user_taking_survey())
  end
end
