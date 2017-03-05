import Foundation
import Async
import Awaitables
import Time

do
{
	let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
	let config = try AmethystConfig.Load(from: AmethystConfig.DefaultConfigPath(inDirectory: currentDirectoryURL))

	let contentServer = config.content.createProcess()
	let metaServer = config.meta.createProcess()

	contentServer.launch()
	metaServer.launch()

	_ = await (Signals(SIGKILL, SIGINT))

	await (contentServer.terminate())
	await (metaServer.terminate())

	print("Bye!")
}
catch
{
	print("Fatal: \(error)")
	exit(1)
}
