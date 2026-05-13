defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:score, 0)
      |> assign(:message, "Make a guess")

    {:ok, socket}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    message = "Your guess: #{guess}, Wrong. Guess again. "
    score = socket.assigns.score - 1

    socket =
      socket
      |> assign(:score, score)
      |> assign(:message, message)

    { :noreply, socket }
  end

  def render(assigns) do
    ~H"""
    <main class="px-4 py-20 sm:px-6 lg:px-8">
    <h1 class="mb-4 text-4xl font-extrabold">
      Your score: {@score}
    </h1>
    <h2>
      {@message}
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="btn btn-secondary"
          phx-click="guess"
          phx-value-number={n}>
          {n}
        </.link>
      <% end %>
    </h2>
    </main>
    """
  end
end
