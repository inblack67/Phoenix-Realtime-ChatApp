defmodule PhoexWeb.RegistrationController do
  use PhoexWeb, :controller
  alias Phoex.Accounts.AccountsRepo

  def new(conn, _) do
    render(conn, "new.html", changeset: conn)
  end

  def create(conn, %{"registration" => registration_input}) do
    case AccountsRepo.register(registration_input) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Registered and Signed In")
        |> redirect(to: Routes.room_path(conn, :index))

      # changeset will refill the form with the old values
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
