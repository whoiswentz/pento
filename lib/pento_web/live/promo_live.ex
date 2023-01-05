defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_recipient() |> assign_changeset()}
  end

  def handle_event("validate", session, socket) do
    chageset =
      socket.assigns.recipient
      |> Promo.change_recipient(session["recipient"])
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, chageset)}
  end

  def handle_event("save", _session, socket) do
    :timer.sleep(1000)

    {:noreply, socket}
  end

  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  def assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, Promo.change_recipient(recipient))
  end
end
