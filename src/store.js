import { browserHistory } from "react-router";
import { routerMiddleware } from "react-router-redux";
import { compose, createStore, applyMiddleware } from "redux";
import thunk from "redux-thunk";
import persistState from "redux-localstorage";

import reducer from "./reducers";
import { getAuthToken } from "./accessors";

export const getStore = () => {
  const slicer = paths => {
    return state => {
      return Object.assign({}, {
        dropbox: {
          authToken: getAuthToken(state)
        }
      });
    };
  };

  return createStore(
    reducer,
    window.__REDUX_DEVTOOLS_EXTENSION__ &&
      window.__REDUX_DEVTOOLS_EXTENSION__(),
    // TODO: Consider raven-for-redux middleware
    compose(
      persistState("dropbox", { slicer }),
      applyMiddleware(thunk, routerMiddleware(browserHistory))
    )
  );
};
