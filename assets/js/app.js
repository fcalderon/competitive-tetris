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
    let gameName = getParameterByName('gameName', window.location.href);

    if (!!gameName) {
        let channel = socket.channel('games:' + gameName || 'demo', {"playerNumber": playerNumber});

        let joined = false;

        // channel.join()
        //     .receive("ok", res => { console.log(res); joined = true; })
        //     .receive("error", res => { console.log("Got error", res) });

        ReactDOM.render(<Game channel={channel} playerNumber={playerNumber}/>, root);
    } else if (!!root) {
        window.location.href = "/";
    }


}

$(init);

/**
 * Source StackOverflow
 *
 * https://stackoverflow.com/a/901144/3400198
 *
 * @param name
 * @param url
 * @returns {*}
 */
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}