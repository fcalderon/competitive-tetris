defmodule CompetitivetetrisWeb.GamesChannel do
  use CompetitivetetrisWeb, :channel
  alias Competitivetetris.Game
  alias Competitivetetris.GameBackup

  def join("games:" <> name, %{"playerNumber" => playerNumber}, socket) do
    game = GameBackup.load(name) || Game.new(playerNumber)

    game = Game.join(game, playerNumber)

    GameBackup.save(name, game)

    socket = socket
             |> assign(:name, name)
             |> assign(:playerNumber, playerNumber)

    :timer.send_interval(500, {:update_board, name, playerNumber})

    send(self, {:player_joined, playerNumber, game})

    {:ok, %{"join" => name, "game" => Game.client_view(game, playerNumber)}, socket}
  end

  def handle_info({:player_joined, playerNumber, game}, socket) do
    broadcast! socket, "game:player_joined", %{playerNumber: playerNumber}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end

  def handle_info({:update_board, name, playerNumber}, socket) do
    newGame = Game.progress_board(GameBackup.load(name))
    GameBackup.save(name, newGame)
    push socket, "game:update_board", %{user: "SYSTEM", body: "ping", game: Game.client_view(newGame, playerNumber)}

    {:noreply, socket}
  end


  def handle_info({:player_played, game}, socket) do
    playerNumber = socket.assigns[:playerNumber]
    broadcast! socket, "game:player_played", %{"game" => Game.client_view(game, playerNumber)}
    {:noreply, socket}
  end

  def handle_in("reset", payload, socket) do
    socket = assign(socket, :game, "name")
    {:reply, {:ok, %{"game" => "reset received"}}, socket}
  end


  def terminate(reason, _socket) do
    broadcast! _socket, "game:player_left", %{playerNumber: _socket.assigns[:playerNumber]}
    :ok
  end

  def handle_in("play", %{"playerNumber" => playerNumber, "move" => move}, socket) do
    game = Game.play(GameBackup.load(socket.assigns[:name]), playerNumber, move)

    GameBackup.save(socket.assigns[:name], game)

    send(self, {:player_played, game})
    {:reply, {:ok, %{"game" => Game.client_view(game, playerNumber)}}, socket}
  end
end

# Helpful how to
# https://github.com/chrismccord/phoenix_chat_example