// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import 'phoenix_html';
import ReactDOM from 'react-dom';
import React from 'react';

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

import { Hello } from './hello.jsx';

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

    channel.join()
        .receive("ok", res => { console.log(res); joined = true; })
        .receive("error", res => { console.log("Got error", res) });

    ReactDOM.render(<Hello name='Boiled Egg' buttonClicked={ () => { handleInput(channel, joined, playerNumber) }}/>, root);
}

$(init);
