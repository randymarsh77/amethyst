import Foundation
import Async

public class AsyncProcess
{
	public init(_ command: String) {
		_process = Process()
		_process.launchPath = command;
	}

	public init(_ command: String, _ args: [String]) {
		_process = Process()
		_process.launchPath = command;
		_process.arguments = args;
	}

	public func launch()
	{
		_process.launch()
	}

	public var pid: Int32 { return _process.processIdentifier }

	public var exited: Task<Void>
	{
		return async { (task: Task<Void>) in
			DispatchQueue.global().async {
				self._process.waitUntilExit()
				Async.Wake(task)
			}
			Async.Suspend()
		}
	}

	public func terminate()
	{
		_process.terminate()
	}

	public func terminate() -> Task<Void>
	{
		_process.terminate()
		return exited
	}

	let _process: Process
}
