defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    number = Enum.random(1..10)

    {:ok, assign(socket, score: 0, number: number, message: "Make a guess:") |> IO.inspect()}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    socket =
      socket
      |> check_guess(guess)
      |> update_socket_with_score_and_message()

    {:noreply, socket}
  end

  defp update_socket_with_score_and_message(%{assigns: %{has_guessed: {true, message}}} = socket) do
    score = socket.assigns.score + 1

    assign(socket, message: message, score: score)
  end

  defp update_socket_with_score_and_message(%{assigns: %{has_guessed: {false, message}}} = socket) do
    score = socket.assigns.score - 1

    assign(socket, message: message, score: score)
  end

  defp check_guess(%{assigns: %{number: number}} = socket, guess) do
    has_guessed =
      case guess == to_string(number) do
        true -> {true, "Your guess: #{guess}. Correct."}
        _ -> {false, "Your guess: #{guess}. Wrong. Guess again"}
      end

    assign(socket, has_guessed: has_guessed)
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>

    <h2>
      <%= @message %> It's <%= time() %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700
          text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
      <.link patch={~p"/guess"}>Restart</.link>
    </h2>
    """
  end
end
