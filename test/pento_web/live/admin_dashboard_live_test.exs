defmodule PentoWeb.AdminDashboardLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest

  import Pento.CatalogFixtures
  import Pento.AccountsFixtures
  import Pento.SurveyFixtures

  alias Pento.{Accounts, Survey, Catalog}

  @create_product_attrs %{
    description: "test description",
    name: "Test Game",
    sku: 42,
    unit_price: 120.5
  }

  @create_user_attrs %{
    email: "test@test.com",
    password: "passwordpassword"
  }
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
    user = user_fixture()
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

  def create_demographic(user, attrs \\ @create_demographic_attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})

    demographic = demographic_fixture(attrs)
    %{demographic: demographic}
  end

  defp create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "Survey Results" do
    setup [:register_and_log_in_user, :create_product, :create_user]

    setup %{user: user, product: product} do
      create_demographic(user)
      create_rating(2, user, product)

      user2 = user_fixture(@create_user2_attrs)
      create_demographic(user2, @create_demographic_over_18_attrs)

      :ok
    end

    test "it filters by age group", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/admin-dashboard")
      age_group_filter = %{"age_group_filter" => "18 and under"}

      assert view
             |> element("#age-group-form")
             |> render_change(age_group_filter) =~ "<title>2.00</title>"
    end

    test "it updates to display newly create ratins", %{
      conn: conn,
      product: product
    } do
      {:ok, view, html} = live(conn, "/admin-dashboard")

      assert html =~ "<title>2.00</title>"

      user3 = user_fixture(@create_user3_attrs)
      create_demographic(user3)
      create_rating(3, user3, product)

      send(view.pid, %{event: "rating_created"})

      assert render(view) =~ "<title>2.50</title>"
    end
  end
end
