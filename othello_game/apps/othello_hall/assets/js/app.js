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
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".
// import socket from "./socket"

// The configuration for react-redux and organization of the code
// structure has been inspired from
// 
import React                    from 'react';
import ReactDOM                 from 'react-dom';
import { createBrowserHistory } from 'history';
import { syncHistoryWithStore } from 'react-router-redux';
import configureStore           from './store';
import Root                     from './container/root';

const browserHistory = createBrowserHistory();
const store  = configureStore(browserHistory);
const history = syncHistoryWithStore(browserHistory, store);


const target = document.getElementById('main_container');

if (target != null) {
    const node = <Root routerHistory={history} store={store}/>;
    ReactDOM.render(node, target);
}