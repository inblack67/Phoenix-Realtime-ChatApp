defmodule PhoexWeb.RoomChanel do
  use PhoexWeb, :channel
  alias Phoex.Repo
  alias Phoex.Accounts.User

  # called when we join the channel
  def join("room:" <> room_id, _params, socket) do
    {:ok, %{channel: room_id}, assign(socket, :room_id, room_id)}
  end

  def handle_in("message:add", %{"message" => body}, socket) do
    room_id = socket.assigns[:room_id]
    user = get_user(socket)
    message = %{body: body, user: user.username}
    # broadcasting to js clients of the same room
    broadcast!(socket, "room:#{room_id}:new_message", message)
    # since above line is synch
    {:reply, :ok, socket}
  end

  def get_user(socket) do
    Repo.get(User, socket.assigns[:current_user_id])
  end
end
