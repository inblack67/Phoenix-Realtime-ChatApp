defmodule Phoex.Talk.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phoex.Accounts.User

  schema "rooms" do
    field :description, :string
    field :name, :string
    field :topic, :string

    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description, :topic])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 5, max: 30)
    |> validate_length(:name, min: 5, max: 300)
  end
end
