import Cocoa
import IDisposable

enum Status {
	case Idle
	case Serving
}

enum MetaSource {
	case None
	case iTunes
}

class StatusMenuController: NSObject, IDisposable
{
	let StatusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

	let app = AppModel()
	var status: Status { return app.contentServer == nil ? .Idle : .Serving }
	var metaSource: MetaSource { return app.metaServer == nil ? .None : .iTunes }

	@IBOutlet weak var statusMenu: NSMenu!
	@IBOutlet weak var contentStatusItem: NSMenuItem!
	@IBOutlet weak var metaStatusItem: NSMenuItem!
	@IBOutlet weak var controlItem: NSMenuItem!

	@IBAction func quitClicked(_ sender: Any)
	{
		NSApplication.shared().terminate(self)
	}
	
	@IBAction func togglePlayPause(_ sender: Any) {
		if (app.contentServer != nil) {
			app.stopContentServer()
		} else {
			app.startContentServer()
		}

		updateStatus()
	}

	@IBAction func selectiTunesMetaSource(_ sender: Any) {
		app.startMetaServer()
		updateStatus()
	}

	@IBAction func selectNoneMetaSource(_ sender: Any) {
		app.stopMetaServer()
		updateStatus()
	}

	public func dispose()
	{
		app.dispose()
	}

	override func awakeFromNib()
	{
		let appDelegate = NSApplication.shared().delegate as! AppDelegate
		appDelegate.menuController = self

		let icon = NSImage(named: "statusicon")
		icon?.isTemplate = true
		StatusItem.image = icon
		StatusItem.menu = statusMenu

		initialize()
		updateStatus()
	}

	private func updateStatus() {
		contentStatusItem.title = "Status: \(status == .Idle ? "Idle" : "Serving")"
		metaStatusItem.title = "Metadata Source: \(metaSource == .None ? "None" : "iTunes")"
		controlItem.title = status == .Idle ? "Serve" : "Stop"
	}

	private func initialize()
	{
		DispatchQueue.global().async {
			self.app.loadConfig()
			self.app.startContentServer()

			DispatchQueue.main.async {
				self.updateStatus()
			}
		}
	}
}
