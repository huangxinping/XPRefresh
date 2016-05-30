//
//  ViewController.swift
//  XPRefreshDemo
//
//  Created by xinpinghuang on 5/30/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		tableView.headerRefresh(XPHeadRefresh()) { _ in
			print("head refreshing")
			let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
			dispatch_after(time, dispatch_get_main_queue()) {
				self.tableView.endHeaderRefreshing()
			}
		}
		tableView.footerRefresh(XPFootRefresh()) { _ in
			print("foot refreshing")
			let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
			dispatch_after(time, dispatch_get_main_queue()) {
				self.tableView.removeFooterRefreshing()
			}
		}
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		tableView.beginHeaderRefreshing()
//        tableView.beginFooterRefreshing()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
		cell?.textLabel?.text = "Title:\(indexPath.row)"
		if indexPath.row == 19 && !tableView.footering {
			tableView.beginFooterRefreshing()
		}
		return cell!
	}

}

