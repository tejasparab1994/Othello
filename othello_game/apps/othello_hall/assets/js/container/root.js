import React from 'react';
import {Provider} from 'react-redux';
import {Router, Route} from 'react-router';
import { ConnectedRouter } from 'react-router-redux'
import invariant from 'invariant';
import {RoutingContext} from 'react-router';
// import {MainLayout} from '../layout/index';
import LobbyView from '../views/lobby';


export default class Root extends React.Component {
    _renderRouter() {
        console.log("Root is called");
        invariant(this.props.routerHistory,
            '<Root /> needs either a routingContext or routerHistory to render.'
        );

        return (
            <Router history={this.props.routerHistory}>
                <div>
                    <Route path="/games/new" component={LobbyView}/>
                </div>
            </Router>
    );
    }

    render() {
        const {store} = this.props;

        return (
            <Provider store={store}>
                {this._renderRouter()}
            </Provider>
        );
    }
}
