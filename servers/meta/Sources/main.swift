import Vapor
//import Redbird
import InMemoryCache
import iTunes
import HTTP

//let config = RedbirdConfig(address: "127.0.0.1", port: 6379)
//let redis = try Redbird(config: config)

let drop = Droplet()
let itunes = iTunes.Instance()
let cache = InMemoryCache()

_ = PollingWatcher.Watch(itunes.currentTrack.name.data(using: .utf8)) { value in
	cache.set([ "title" : value ])
}

drop.get("/art") { _ in
	let bytes: Bytes = try itunes.currentTrack.artworks.first!.data.makeBytes()
	return Response(status: .ok, headers: ["Content-Type": "image/png"], body: .data(bytes))
//	return try redis.command("GET", params: ["current"]).toString()
}

drop.get("/meta") { _ in
	let title: String = String(data: cache.get(["title"])["title"]!!, encoding: .utf8)!
	let json = "{ \"title\": \"\(title)\" }".bytes
	return Response(status: .ok, headers: ["Content-Type": "application/json"], body: .data(json))
//	return try redis.command("GET", params: ["current"]).toString()
}

drop.run()
