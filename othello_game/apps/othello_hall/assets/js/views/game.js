import React from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";

class Game extends React.Component{

    constructor(props)  {
        super(props);
    }
    componentDidMount() {
        
    }

    render()    {
        console.log(this.props);
        return (
            <div>Game played is {this.props.gameName}</div>
        );
    }
}

const mapStateToProps = (state, props) => {
    console.log(props);
    return Object.assign({}, state.game, props)
}


export default connect(mapStateToProps)(Game);