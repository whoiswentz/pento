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
    scope = socket.assigns.current_scope
    range = scope.preferences.guess_range

    socket
    |> assign(:number, Enum.random(range))
    |> assign(:score, 0)
    |> assign(:message, "Make a guess")
    |> assign(:time, time())
    |> assign(:game_is_over, false)
    |> assign(:guess_range, range)
    |> assign(:role, scope.role)
    |> assign(:preferences, scope.preferences)
    |> assign(:current_user, scope.user)
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
        <%= for n <- @guess_range do %>
          <.link
            class="btn btn-secondary"
            phx-click="guess"
            phx-value-number={n}
          >
            {n}
          </.link>
        <% end %>
      </h2>
      <h2>
        Current User: {@current_user.email}
      </h2>
      <h2>
        Role: {@role} &middot; Difficulty: {@preferences.difficulty} &middot; Theme: {@preferences.theme}
      </h2>
      <%= if Pento.Accounts.Scope.admin?(@current_scope) do %>
        <p class="text-sm text-warning">Admin mode: harder range enabled.</p>
      <% end %>
      <%= if @game_is_over do %>
        <p>You won!</p>
        <.link patch={~p"/guess"}>Play Again</.link>
      <% end %>
    </main>
    """
  end
end
