import Foundation
import Bonjour
import Crystal
import Time
import Using

let port = 7331
let settings = BroadcastSettings(
	name: "CrystalContent",
	serviceType: .Unregistered(identifier: "_crystal-content"),
	serviceProtocol: .TCP,
	domain: .AnyDomain,
	port: Int32(port))

using (AudioStreamGenerator()) { (generator: AudioStreamGenerator) in
using (StreamServer(stream: generator.stream, port: UInt16(port))) {
using (Bonjour.Broadcast(settings)) {
	getchar()
}}}
