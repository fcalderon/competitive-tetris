import React from 'react';

export class Game extends React.Component {
    constructor(props) {
        super();
        this._listenToKeyStrokes();
        this.state = { game: undefined };
        this.channel = props.channel;
        this.playerNumber = props.playerNumber;
        this.channel.join()
            .receive("ok", res => { console.log('>>> JOINED',res); })
            .receive("error", res => { console.log("Got error", res) });
        this.channel.on("game:player_joined", res => { this._handlePlayerJoined(res); });
        this.channel.on("game:update_board", res => { this._handleBoardUpdate(res); });
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

        return board.map((row, index) => {
           return (
               <div className={'row'} key={index}>

                   {row.map((col, colIndex) => {
                       return (
                           <div className={'col-xs-1'} key={colIndex}>
                               {col}
                           </div>
                       )
                   })}

               </div>
           )
        });
    }

    render() {
        return (<div className={'container'}>
            <div className={'row'}>
                <div className={'col'}>One Col</div>
                <div className={'col'}>Two Col</div>
                <div className={'col'}>Three Col6</div>
            </div>
            <div>
                { !!this.state.game ?
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
                    <div>
                        <p>No game</p>
                    </div>
                }

            </div>
        </div>);
    }
}
