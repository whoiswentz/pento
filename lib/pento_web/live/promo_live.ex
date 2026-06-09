defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view

  alias Pento.Promo.Recipient
  alias Pento.Promo

  def mount(_params, _session, socket) do
    {:ok, socket}
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
