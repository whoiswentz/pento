defmodule Pento.Promo.Recipient do
  defstruct [:first_name, :email]

  @types %{first_name: :string, email: :string}

  import Ecto.Changeset

  def chageset(%__MODULE__{} = recipient, attrs) do
    {recipient, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end
