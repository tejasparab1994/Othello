import React from 'react';
import {connect} from "react-redux";
import {listen_for_messages, sendMessage} from "../actions/chat";
import {Message} from "../components/message";


export default class Chat extends React.Component{

    componentWillMount()    {
        this.props.dispatch(listen_for_messages(this.props.gameChannel));
    }

    componentDidUpdate() {
        var objDiv = document.getElementsByClassName("message_box")[0];
        objDiv.scrollTop = objDiv.scrollHeight;
    }

    render()    {
        const messagesList = this.props.messages.map((message, index) => {
            return (
                <Message key={index} message={message}/>
            );
        });

        return(
            <div className="card" id="chat_box">
              <div className="message_box">
                {messagesList}
              </div>
              <div className="text_entry" id="text_box">
                <input placeholder="Press Enter to send" className="form-control" onKeyDown={this.keyPress.bind(this)} />
              </div>
            </div>
        );
    }

    keyPress(e)    {
        var message = e.target.value;

        if (message === "")
            return;

        if (e.keyCode == 13)    {
            this.props.dispatch(sendMessage(this.props.gameChannel, message));
            e.target.value = "";
        }
    }
}