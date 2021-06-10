defmodule PhoexWeb.RoomController do
  use PhoexWeb, :controller
  alias Phoex.Talk.Room
  alias Phoex.Talk.TalkRepo

  def index(conn, _params) do
    rooms = TalkRepo.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    # empty map (second arg) => will be populated by the form
    changeset = Room.changeset(%Room{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  # look for room map => bind that to room_input
  # every handler needs to retun the conn
  def create(conn, %{"room" => room_input}) do
    case TalkRepo.create_room(room_input) do
      {:ok, _room} ->
        conn
        |> put_flash(:info, "Room created")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
