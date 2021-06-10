defmodule Phoex.Talk.TalkRepo do
  alias Phoex.Repo
  alias Phoex.Talk.Room

  def list_rooms() do
    Repo.all(Room)
  end

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def get_room!(id), do: Repo.get!(Room, id)
end
