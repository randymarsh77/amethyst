import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
	var menuController: StatusMenuController? = nil

	func applicationDidFinishLaunching(_ aNotification: Notification)
	{
	}

	func applicationWillTerminate(_ aNotification: Notification)
	{
		self.menuController?.dispose()
	}
}
