import Foundation
import Gloss

public enum ProcessConfigError : Error
{
	case InvalidPath(path: String)
	case UnreachablePath(path: String)
}

public enum AmethystConfigError : Error
{
	case InvalidJsonConfig(json: String)
	case ContentServerError(error: Error)
	case MetaServerError(error: Error)
	case ControlServerError(error: Error)
}

public final class ProcessConfig: Glossy
{
	public var name: String
	public var location: URL

	public var executableUrl: URL

	public var launchCommand: String { return executableUrl.path }

	public init(name: String, location: URL)
	{
		self.name = name
		self.location = location
		executableUrl = URL(fileURLWithPath: "\(location.path)/\(name)")
	}

	public init?(json: JSON)
	{
		if let name = json["name"] as? String {
			self.name = name
		}
		else {
			return nil
		}

		if let jsonLocation = json["location"] as? String {
			location = URL(fileURLWithPath: jsonLocation)
		} else {
			location = URL(fileURLWithPath: ".")
		}

		executableUrl = URL(fileURLWithPath: "\(location.path)/\(name)")
	}

	public func toJSON() -> JSON? {
		return jsonify([
			"name" ~~> self.name,
			"location" ~~> self.location,
		])
	}
}

public final class AmethystConfig : Glossy
{
	public var content: ProcessConfig
	public var meta: ProcessConfig
	public var control: ProcessConfig

	public init?(json: JSON)
	{
		if let contentJson = json["content"] as? JSON {
			content = ProcessConfig(json: contentJson) ?? AmethystConfig.DefaultContentConfig
		} else {
			content = AmethystConfig.DefaultContentConfig
		}

		if let metaJson = json["meta"] as? JSON {
			meta = ProcessConfig(json: metaJson) ?? AmethystConfig.DefaultMetaConfig
		} else {
			meta = AmethystConfig.DefaultMetaConfig
		}

		if let controlJson = json["control"] as? JSON {
			control = ProcessConfig(json: controlJson) ?? AmethystConfig.DefaultControlConfig
		} else {
			control = AmethystConfig.DefaultControlConfig
		}
	}

	public func toJSON() -> JSON? {
		return jsonify([
			"content" ~~> self.content,
			"meta" ~~> self.meta,
			"control" ~~> self.control,
		])
	}
}

fileprivate extension AmethystConfig
{
	fileprivate static let Default = AmethystConfig(json: [:])!

	fileprivate static func From(_ json: JSON) -> AmethystConfig {
		return AmethystConfig(json: json) ?? AmethystConfig.Default
	}

	fileprivate static let DefaultContentConfig = ProcessConfig(name: "content-server", location: URL(fileURLWithPath: "."))

	fileprivate static let DefaultMetaConfig = ProcessConfig(name: "meta-server", location: URL(fileURLWithPath: "."))

	fileprivate static let DefaultControlConfig = ProcessConfig(name: "control-server", location: URL(fileURLWithPath: "."))
}

public extension AmethystConfig
{
	public static func DefaultConfigPath(inDirectory: URL) -> URL {
		return URL(fileURLWithPath: "\(inDirectory.path)/.amethyst")
	}

	public static func Load(from: URL) throws -> AmethystConfig {
		let data = try Data(contentsOf: from)
		let jobj = try JSONSerialization.jsonObject(with: data)
		guard let json = jobj as? JSON else {
			throw AmethystConfigError.InvalidJsonConfig(json: String(data: data, encoding: String.Encoding.utf8)!)
		}

		let config = AmethystConfig(json: json) ?? Default
		try config.verify()
		return config
	}

	public static func LoadDefault() throws -> AmethystConfig {
		let config = Default
		try config.verify()
		return config
	}

	fileprivate func verify() throws {
		do { try content.verify() } catch {
			throw AmethystConfigError.ContentServerError(error: error)
		}
		do { try meta.verify() } catch {
			throw AmethystConfigError.MetaServerError(error: error)
		}
//		do { try control.verify() } catch {
//			throw AmethystConfigError.ControlServerError(error: error)
//		}
	}
}

public extension ProcessConfig
{
	public func createProcess() -> AsyncProcess
	{
		return AsyncProcess(launchCommand)
	}

	fileprivate func verify() throws {
		guard (try? URL(fileURLWithPath: executableUrl.path).checkResourceIsReachable()) != nil else {
			throw ProcessConfigError.UnreachablePath(path: executableUrl.path)
		}
	}
}
