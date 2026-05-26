defmodule PentoWeb.FaqLive.Index do
  use PentoWeb, :live_view

  alias Pento.FAQ

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Faqs
        <:actions>
          <.button variant="primary" navigate={~p"/faqs/new"}>
            <.icon name="hero-plus" /> New Faq
          </.button>
        </:actions>
      </.header>

      <.table
        id="faqs"
        rows={@streams.faqs}
        row_click={fn {_id, faq} -> JS.navigate(~p"/faqs/#{faq}") end}
      >
        <:col :let={{_id, faq}} label="Question">{faq.question}</:col>
        <:col :let={{_id, faq}} label="Answer">{faq.answer}</:col>
        <:col :let={{_id, faq}} label="Votes">{faq.votes}</:col>
        <:action :let={{_id, faq}}>
          <div class="sr-only">
            <.link navigate={~p"/faqs/#{faq}"}>Show</.link>
          </div>
          <.link navigate={~p"/faqs/#{faq}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, faq}}>
          <.link
            phx-click={JS.push("delete", value: %{id: faq.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Faqs")
     |> stream(:faqs, list_faqs())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    faq = FAQ.get_faq!(id)
    {:ok, _} = FAQ.delete_faq(faq)

    {:noreply, stream_delete(socket, :faqs, faq)}
  end

  defp list_faqs() do
    FAQ.list_faqs()
  end
end
