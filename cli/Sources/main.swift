import Foundation
import Async
import Awaitables
import Time

let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let rel = CommandLine.arguments[0]
let base = URL(string: rel, relativeTo: currentDirectoryURL)

let csUrl = URL(string: "content-server", relativeTo: base)
let metaUrl = URL(string: "meta-server", relativeTo: base)

let contentServer = AsyncProcess(csUrl!.path)
let metaServer = AsyncProcess(metaUrl!.path)

contentServer.launch()
metaServer.launch()

_ = await (Signals(SIGKILL, SIGINT))

await (contentServer.terminate())
await (metaServer.terminate())

print("Bye!")
