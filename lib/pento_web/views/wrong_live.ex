defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       number: to_string(Enum.random(1..10)),
       score: 0,
       message: "Make a guess:",
       session_id: session["live_socket_id"]
     )}
  end

  def handle_event("guess", %{"number" => number}, socket) do
    new_random = to_string(Enum.random(1..10))

    if number == socket.assigns.number do
      message = "Your guess: #{number}. Congrats. Guess again."
      score = socket.assigns.score + 1

      {:noreply,
       assign(socket,
         number: new_random,
         score: score,
         message: message
       )}
    else
      message = "Your guess: #{number}. Wrong. Guess again."
      score = socket.assigns.score - 1

      {:noreply,
       assign(socket,
         number: new_random,
         score: score,
         message: message
       )}
    end
  end

  def handle_event("restart", _params, socket) do
    {:ok,
     assign(socket,
       number: to_string(Enum.random(1..10)),
       score: 0,
       message: "Make a guess:"
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      <%= @number %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </a>
      <% end %>
    </h2>
    <pre>
      <%= @current_user.email %>
      <%= @session_id %>
    </pre>
    <button type="submit" phx-click="restart">
      Restart
    </button>
    """
  end
end
