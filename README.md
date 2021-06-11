# Phoex

### Notes

```sh
mix phx.gen.schema Talk.Room rooms name, description topic

# rollback the last migration ran
mix ecto.rollback

iex -S mix

%Room{} |> Room.changeset(%{name: "typescript", description: "any programming"})

mix phx.routes

mix phx.gen.schema Accounts.User users email:unique username:unique password_hash

# drop db
mix ecto.drop

```

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
