import Foundation
import Crystal
import Spectrum
import Streams
import WKInterop

public class VisualizerViewModel
{
	public var stream: WriteableStream<AudioData>

	public init(_ interop: WKInterop)
	{
		_interop = interop

		let s = Streams.Stream<AudioData>()
		_ = s
			.map { ad in return ad.data }
			.spectralize(to: Spectrum.Default)
			.subscribe { fdv in
				interop.publish(route: "visualizer.stream", content: "")
			}
		stream = WriteableStream(s)
	}

	private var _interop: WKInterop
}
