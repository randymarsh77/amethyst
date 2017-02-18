import Foundation
import Async
import Awaitables
import Time

let contentServer = AsyncProcess("content-server")
let metaServer = AsyncProcess("meta-server")

contentServer.launch()
metaServer.launch()

_ = await (Signals(SIGKILL, SIGINT))

await (contentServer.terminate())
await (metaServer.terminate())

print("bye!")
