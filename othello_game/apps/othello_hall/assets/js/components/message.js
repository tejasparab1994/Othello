import React from 'react';


export class Message extends React.Component{

    render()    {
        let message = this.props.message.message;
        let playerName = this.props.message.name === window.playerName ?
            "You" : this.props.message.name;

        return (<div className="individual_message">{playerName + " : " + message}</div>);
    }
}
