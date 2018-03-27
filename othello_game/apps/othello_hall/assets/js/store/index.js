import { createStore, applyMiddleware } from 'redux';
import createLogger                     from 'redux-logger';
import thunkMiddleware                  from 'redux-thunk';
import { routerMiddleware }             from 'react-router-redux';
import reducers                         from  '../reducers';


var middlewares = [];
const loggerMiddleware = createLogger({
  level: 'info',
  collapsed: true,
});

if (process.env.NODE_ENV === `development`) {
     middlewares.push(loggerMiddleware);
}

middlewares.push(thunkMiddleware);

export default function configureStore(browserHistory) {
  const createStoreWithMiddleware = applyMiddleware(...middlewares)(createStore);
  return createStoreWithMiddleware(reducers);
}
