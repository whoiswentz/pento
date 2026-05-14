defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, reset_game(socket)}
  end

  def handle_params(_params, _session, socket) do
    {:noreply, reset_game(socket)}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    number = socket.assigns.number
    guess = String.to_integer(guess)

    if number == guess do
      socket =
        socket
        |> assign(:score, socket.assigns.score + 1)
        |> assign(:message, "Correct! The number was #{number}. ")
        |> assign(:game_is_over, true)

      {:noreply, socket}
    else
      socket =
        socket
        |> assign(:score, socket.assigns.score - 1)
        |> assign(:message, "Wrong. Guess again. ")

      {:noreply, socket}
    end
  end

  defp reset_game(socket) do
    socket
    |> assign(:number, Enum.random(1..10))
    |> assign(:score, 0)
    |> assign(:message, "Make a guess")
    |> assign(:time, time())
    |> assign(:game_is_over, false)
  end

  def time do
    DateTime.utc_now()
    |> to_string()
  end

  def render(assigns) do
    ~H"""
    <main class="px-4 py-20 sm:px-6 lg:px-8">
      <h1 class="mb-4 text-4xl font-extrabold">
        Your score: {@score}
      </h1>
      <h2>
        {@message} It's {time()}
      </h2>
      <br />
      <h2>
        <%= for n <- 1..10 do %>
          <.link
            class="btn btn-secondary"
            phx-click="guess"
            phx-value-number={n}
          >
            {n}
          </.link>
        <% end %>
      </h2>
      <%= if @game_is_over do %>
        <p>You won!</p>
        <.link patch={~p"/guess"}>Play Again</.link>
      <% end %>
    </main>
    """
  end
end
