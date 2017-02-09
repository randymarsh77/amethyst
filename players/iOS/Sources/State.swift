import Foundation
import Gloss

public enum PlayState
{
	case Connected
	case WaitingToDisconnect
	case Disconnected
}

public struct State : Encodable
{
	public var statusMessage: String?
	public var isPlaying: Bool = false
	public var cover: String?

	public func toJSON() -> JSON? {
		return jsonify([
			"statusMessage" ~~> self.statusMessage,
			"isPlaying" ~~> self.isPlaying,
			"cover" ~~> self.cover
		])
	}
}
