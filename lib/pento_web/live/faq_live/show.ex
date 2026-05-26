defmodule PentoWeb.FaqLive.Show do
  use PentoWeb, :live_view

  alias Pento.FAQ

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Faq {@faq.id}
        <:subtitle>This is a faq record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/faqs"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/faqs/#{@faq}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit faq
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Question">{@faq.question}</:item>
        <:item title="Answer">{@faq.answer}</:item>
        <:item title="Votes">{@faq.votes}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Faq")
     |> assign(:faq, FAQ.get_faq!(id))}
  end
end
