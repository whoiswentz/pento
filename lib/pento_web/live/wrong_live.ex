defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        number =
          Enum.random(1..10)
          |> Integer.to_string()

        IO.inspect(number)

        {:ok,
         socket
         |> assign(number: number)
         |> assign(score: 0)
         |> assign(won: false)
         |> assign(message: "Make a guess: ")}

      false ->
        {:ok,
         socket
         |> assign(number: 0)
         |> assign(score: 0)
         |> assign(won: false)
         |> assign(message: "Make a guess: ")}
    end
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    number = socket.assigns.number

    if number == guess do
      message = "You win"
      score = socket.assigns.score + 1

      {:noreply,
       socket
       |> assign(won: true)
       |> assign(score: score)
       |> assign(message: message)}
    else
      message = "Your guess: #{guess}. Wrong. Guess again. "
      score = socket.assigns.score - 1

      {:noreply,
       socket
       |> assign(won: false)
       |> assign(score: score)
       |> assign(message: message)}
    end
  end

  def time() do
    DateTime.utc_now() |> to_string
  end
end
