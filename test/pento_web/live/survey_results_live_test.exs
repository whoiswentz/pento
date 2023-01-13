defmodule PentoWeb.SurveyResultsLiveTest do
  use Pento.DataCase

  import Phoenix.LiveViewTest
  import Pento.CatalogFixtures
  import Pento.AccountsFixtures
  import Pento.SurveyFixtures

  alias PentoWeb.Admin.SurveyResultsLive
  alias Pento.{Accounts, Survey, Catalog}

  @create_product_attrs %{
    description: "test description",
    name: "some game",
    sku: 42,
    unit_price: 120.5
  }

  @create_user_attrs %{email: "test@test.com", password: "passwordpassword"}
  @create_user2_attrs %{email: "another-person@email.com", password: "passwordpassword"}
  @create_user3_attrs %{email: "test3@test.com", password: "passwordpassword"}

  @create_demographic_attrs %{
    gender: "female",
    education: "high school",
    year_of_birth: DateTime.utc_now().year - 15
  }
  @create_demographic2_attrs %{
    gender: "male",
    education: "degree",
    year_of_birth: DateTime.utc_now().year - 30
  }
  @create_demographic_over_18_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 30
  }

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

  defp create_demographic(user, attrs \\ @create_demographic_attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})

    demographic = demographic_fixture(attrs)

    %{demographic: demographic}
  end

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "Socket state" do
    setup [:create_user, :create_product, :create_socket]

    setup %{user: user} do
      create_demographic(user)
      user2 = user_fixture(@create_user2_attrs)
      create_demographic(user2, @create_demographic2_attrs)
      [user2: user2]
    end

    test "no rating exists", %{socket: socket} do
      socket =
        socket
        |> SurveyResultsLive.assign_age_group_filter()
        |> SurveyResultsLive.assign_gender_group_filter()
        |> SurveyResultsLive.assign_products_with_average_ratings()
        |> assert_keys(:products_with_average_ratings, [{"some game", 0}])
    end

    test "ratings exists", %{socket: socket, user: user, product: product} do
      create_rating(2, user, product)

      socket =
        socket
        |> SurveyResultsLive.assign_age_group_filter()
        |> SurveyResultsLive.assign_gender_group_filter()
        |> SurveyResultsLive.assign_products_with_average_ratings()
        |> assert_keys(:products_with_average_ratings, [{"some game", 2.0}])
    end

    test "ratings are filtered by age group", %{
      socket: socket,
      user: user,
      product: product,
      user2: user2
    } do
      create_rating(3, user, product)
      create_rating(1, user2, product)

      socket =
        socket
        |> SurveyResultsLive.assign_age_group_filter()
        |> assert_keys(:age_group_filter, "all")
        |> update_socket(:age_group_filter, "18 and under")
        |> SurveyResultsLive.assign_age_group_filter()
        |> assert_keys(:age_group_filter, "18 and under")
        |> SurveyResultsLive.assign_gender_group_filter()
        |> SurveyResultsLive.assign_products_with_average_ratings()
        |> assert_keys(:products_with_average_ratings, [{"some game", 3.0}])
    end
  end

  defp update_socket(socket, key, value) do
    %{socket | assigns: Map.merge(socket.assigns, Map.new([{key, value}]))}
  end

  defp assert_keys(socket, key, value) do
    assert socket.assigns[key] == value
    socket
  end
end
