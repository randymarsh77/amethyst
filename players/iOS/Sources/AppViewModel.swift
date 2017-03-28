import AVFoundation
import Foundation
import Async
import Bonjour
import Cancellation
import Crystal
import Fetch
import Scope
import Sockets
import Streams
import Time
import Using
import WKInterop

public class AppModel
{
	public init(_ interop: WKInterop) {
		_interop = interop
		_state = State()
		_state.statusMessage = "Idle"
		_visualizer = VisualizerViewModel(interop)
		_player = V2AudioStreamPlayer()

		_ = _interop.registerEventHandler(route: "js.togglePlayPause") {
			self.togglePlayPause()
		}
		_ = _interop.registerEventHandler(route: "js.ready") {
			self.publishState()
		}

		_ = _interop.registerRequestHandler(route: "cover") {
			return GetCover()
		}

		let session = AVAudioSession.sharedInstance()
		try! session.setCategory(AVAudioSessionCategoryPlayback)
		try! session.setActive(true)

		tryConnect()
	}

	private func tryConnect() {
		let qSettings = QuerySettings(
			serviceType: .Unregistered(identifier: "_crystal"),
			serviceProtocol: .TCP,
			domain: .AnyDomain
		)

		self.setStatusMessage("Searching for services...")

		DispatchQueue.global(qos: .default).async
		{
			let service = await (Bonjour.FindAll(qSettings)).first
			if (service != nil)
			{
				self.setStatusMessage("Found service, attempting to resolve host...")

				await (Bonjour.Resolve(service!))

				let endpoint = service!.getEndpointAddress()!
				self.setStatusMessage("Resolved host to \(endpoint.host) on port \(endpoint.port)")
				let client = TCPClient(endpoint: endpoint)

				using ((try! client.tryConnect())!) { (socket: Socket) in
				using (socket.createAudioStream()) { (audio: ReadableStream<AudioData>) in
					self.setIsPlaying(true)
					socket.pong()
					_ = audio
						.pipe(to: self._player.stream)
//						.convert(to: kAudioFormatLinearPCM)
//						.pipe(to: self._visualizer.stream)

					await (Cancellation(self._playTokenSource!.token))
				}}
			}
			else
			{
				self.setStatusMessage("No services found :(")
			}
		}
	}

	private func togglePlayPause() {
		DispatchQueue.main.async {
			NSLog("Toggling play state")
			if (self._state.isPlaying) {
				self.setIsPlaying(false)
			} else {
				self.tryConnect()
			}
		}
	}

	private func setStatusMessage(_ message: String) {
		DispatchQueue.main.async {
			NSLog("Setting status: %@", message)
			self._state.statusMessage = message
			self.publishState()
		}
	}

	private func setIsPlaying(_ playing: Bool) {
		if (self._state.isPlaying == playing) {
			return
		}

		_playTokenSource?.cancel()
		_playTokenSource = CancellationTokenSource()

		self._state.isPlaying = playing

		DispatchQueue.main.async {
			self.publishState()
		}
	}

	private func publishState() {
		_interop.publish(route: "swift.set.state", content: _state)
	}

	private var _interop: WKInterop
	private var _state: State
	private var _visualizer: VisualizerViewModel
	private var _player: V2AudioStreamPlayer
	private var _playTokenSource: CancellationTokenSource?
}

func GetCover() -> Task<String>
{
	return async { (task: Task<String>) in
		let qSettings = QuerySettings(
			serviceType: .Unregistered(identifier: "_crystal-meta"),
			serviceProtocol: .TCP,
			domain: .AnyDomain
		)

		var result = ""
		DispatchQueue.global(qos: .default).async
		{
			let service = await (Bonjour.FindAll(qSettings)).first
			if (service != nil)
			{
				await (Bonjour.Resolve(service!))

				let endpoint = service!.getEndpointAddress()!
				let url = "http://\(endpoint.host)/art"
				let data = await (Fetch(URL(string: url)!))
				if (data != nil) {
					result = "data:image/png;base64,\(data!.base64EncodedString())"
				}
			}

			Async.Wake(task)
		}

		Async.Suspend()
		return result
	}
}

fileprivate func Cancellation(_ token: CancellationToken) -> Task<Void> {
	let task = async {
		Async.Suspend()
	}
	_ = try! token.register {
		Async.Wake(task)
	}
	return task
}
