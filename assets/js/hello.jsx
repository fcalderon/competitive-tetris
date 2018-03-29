import React from 'react';

export const Hello = (props) => {
    return (
        <div>
            <h1>Hello {props.name}</h1>
            <button onClick={() => props.buttonClicked() }>Click me</button>

        </div>
    );
};
