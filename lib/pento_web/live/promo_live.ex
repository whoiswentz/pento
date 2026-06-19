defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo.Recipient
  alias Pento.Promo

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> clear_form()}
  end

  def assign_recipient(socket) do
    assign(socket, :recipient, %Recipient{})
  end

  def clear_form(socket) do
    changeset =
      socket.assigns.recipient
      |> Promo.change_recipient()

    assign_form(socket, changeset)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def render(assigns) do
    ~H"""
    <.header>
      Send Your Promo Code to a Friend
      <:subtitle></:subtitle>
    </.header>
    """
  end
end
