defmodule PentoWeb.Presence do
  use Phoenix.Presence,
    otp_app: :pento,
    pubsub_server: Pento.PubSub

  alias PentoWeb.Presence

  @user_activity_topic "user_activity"
  @user_taking_survey_topic "user_taking_survey"

  def track_user(pid, product, user_email) do
    Presence.track(
      pid,
      @user_activity_topic,
      product.name,
      %{users: [%{email: user_email}]}
    )
  end

  def track_user_taking_survey(pid, user_email) do
    Presence.track(
      pid,
      @user_taking_survey_topic,
      "taking",
      %{users: [%{email: user_email}]}
    )
  end

  def list_products_and_users do
    Presence.list(@user_activity_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, user_from_metas_list(metas)}
  end

  defp users_from_metas_map(meta_map) do
    get_in(meta_map, [:users])
  end

  def list_user_taking_survey do
    Presence.list(@user_taking_survey_topic)
    |> Enum.map(&extract_user_taking_survey/1)
  end

  defp extract_user_taking_survey({"taking", %{metas: metas}}) do
    {"taking", length(user_from_metas_list(metas))}
  end

  defp user_from_metas_list(metas) do
    Enum.map(metas, &users_from_metas_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end
end
