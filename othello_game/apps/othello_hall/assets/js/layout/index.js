import React from 'react';

export default class MainLayout extends React.Component {
    constructor() {
        super();
    }

    render() {
        console.log("Main layout has been called");
        return (this.props.children);
    }
}
