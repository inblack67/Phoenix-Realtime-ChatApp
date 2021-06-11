defmodule Phoex.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phoex.Accounts.User

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username])
    |> validate_required([:email, :username])
    |> validate_length(:username, min: 5, max: 30)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def registration_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> validate_confirmation(:password)
    |> cast(attrs, [:password], [])
    |> validate_length(:password, min: 8, max: 100)
    |> encrypt_password()
  end

  def encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
