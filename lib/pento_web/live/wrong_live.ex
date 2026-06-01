defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Pento.PubSub, "guess:numbers")
      Phoenix.PubSub.subscribe(Pento.PubSub, "guess:win")
    end

    {:ok, reset_game(socket)}
  end

  def handle_params(_params, _session, socket) do
    {:noreply, reset_game(socket)}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    number = socket.assigns.number
    current_scope = socket.assigns.current_scope.user
    guess = String.to_integer(guess)

    IO.inspect(current_scope)

    Phoenix.PubSub.broadcast(
      Pento.PubSub,
      "guess:numbers",
      {:guess,
       %{
         "user" => current_scope.email,
         "guess" => guess
       }}
    )

    if number == guess do
      socket =
        socket
        |> assign(:score, socket.assigns.score + 1)
        |> assign(:message, "Correct! The number was #{number}. ")
        |> assign(:game_is_over, true)

      Phoenix.PubSub.broadcast(
        Pento.PubSub,
        "guess:win",
        {:win,
         %{
           "user" => current_scope.email,
           "number" => number
         }}
      )

      {:noreply, socket}
    else
      socket =
        socket
        |> assign(:score, socket.assigns.score - 1)
        |> assign(:message, "Wrong. Guess again. ")

      {:noreply, socket}
    end
  end

  def handle_info({:guess, %{"user" => user, "guess" => guess}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "User #{user} guessed #{guess}. ")}
  end

  def handle_info({:win, %{"user" => user, "number" => number}}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "User #{user} won! The number was #{number}. ")
     |> assign(:game_is_over, true)}
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
    <Layouts.app flash={@flash} current_scope={@current_scope}>
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
            class={["btn btn-secondary", @game_is_over && "btn-disabled"]}
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
    </Layouts.app>
    """
  end
end
