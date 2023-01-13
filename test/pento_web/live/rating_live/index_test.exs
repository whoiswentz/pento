defmodule PentoWeb.RatingLive.IndexTest do
  use Pento.DataCase

  import Phoenix.LiveViewTest
  import Phoenix.Component
  import Pento.CatalogFixtures
  import Pento.AccountsFixtures
  import Pento.SurveyFixtures

  alias Pento.Catalog
  alias Pento.Catalog.Product
  alias PentoWeb.RatingLive.Index

  @create_product_attrs %{
    description: "test description",
    name: "some game",
    sku: 42,
    unit_price: 120.5
  }

  @create_user_attrs %{email: "test@test.com", password: "passwordpassword"}

  defp create_product(attrs \\ @create_product_attrs) do
    product = product_fixture(attrs)
    %{product: product}
  end

  defp create_user(attrs \\ @create_user_attrs) do
    user = user_fixture(attrs)
    %{user: user}
  end

  defp create_rating(stars, user, product) do
    rating =
      rating_fixture(%{
        stars: stars,
        user_id: user.id,
        product_id: product.id
      })

    %{rating: rating}
  end

  describe "render products component" do
    setup [:create_user, :create_product]

    setup %{user: user, product: product} do
      create_rating(4, user, product)
    end

    test "render product component", %{user: user} do
      products = Catalog.list_products_with_user_rating(user)

      assert render_component(&Index.products/1, current_user: user, products: products) =~
               "<h4>\n    some game\n    &#x2605; &#x2605; &#x2605; &#x2605; &#x2606;\n  </h4>"
    end
  end
end
