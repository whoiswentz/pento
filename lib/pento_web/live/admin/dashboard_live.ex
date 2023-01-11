defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view

  alias PentoWeb.Admin.UserTakingSurveyLive
  alias PentoWeb.Admin.UserActivityLive
  alias PentoWeb.Admin.SurveyResultsLive

  alias PentoWeb.Endpoint

  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"
  @user_taking_survey_topic "user_taking_survey"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
      Endpoint.subscribe(@user_taking_survey_topic)
    end

    {
      :ok,
      socket
      |> assign(:survey_results_component_id, "survey-results")
      |> assign(:user_activity_component_id, "user-activity")
      |> assign(:user_taking_survey_component_id, "user-taking-survey")
    }
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      SurveyResultsLive,
      id: socket.assigns.survey_results_live_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", topic: @user_activity_topic}, socket) do
    send_update(
      UserActivityLive,
      id: socket.assigns.user_activity_component_id
    )

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", topic: @user_taking_survey_topic}, socket) do
    send_update(
      UserTakingSurveyLive,
      id: socket.assigns.user_taking_survey_component_id
    )

    {:noreply, socket}
  end
end
