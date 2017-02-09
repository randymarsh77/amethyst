import Foundation
import InMemoryCache
import Scope

public class PollingWatcher
{
	public static func Watch(_ getValue: @escaping @autoclosure () -> Data?, _ onChange: @escaping (Data?) -> ()) -> Scope {
		var keepWatching = true
		let cache = InMemoryCache()
		let subscription = cache.subscribe(keys: [ .Exact("value") ]) { keysAndValues in
			onChange(keysAndValues["value"]!)
		}
		DispatchQueue.global(qos: .default).async {
			while (keepWatching) {
				cache.set([ "value" : getValue() ])
				sleep(1)
			}
		}
		return Scope {
			keepWatching = false
			subscription.dispose()
		}
	}
}
