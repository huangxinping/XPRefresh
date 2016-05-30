//
//  UIScrollView+XPRefresh.swift
//  XPRefreshDemo
//
//  Created by xinpinghuang on 5/30/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

import UIKit

public extension UIScrollView {

	// MARK: Veriable
	var headering: Bool {
		get {
			guard let header = viewWithTag(999) else {
				return false
			}
			if (header as! XPBaseRefresh).state == .Refreshing {
				return true
			}
			return false
		}
	}
	var footering: Bool {
		get {
			guard let footer = viewWithTag(998) else {
				return false
			}
			if (footer as! XPBaseRefresh).state == .Refreshing {
				return true
			}
			return false
		}
	}

	// MARK: header
	func headerRefresh(refresh: XPBaseRefresh, refreshCompletion: (Void -> Void)?) {
		refresh.tag = 999
		refresh.refreshCompletion = refreshCompletion
		self.addSubview(refresh)
	}

	func beginHeaderRefreshing() {
		guard let header = viewWithTag(999) else {
			return
		}
		(header as! XPBaseRefresh).state = .Refreshing
	}

	func endHeaderRefreshing() {
		guard let header = viewWithTag(999) else {
			return
		}
		(header as! XPBaseRefresh).state = .Stop
	}

	func removeHeaderRefreshing() {
		guard let header = viewWithTag(999) else {
			return
		}
		(header as! XPBaseRefresh).state = .Finish
	}

	// MARK: footer
	func footerRefresh(refresh: XPBaseRefresh, refreshCompletion: (Void -> Void)?) {
		refresh.tag = 998
		refresh.refreshCompletion = refreshCompletion
		self.addSubview(refresh)
	}

	func beginFooterRefreshing() {
		guard let footer = viewWithTag(998) else {
			return
		}
		(footer as! XPBaseRefresh).state = .Refreshing
	}

	func endFooterRefreshing() {
		guard let footer = viewWithTag(998) else {
			return
		}
		(footer as! XPBaseRefresh).state = .Stop
	}

	func removeFooterRefreshing() {
		guard let footer = viewWithTag(998) else {
			return
		}
		(footer as! XPBaseRefresh).state = .Finish
	}
}