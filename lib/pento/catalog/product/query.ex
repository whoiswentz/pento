defmodule Pento.Catalog.Product.Query do
  import Ecto.Query

  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  def base, do: Product

  def with_user_ratings(query \\ base(), user) do
    preload_user_ratings(query, user)
  end

  def preload_user_ratings(query, user) do
    preload(query,
      ratings: ^Rating.Query.preload_user(user)
    )
  end
end
