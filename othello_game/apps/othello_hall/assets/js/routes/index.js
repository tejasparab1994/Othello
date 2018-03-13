import { IndexRoute, Route }  from 'react-router';
import React                  from 'react';
import {MainLayout} from '../layout/index';
import {LobbyView} from '../views/lobby';

export function configRoutes(store) {
    return (
        <Route component={MainLayout}>
            <Route path="/" component={LobbyView}/>
            <Route path="/games/new" component={LobbyView}/>
        </Route>
    );
}
