defmodule PhoexWeb.SessionController do
  use PhoexWeb, :controller
  alias Phoex.Accounts.AccountsRepo

  def new(conn, _) do
    render(conn, "new.html")
  end

  # sign in
  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case AccountsRepo.sign_in(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed In")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid Credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> AccountsRepo.sign_out()
    |> put_flash(:info, "Signed Out")
    |> redirect(to: Routes.room_path(conn, :index))
  end
end
