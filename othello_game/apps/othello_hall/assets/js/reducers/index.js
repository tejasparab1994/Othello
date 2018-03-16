import { combineReducers }  from 'redux';
import { routerReducer }    from 'react-router-redux';
import session              from './session';
import lobby                 from './lobby';
import game                 from './game';


export default combineReducers({
  routing: routerReducer,
  session: session,
  lobby: lobby,
  game: game
});
