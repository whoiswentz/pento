defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  def markdown_product(product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_change(:unit_price, :decrease_unit_price, fn field, value ->
      unit_price = get_field(product, :unit_price)

      if unit_price > value,
        do: [],
        else: [
          {field,
           {"newer unit_price should be lower than the older", [validation: :decrease_unit_price]}}
        ]
    end)
  end
end
