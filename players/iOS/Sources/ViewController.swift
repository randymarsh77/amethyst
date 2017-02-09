//
//  ViewController.swift
//  player
//
//  Created by Matthew Preucil on 9/29/16.
//  Copyright © 2016 Marsh Inc. All rights reserved.
//

import UIKit
import WebKit
import Async
import Cancellation
import Gloss
import GlossSerializer
import WKInterop

class AssetLoader : URLProtocol
{
	// Experimenting with custom asset urls
	override class func canInit(with: URLRequest) -> Bool {
		print("Request: URL = \(with.url!.absoluteString)")
		return false
	}
}

class ViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate
{
	override func viewDidLoad() {
		super.viewDidLoad()

		let serializer = GlossSerializer()

		_interop = WKInterop(serializer: serializer) { config in
			WKWebView(frame: self.view.bounds, configuration: config)
		}
		_model = AppModel(_interop!)

		let webView = _interop!.view
		webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		webView.navigationDelegate = self
		self.view.addSubview(webView)

		let url = URL(fileURLWithPath: Bundle.main.path(forResource: "index", ofType: "html")!)
		webView.loadFileURL(url, allowingReadAccessTo: URL(fileURLWithPath: Bundle.main.bundlePath))
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return nil
	}

	func webView(_ webView: WKWebView,
	             didStartProvisionalNavigation navigation: WKNavigation!){
		print("start: \(navigation)")
	}

	func webView(_ webView: WKWebView,
	             decidePolicyFor navigationAction: WKNavigationAction,
	             decisionHandler: @escaping (WKNavigationActionPolicy) -> Void){
		print("decide: \(navigationAction.request.url!)")
		decisionHandler(.allow)
	}

	private var _interop: WKInterop?
	private var _model: AppModel?
}

