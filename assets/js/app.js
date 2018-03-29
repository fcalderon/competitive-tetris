import 'phoenix_html';
import ReactDOM from 'react-dom';
import React from 'react';

import socket from "./socket"

import { Hello } from './hello.jsx';
import { Game } from './game.jsx';
function handleInput(channel, joined, playerNumber) {
    console.log('Button clicked', joined);
    if (joined) {
        channel.push('play', {"playerNumber": playerNumber})
            .receive("ok", res => {
                console.log("Got okay: ", res);
            }).receive("error", res => {
                console.error('Got error', res);
        })
    }
}

function init() {
    let root = document.getElementById('competitive-tetris');
    let playerNumber = localStorage.getItem("playerNumber");
    if (!playerNumber) {
        playerNumber = Math.floor(Math.random() * 100000);
        localStorage.setItem("playerNumber", playerNumber)
    }

    let channel = socket.channel('games:demo', {"playerNumber": playerNumber});

    let joined = false;

    // channel.join()
    //     .receive("ok", res => { console.log(res); joined = true; })
    //     .receive("error", res => { console.log("Got error", res) });

    ReactDOM.render(<Game channel={channel} playerNumber={playerNumber}/>, root);
}

$(init);
