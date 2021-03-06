defmodule Competitivetetris.Game do
  def i_tetromino() do
    [
      [
        [0,1,0,0],
        [0,1,0,0],
        [0,1,0,0],
        [0,1,0,0],
      ],
      [
        [0,0,0,0],
        [0,0,0,0],
        [1,1,1,1],
        [0,0,0,0],

      ],
      [
        [0,0,1,0],
        [0,0,1,0],
        [0,0,1,0],
        [0,0,1,0],
      ],
      [
        [0,0,0,0],
        [1,1,1,1],
        [0,0,0,0],
        [0,0,0,0],
      ]
    ]
  end

  def o_tetromino do
  [
    [
      [0,2,2,0],
      [0,2,2,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,2,2,0],
      [0,2,2,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,2,2,0],
      [0,2,2,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,2,2,0],
      [0,2,2,0],
      [0,0,0,0],
      [0,0,0,0],
    ]
  ]
  end

  def j_tetromino do
  [
    [
      [0,3,0,0],
      [0,3,0,0],
      [3,3,0,0],
      [0,0,0,0],
    ],
    [
      [3,0,0,0],
      [3,3,3,0],
      [0,0,0,0],
      [0,0,0,0],

    ],
    [
      [0,3,3,0],
      [0,3,0,0],
      [0,3,0,0],
      [0,0,0,0],
    ],
    [
      [0,0,0,0],
      [3,3,3,0],
      [0,0,3,0],
      [0,0,0,0],
    ]
  ]
  end

  def z_tetromino do
  [
    [
      [0,4,4,0],
      [4,4,0,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,4,0,0],
      [0,4,4,0],
      [0,0,4,0],
      [0,0,0,0],

    ],
    [
      [0,0,0,0],
      [0,4,4,0],
      [4,4,0,0],
      [0,0,0,0],
    ],
    [
      [4,0,0,0],
      [4,4,0,0],
      [0,4,0,0],
      [0,0,0,0],
    ]
  ]
  end

  def t_tetromino do
  [
    [
      [0,5,0,0],
      [5,5,5,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,5,0,0],
      [0,5,5,0],
      [0,5,0,0],
      [0,0,0,0],

    ],
    [
      [0,0,0,0],
      [5,5,5,0],
      [0,5,0,0],
      [0,0,0,0],
    ],
    [
      [0,5,0,0],
      [5,5,0,0],
      [0,5,0,0],
      [0,0,0,0],
    ]
  ]
  end
  def l_tetromino do
  [
    [
      [0,6,0,0],
      [0,6,0,0],
      [0,6,6,0],
      [0,0,0,0],
    ],
    [
      [6,0,0,0],
      [6,6,6,0],
      [0,0,0,0],
      [0,0,0,0],

    ],
    [
      [0,6,6,0],
      [0,6,0,0],
      [0,6,0,0],
      [0,0,0,0],
    ],
    [
      [0,0,0,0],
      [6,6,6,0],
      [6,0,0,0],
      [0,0,0,0],
    ]
  ]
  end
  def new_player(playerNumber) do
    randomShape = get_random_tetrimonio_letter()
    shapeTetrimonio = get_tetrimonio(randomShape, 0)
    %{
      playerNumber: playerNumber,
      landed: get_blank_board(),
      topLeft: %{ row: 0, col: 4},
      currentTetrimonio:  shapeTetrimonio,
      tetrimonioLetter: randomShape,
      rotationIndex: 0,
      numberOfRowsCompleted: 0,
      boardFilled: false
    }
  end

  def new(playerNumber) do
    randomShape = get_random_tetrimonio_letter()
    shapeTetrimonio = get_tetrimonio(randomShape, 0)
    %{
      gameStarted: false,
      gameEnded: false,
      winner: nil,
      players: [
        new_player(playerNumber)
      ],
    }
  end

  def start_game(game) do
    Map.put(game, :gameStarted, true)
  end

  def join(game, playerNumber) do
    if Enum.any?(game.players, fn(player) -> player.playerNumber == playerNumber end) do
      game
    else
      updatedGame = Map.put(game, :players, Enum.concat(game.players, [new_player(playerNumber)]))
      Map.put(updatedGame, :gameStarted, length(updatedGame.players) == 2)
    end
  end

  def get_player(game, playerNumber) do
    Enum.find(game.players, fn(p) -> p.playerNumber == playerNumber end)
  end


  def client_view(game, playerNumber) do
    %{
      gameStarted: game.gameStarted,
      gameEnded: game.gameEnded,
      winner: game.winner,
      lastPlay: playerNumber,
      players: Enum.map(game.players, fn(p) -> get_player_client_view(p) end),
    }
  end

  defp get_player_client_view(player) do
    %{
      playerNumber: player.playerNumber,
      landed: player.landed,
      visibleBoard: get_visible_board(player.landed, player.currentTetrimonio, player.topLeft)
    }
  end

  def get_visible_board(landed, currentTetrimonio, topLeft) do
    visible = landed
    |> Enum.with_index
    |> Enum.map(
         fn({row, rowIndex})
         -> row
            |> Enum.with_index
            |> Enum.map(
                 fn({col, colIndex})
                 -> cel_val(col, rowIndex, colIndex, topLeft, currentTetrimonio)
                 end)
         end)
  end

  def cel_val(col, rowIndex, colIndex, topLeft, currentTetrimonio) do
    if (col == 0 && rowIndex >= topLeft.row && rowIndex < topLeft.row + 4
        && colIndex >= topLeft.col && colIndex < topLeft.col + 4) do
      tEl = get_val_at(currentTetrimonio, rowIndex - topLeft.row, colIndex - topLeft.col)
      if (tEl != 0) do
        tEl
      else
        col
      end
    else
      col
    end
  end

  def progress_board(game) do
    updatedGame = Map.put(game, :players, Enum.map(game.players, fn(player) -> progress_player(player) end))
    updatedPlayers = updatedGame.players
    updatedGame = Map.put(updatedGame, :players,
      Enum.reduce(updatedGame.players,
        updatedPlayers,
        fn(player, acc) ->
          Enum.map(acc, fn(mapPlayer) -> update_solid_rows(mapPlayer, player) end)
        end))
    gameEnded = Enum.any?(updatedGame.players, fn(player) -> player.boardFilled end)
    if (gameEnded) do
      updatedGame = Map.put(updatedGame, :winner, Enum.find(updatedGame.players, fn(player) -> !player.boardFilled end).playerNumber)
      updatedGame = Map.put(updatedGame, :gameEnded, true)
    else
      updatedGame
    end
  end

  def update_solid_rows(playerToUpdate, otherPlayer) do
    if (playerToUpdate.playerNumber == otherPlayer.playerNumber) do
      playerToUpdate
    else
      Map.merge(playerToUpdate, %{
        landed: set_solid_rows(playerToUpdate.landed, otherPlayer.numberOfRowsCompleted)
      })
    end
  end

  def progress_player(player) do
    updated = player
    # Increase row

    nextMove = %{ row: player.topLeft.row + 1, col: player.topLeft.col }

    willCollide = will_collide(player, nextMove)

    if (willCollide) do
      newBoard = get_visible_board(player.landed, player.currentTetrimonio, player.topLeft)
      newTetrimonioLetter = get_random_tetrimonio_letter()
      numberOfRowsCompleted = updated.numberOfRowsCompleted + length(get_completed_rows(newBoard))
      updated = Map.merge(updated, %{
        landed: clear_completed_rows(newBoard),
        topLeft: %{row: 0, col: 4},
        currentTetrimonio: get_tetrimonio(newTetrimonioLetter, 0),
        tetrimonioLetter: newTetrimonioLetter,
        rotationIndex: 0,
        numberOfRowsCompleted: numberOfRowsCompleted,
        boardFilled: false
      })
      Map.put(updated, :boardFilled, board_filled(updated.landed))
    else
      Map.merge(updated, %{ topLeft: nextMove, boardFilled: board_filled(updated.landed)})
    end
  end

  def will_collide(player, potentialNext) do
    landed = player.landed
    tetrimonio = player.currentTetrimonio
    tetrimonio
    |> Enum.with_index
    |> Enum.any?(
         fn({row, rowIndex}) ->
           row
           |> Enum.with_index
           |> Enum.any?(
                fn({col, colIndex}) ->
                  col != 0 && (((rowIndex + potentialNext.row >= length(player.landed))
                               || ((Enum.at(Enum.at(landed, rowIndex + potentialNext.row),
                                      colIndex + potentialNext.col)) != 0)) || colIndex + potentialNext.col < 0)
                end)
         end)
  end

  def play(game, playerNumber, move) do
    Map.put(game, :players, Enum.map(game.players, fn(player) -> apply_player_move(player, playerNumber, move) end))
  end

  def apply_player_move(player, playerNumber, move) do
    updated = player

    if (player.playerNumber == playerNumber) do
      potentialPlayer = player
      case { move } do
        {"move_left"} ->
          potentialPlayer = Map.put(updated, :topLeft, %{ row: player.topLeft.row, col: player.topLeft.col - 1})
        {"move_right"} ->
          potentialPlayer = Map.put(updated, :topLeft, %{ row: player.topLeft.row, col: player.topLeft.col + 1})
        {"rotate"} ->
          rotationIndex = player.rotationIndex + 1
          if (rotationIndex > 3) do
            rotationIndex = 0
          end
          potentialPlayer = Map.merge(updated,
            %{
              rotationIndex: rotationIndex,
              currentTetrimonio: get_tetrimonio(player.tetrimonioLetter, rotationIndex)
            })
        {"soft_drop"} ->
          potentialPlayer = Map.put(updated, :topLeft, %{ row: player.topLeft.row + 2, col: player.topLeft.col })
        {"hard_drop"} ->
          potentialPlayer = Map.put(updated, :topLeft, %{ row: player.topLeft.row + 4, col: player.topLeft.col })
      end
      if (!will_collide(potentialPlayer, potentialPlayer.topLeft)) do
        potentialPlayer
      else
        player
      end
    else
      player
    end
  end

  def get_blank_board() do
    [
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
    ]
  end

  def get_tetrimonio(letter, rotation) do
    case { letter } do
      {:I} -> Enum.at(i_tetromino(),rotation)
      {:O} -> Enum.at(o_tetromino(), rotation)
      {:J} -> Enum.at(j_tetromino(), rotation)
      {:Z} -> Enum.at(z_tetromino(), rotation)
      {:T} -> Enum.at(t_tetromino(), rotation)
      {:L} -> Enum.at(l_tetromino(), rotation)
    end
  end

  def get_random_tetrimonio_letter() do
    Enum.random([:I, :O, :J, :Z, :T, :L])
  end


  def get_val_at(biDimensionalArray, row, col) do
    Enum.at(Enum.at(biDimensionalArray, row), col)
  end

  def get_completed_rows(board) do
    board
    |> Enum.with_index
    |> Enum.reduce([],
         fn({row, rowIndex}, acc) ->
           completed =
             row
             |> Enum.all?(
                  fn(col) ->
                    col != 0 && col != -1 # this is the number used for solid rows (those posed by opponents)
                  end)
           if (completed) do
             Enum.concat(acc, [rowIndex])
           else
             acc
           end
         end)
  end

  def clear_rows(rowsToClear, board) do
    board
    |> Enum.with_index
    |> Enum.reduce([],
         fn({row, rowIndex}, acc) ->
           if (Enum.any?(rowsToClear, fn(x) -> x == rowIndex end)) do
             Enum.concat(acc, [[0,0,0,0,0,0,0,0,0,0]])
           else
             Enum.concat(acc, [row])
           end
         end)
  end

  def clear_completed_rows(board) do
    board
    |> get_completed_rows
    |> drop_rows(board)
  end

  def drop_rows(rows, board) do
    updatedBoard = board
    rows
    |> Enum.sort
    |> Enum.reduce(updatedBoard,
         fn(rowIndex, acc) ->
         drop_row(rowIndex, acc)
         end)
  end

  def drop_row(row, board) do
    updated = board
    updated = List.delete_at(updated, row)
    Enum.concat([[0,0,0,0,0,0,0,0,0,0]], updated)
  end

  def has_floating_rows(board) do
    true
  end

  def set_solid_rows(board, numberOfSolidRows) do
    if (numberOfSolidRows == 0) do
      board
    else
      lastRow = length(board) - 1
      0..numberOfSolidRows - 1
      |> Enum.reduce(board,
           fn(rowIndex, acc) ->
             add_solid_row(acc, lastRow - rowIndex)
           end)
    end

  end

  def add_solid_row(board, rowToReplace) do
    Enum.concat(List.delete_at(board, rowToReplace), [[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]])
  end

  def board_filled(board) do
    Enum.any?(Enum.at(board, 0),
      fn(cell) ->
        cell != 0
      end)
  end
end