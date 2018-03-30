import React from 'react';

export class Game extends React.Component {
    constructor(props) {
        super();
        this._listenToKeyStrokes();
        this.state = { game: undefined };
        this.channel = props.channel;
        this.playerNumber = props.playerNumber;
        this.notified = false;
        this.channel.join()
            .receive("ok", res => { console.log('>>> JOINED',res); })
            .receive("error", res => { console.log("Got error", res) });
        this.channel.on("game:player_joined", res => { this._handlePlayerJoined(res); });
        this.channel.on("game:update_board", res => { this._handleBoardUpdate(res); });
        this.channel.on("game:game_ended", res => { this._handleGameEnded(res); });
        this.channel.on("game:player_left", res => { this._handlePlayerLeft(res); });
        this.channel.on("game:player_played", res => { this._handlePlayerPlayed(res); });
    }

    _onGameUpdated(newGame) {
        this.setState(this._getStateFromGame(newGame))
    }

    _handlePlayerJoined(res) {
        console.log('Player joined', res);
    }

    _handleBoardUpdate(res) {
        console.log('Board update:', res);
        this._onGameUpdated(res.game)
    }

    _handleGameEnded(res) {
        console.log('Game ended:', res);
        const game = res.game;
        if (!this.notified) {
            if (game.winner == this.playerNumber) {
                alert('You won!');
                this.notified = true;
            } else {
                alert('You lost.');
                this.notified = true;
            }
        }

        this._onGameUpdated(game)
    }

    _handlePlayerPlayed(res) {
        console.log('Player played', res);
    }

    _handlePlayerLeft(res) {
        console.log('Player left', res);
    }

    _getStateFromGame(game) {
        let currentPlayersGame = {};
        let opponentPlayersGame = {};

        for (let i = 0; i < game.players.length ; i++) {
            const player = game.players[i];
            if (player.playerNumber === this.props.playerNumber) {
                currentPlayersGame = player;
            } else {
                opponentPlayersGame = player;
            }
        }

        return {
            game : {
                gameStarted: game.gameStarted,
                currentPlayersGame: currentPlayersGame,
                opponentPlayersGame: opponentPlayersGame
            }
        };
    }
    _onValidKeyPressed(key) {
        console.log('[Key Pressed] Left was pressed', key);

        this.channel.push('play', {"playerNumber": this.props.playerNumber, "move": key}).receive('ok', res => {
            console.log('Pushed', res);
            this._onGameUpdated(res.game)
        })

    }

    _listenToKeyStrokes() {
        document.addEventListener('keydown', (event) => {
            switch (event.keyCode) {
                case 37:
                    this._onValidKeyPressed('move_left');
                    break;
                case 39:
                    this._onValidKeyPressed('move_right');
                    break;
                case 38:
                    this._onValidKeyPressed('rotate');
                    break;
                case 40:
                    this._onValidKeyPressed('soft_drop');
                    break;
                case 32:
                    this._onValidKeyPressed('hard_drop');
                    break;
            }
        });
    }

    _renderBoard(board) {
        if (!board) {
            return <p>N/A</p>
        }

        return (<div className={'board'}> {board.map((row, index) => {
           return (
                 (index === 0 || index === 1)
                   ?
                     <span></span>
                   :
                     <div className={'row'} key={index}>

                         {row.map((col, colIndex) => {
                             return (
                                 <div className={'col cell ' + this._cellClass(col)} key={colIndex}>

                                 </div>
                             )
                         })}

                     </div>


           )
        })}</div>);
    }

    _cellClass(val) {
        switch (val) {
            case 1:
                return 'I';
            case 2:
                return 'O';
            case 3:
                return 'J';
            case 4:
                return 'Z';
            case 5:
                return 'T';
            case 6:
                return 'L';
            case -1:
                return 'SOLID';
            default:
                return 'blank';

        }
    }

    render() {
        return (<div className={'container mb-5'}>
            <div>
                { !!this.state.game ?
                        this.state.game.gameStarted
                        ?
                        <div className={'row'}>
                            <div className='col-8'>
                                <h1>Your board</h1>
                                {this._renderBoard(this.state.game.currentPlayersGame.visibleBoard)}
                            </div>
                            <div className='col-4'>
                                <h1>Your oponents board</h1>
                                {this._renderBoard(this.state.game.opponentPlayersGame.visibleBoard)}
                            </div>
                        </div>
                        :
                        <div className={'row'}>
                            <div className={'col'}><p>Game hasn't started. Waiting for second player.</p></div>
                        </div>
                    :
                    <div>
                        <p>No game</p>
                    </div>
                }

            </div>
        </div>);
    }
}
