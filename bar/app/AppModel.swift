import Foundation
import Async
import AsyncProcess
import Awaitables
import IDisposable

public class AppModel : IDisposable
{
	var config: AmethystConfig? = nil
	var contentServer: AsyncProcess? = nil
	var metaServer: AsyncProcess? = nil

	public func dispose() {
		stopMetaServer()
		stopContentServer()
	}

	public func loadConfig()
	{
		do
		{
			let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
			config = try AmethystConfig.Load(from: AmethystConfig.DefaultConfigPath(inDirectory: currentDirectoryURL))
		}
		catch
		{
			print("Failed to load config: \(error)")
		}
	}

	public func startContentServer()
	{
		if (contentServer != nil) {
			return
		}

		contentServer = config?.content.createProcess()
		contentServer?.launch()
	}

	public func stopContentServer()
	{
		if (contentServer == nil) {
			return
		}

		await (contentServer!.terminate())
		contentServer = nil
	}

	public func startMetaServer()
	{
		if (metaServer != nil) {
			return
		}

		metaServer = config?.meta.createProcess()
		metaServer?.launch()
	}

	public func stopMetaServer()
	{
		if (metaServer == nil) {
			return
		}

		await (metaServer!.terminate())
		metaServer = nil
	}
}
