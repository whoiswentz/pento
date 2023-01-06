defmodule Pento.Survey.Rating.Query do
  import Ecto.Query

  alias Pento.Survey.Rating

  def base, do: Rating

  def preload_user(query \\ base(), user) do
    for_user(query, user)
  end

  defp for_user(query, user) do
    where(query, [r], r.user_id == ^user.id)
  end
end
