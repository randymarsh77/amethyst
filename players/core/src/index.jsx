import React from 'react';
import { render } from 'react-dom';
import { autobind } from 'core-decorators';
import WKInterop from 'wkinterop';
import Assets from './assets';
import './styles.less';

const { PauseIcon, PlayIcon } = Assets;
const wkinterop = WKInterop.Install();

@autobind
class App extends React.Component {

	componentWillMount() {
		this.setState({
			statusMessage: 'No communication yet',
			isPlaying: false,
			cover: 'http://localhost:8080/art',
		});
	}

	componentDidMount() {
		wkinterop.registerEventHandler('visualizer.stream', (data) => {
			console.log('viz: ', data);
		});
		wkinterop.registerEventHandler('swift.set.state', (newState) => {
			this.setState(newState);
		});
		wkinterop.publish('js.ready');

		wkinterop.request('cover').then(cover => this.setState({
			cover,
		}));
	}

	componentWillUnmount() {
	}

	componentDidUpdate() {
	}

	togglePlayPause() {
		wkinterop.publish('js.togglePlayPause');
	}

	render() {
		return (
			<div className="root">
				<div className="art-container">
					<img src={this.state.cover} alt="boohoo" className="cover-blur" />
				</div>
				<div className="app-container">
					<img src={this.state.cover} alt="boohoo" className="cover" />
					<div className="button-container">
						<button onClick={this.togglePlayPause} className="button">
							<img alt="boohoo" src={this.state.isPlaying ? PauseIcon : PlayIcon} />
						</button>
					</div>
					<div className="status-container">
						<p className="status">{this.state.statusMessage}</p>
					</div>
				</div>
			</div>
		);
	}
}

render((
	<App className="fill" />
), document.getElementById('app'));
