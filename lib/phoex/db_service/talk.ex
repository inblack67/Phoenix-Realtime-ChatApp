defmodule Phoex.Talk.TalkRepo do
  alias Phoex.Repo
  alias Phoex.Talk.Room

  def list_rooms() do
    Repo.all(Room)
  end

  def create_room(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:rooms)
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def get_room!(id), do: Repo.get!(Room, id)

  def room_changeset(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def delete_room(%Room{} = room) do
    room
    |> Repo.delete()
  end
end
