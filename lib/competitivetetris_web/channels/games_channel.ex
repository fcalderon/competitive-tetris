defmodule CompetitivetetrisWeb.GamesChannel do
  use CompetitivetetrisWeb, :channel
  alias Competitivetetris.Game
  alias Competitivetetris.GameBackup

  def join("games:" <> name, %{"playerNumber" => playerNumber}, socket) do
    game = GameBackup.load(name) || Game.new(playerNumber)
    game = Game.join(game, playerNumber)
    GameBackup.save(socket.assigns[:name], game)
    IO.puts("Someone joined")
    IO.inspect(name)
    IO.inspect(playerNumber)
    IO.inspect(socket)
    socket = socket
             |> assign(:name, name)
             |> assign(:playerNumber, playerNumber)
             |> assign(:game, game)
    IO.puts("Joined! Replying with client view:")
    IO.inspect(Game.client_view(game, playerNumber))
    {:ok, %{"join" => name, "game" => Game.client_view(game, playerNumber)}, socket}
  end

  def handle_in("reset", payload, socket) do
    socket = assign(socket, :game, "name")
    {:reply, {:ok, %{"game" => "reset received"}}, socket}
  end

  def handle_in("play", %{"playerNumber" => playerNumber}, socket) do
    IO.puts("Got play")

    game = Game.play(socket.assigns[:game], playerNumber)

    IO.puts("Played! Saving backup!")

    GameBackup.save(socket.assigns[:name], game)

    IO.puts("Saved backup! Assigning game to socket")
    socket = assign(socket, :game, game)

    IO.inspect(game)

    IO.puts("Assigned game to socket! Replying with OK!")
    IO.inspect(Game.client_view(game, playerNumber))
    IO.inspect({:ok, %{"game" => Game.client_view(game, playerNumber)}})
    IO.puts("Replying")
    {:reply, {:ok, %{"game" => Game.client_view(game, playerNumber)}}, socket}
  end
end