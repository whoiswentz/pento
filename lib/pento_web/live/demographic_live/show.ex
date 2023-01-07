defmodule PentoWeb.DemographicLive.Show do
  use Phoenix.Component
  use Phoenix.HTML

  def details(assigns) do
    ~H"""
    <div class="survey-component-container">
      <h2>Demographic <%= raw "&#x2713;" %></h2>
      <ul>
        <li>Gender: <%= @demographic.gender %></li>
        <li>Education: <%= @demographic.education %></li>
        <li>Year of birth: <%= @demographic.year_of_birth %></li>
      </ul>
    </div>
    """
  end
end
