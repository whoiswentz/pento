defmodule Pento.SurveyTest do
  use Pento.DataCase

  import Pento.SurveyFixtures
  import Pento.AccountsFixtures
  import Pento.CatalogFixtures

  alias Pento.Survey
  alias Pento.Survey.{Demographic, Rating}

  @create_user_attrs %{email: "test@test.com", password: "passwordpassword"}

  @create_product_attrs %{
    description: "test description",
    name: "Test Game",
    sku: 42,
    unit_price: 120.5
  }

  @create_demographic_attrs %{
    gender: "female",
    education: "high school",
    year_of_birth: DateTime.utc_now().year - 15
  }

  defp create_product(attrs \\ @create_product_attrs) do
    product = product_fixture(attrs)
    %{product: product}
  end

  defp create_user(attrs \\ @create_user_attrs) do
    user = user_fixture()
    %{user: user}
  end

  def create_demographic(user, attrs \\ @create_demographic_attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})

    demographic = demographic_fixture(attrs)
    %{demographic: demographic}
  end

  describe "demographics" do
    @invalid_attrs %{gender: nil, year_of_birth: nil}

    setup [:create_product, :create_user]

    test "list_demographics/0 returns all demographics", %{user: user} do
      demographic = demographic_fixture(%{user_id: user.id})
      assert Survey.list_demographics() == [demographic]
    end

    test "get_demographic!/1 returns the demographic with given id", %{user: user} do
      demographic = demographic_fixture(%{user_id: user.id})
      assert Survey.get_demographic!(demographic.id) == demographic
    end

    test "create_demographic/1 with valid data creates a demographic", %{user: user} do
      valid_attrs = %{gender: "female", year_of_birth: 1985, user_id: user.id}

      assert {:ok, %Demographic{} = demographic} = Survey.create_demographic(valid_attrs)
      assert demographic.gender == "female"
      assert demographic.year_of_birth == 1985
    end

    test "create_demographic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_demographic(@invalid_attrs)
    end

    test "update_demographic/2 with valid data updates the demographic", %{user: user} do
      demographic = demographic_fixture(%{user_id: user.id})
      update_attrs = %{gender: "male", year_of_birth: 1982}

      assert {:ok, %Demographic{} = demographic} =
               Survey.update_demographic(demographic, update_attrs)

      assert demographic.gender == "male"
      assert demographic.year_of_birth == 1982
    end

    test "update_demographic/2 with invalid data returns error changeset", %{user: user} do
      demographic = demographic_fixture(%{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Survey.update_demographic(demographic, @invalid_attrs)
      assert demographic == Survey.get_demographic!(demographic.id)
    end

    test "delete_demographic/1 deletes the demographic", %{user: user} do
      demographic = demographic_fixture(%{user_id: user.id})
      assert {:ok, %Demographic{}} = Survey.delete_demographic(demographic)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_demographic!(demographic.id) end
    end

    test "change_demographic/1 returns a demographic changeset", %{user: user} do
      demographic = demographic_fixture(%{user_id: user.id})
      assert %Ecto.Changeset{} = Survey.change_demographic(demographic)
    end
  end

  describe "ratings" do
    @invalid_attrs %{stars: nil}

    setup [:create_product, :create_user]

    setup %{user: user} do
      create_demographic(user)
    end

    test "list_ratings/0 returns all ratings", %{user: user, product: product} do
      rating =
        rating_fixture(%{
          star: 1,
          user_id: user.id,
          product_id: product.id
        })

      assert Survey.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id", %{user: user, product: product} do
      rating =
        rating_fixture(%{
          star: 1,
          user_id: user.id,
          product_id: product.id
        })

      assert Survey.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating", %{user: user, product: product} do
      valid_attrs = %{
        stars: 5,
        user_id: user.id,
        product_id: product.id
      }

      assert {:ok, %Rating{} = rating} = Survey.create_rating(valid_attrs)
      assert rating.stars == 5
    end

    test "create_rating/1 with invalid data returns error changeset", %{
      user: user,
      product: product
    } do
      assert {:error, %Ecto.Changeset{}} = Survey.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating", %{user: user, product: product} do
      rating = rating_fixture(%{stars: 1, user_id: user.id, product_id: product.id})
      update_attrs = %{stars: 5}

      assert {:ok, %Rating{} = rating} = Survey.update_rating(rating, update_attrs)
      assert rating.stars == 5
    end

    test "update_rating/2 with invalid data returns error changeset", %{
      user: user,
      product: product
    } do
      rating = rating_fixture(%{user_id: user.id, product_id: product.id, stars: 1})
      assert {:error, %Ecto.Changeset{}} = Survey.update_rating(rating, @invalid_attrs)
      assert rating == Survey.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating", %{user: user, product: product} do
      rating = rating_fixture(%{stars: 1, user_id: user.id, product_id: product.id})
      assert {:ok, %Rating{}} = Survey.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset", %{user: user, product: product} do
      rating = rating_fixture(%{stars: 1, user_id: user.id, product_id: product.id})
      assert %Ecto.Changeset{} = Survey.change_rating(rating)
    end
  end
end
