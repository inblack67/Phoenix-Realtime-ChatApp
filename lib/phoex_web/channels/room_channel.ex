defmodule PhoexWeb.RoomChanel do
  use PhoexWeb, :channel
  alias Phoex.Repo
  alias Phoex.Accounts.User
  alias PhoexWeb.Presence

  # called when we join the channel
  def join("room:" <> room_id, _params, socket) do
    # channels are genservers
    send(self(), :after_join)
    {:ok, %{channel: room_id}, assign(socket, :room_id, room_id)}
  end

  def handle_in("message:add", %{"message" => body}, socket) do
    room_id = socket.assigns[:room_id]
    user = get_user(socket)
    message = %{body: body, user: user.username}
    # broadcasting to js clients of the same room
    broadcast!(socket, "room:#{room_id}:new_message", message)
    # since above line is asynch
    {:reply, :ok, socket}
  end

  def handle_in("user:typing", %{"typing" => typing}, socket) do
    user = get_user(socket)

    {:ok, _} =
      Presence.update(socket, "user:#{user.id}", %{
        user_id: user.id,
        username: user.username,
        typing: typing
      })

    {:reply, :ok, socket}
  end

  # handle_in => come from the client
  # unrecognized by gen server => handle_info
  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))
    user = get_user(socket)

    # asynch
    {:ok, _} =
      Presence.track(socket, "user:#{user.id}", %{
        # user meta data
        user_id: user.id,
        username: user.username,
        typing: false
      })

    {:noreply, socket}
  end

  def get_user(socket) do
    Repo.get(User, socket.assigns[:current_user_id])
  end
end
