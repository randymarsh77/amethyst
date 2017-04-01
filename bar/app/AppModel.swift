import Foundation
import Async
import AsyncProcess
import Awaitables

public class AppModel
{
	var config: AmethystConfig? = nil
	var contentServer: AsyncProcess? = nil
	var metaServer: AsyncProcess? = nil

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
		contentServer = config?.content.createProcess()
		contentServer?.launch()
	}

	public func stopContentServer()
	{
		await (contentServer!.terminate())
		contentServer = nil
	}

	public func startMetaServer()
	{
		metaServer = config?.meta.createProcess()
		metaServer?.launch()
	}
}
