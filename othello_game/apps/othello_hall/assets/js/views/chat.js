import React from 'react';
import {connect} from "react-redux";
import {listen_for_messages, sendMessage} from "../actions/chat";
import {Message} from "../components/message";
import Infinite from 'react-infinite';


export default class Chat extends React.Component{

    componentWillMount()    {
        this.props.dispatch(listen_for_messages(this.props.gameChannel));
    }

    render()    {
        const messagesList = this.props.messages.map(message => {
            {
                console.log(message);
            }
            return (
                <Message key={message} message={message}/>
            );
        });

        return(
            <div id="chat_box">
                <div id="message_box">
                    <Infinite containerHeight={200} elementHeight={40}
                              displayBottomUpwards>
                        {messagesList}
                    </Infinite>
                </div>
                <div id="text_box">
                    <input placeholder="Press Enter to send" onKeyDown={this.keyPress.bind(this)} />
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

// const mapStateToProps = (state, props) => {
//     return Object.assign({}, state.chat, props)
// }
//
//
// export default connect(mapStateToProps)(Chat);