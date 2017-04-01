import Cocoa

enum Status {
	case Idle
	case Serving
}

class StatusMenuController: NSObject
{
	var status: Status = .Idle
	let app = AppModel()

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

	let StatusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

	override func awakeFromNib()
	{
		let icon = NSImage(named: "statusicon")
		icon?.isTemplate = true
		StatusItem.image = icon
		StatusItem.menu = statusMenu

		initialize()
		updateStatus()
	}

	private func updateStatus() {
		status = app.contentServer != nil ? .Serving : .Idle
		contentStatusItem.title = "Status: \(status == .Idle ? "Idle" : "Serving")"
		metaStatusItem.title = "Metadata Source: iTunes"
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
