defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Accounts.User

  @attrs [:gender, :year_of_birth, :user_id, :education]

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    field :education, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
    |> validate_inclusion(:gender, [
      "male",
      "female",
      "other",
      "prefer not to say"
    ])
    |> validate_inclusion(:education, [
      "high school",
      "bachelor's degree",
      "graduate",
      "degree",
      "other",
      "“prefer not to say"
    ])
    |> validate_inclusion(:year_of_birth, 1900..DateTime.utc_now().year)
    |> unique_constraint(:user_id)
  end
end
