//
//  XPBaseRefresh.swift
//  XPRefreshDemo
//
//  Created by xinpinghuang on 5/30/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

import UIKit

internal enum RefreshStyle {
	case Header
	case Footer
}

public class XPBaseRefresh: UIView, XPRefreshProtocol {

	private var scrollViewBounces: Bool = false
	private var scrollViewInsets: UIEdgeInsets = UIEdgeInsetsZero
	internal var refreshCompletion: (Void -> Void)?

	private let contentOffsetKeyPath = "contentOffset"
	private let contentSizeKeyPath = "contentSize"
	private var kvoContext = "XPKVOContext"
	internal var style: RefreshStyle = .Header
	private var positionY: CGFloat = 0 {
		willSet {
			if self.positionY == newValue {
				return
			}
			self.positionY = newValue
			var frame = self.frame
			frame.origin.y = newValue
			self.frame = frame
			self.layoutSubviews()
		}
	}

	internal var state: XPRefreshState = .Pulling {
		didSet {
			if self.state == oldValue {
				return
			}
			switch self.state {
			case .Stop:
				self.stop()
			case .Finish:
				self.finish()
			case .Refreshing:
				self.start()
			case .Pulling:
				self.pulling()
			case .Triggered:
				self.triggered()
			}
		}
	}

	func start() {
		guard let scrollView = superview as? UIScrollView else {
			return
		}
		self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: scrollView.frame.size.width, height: self.frame.size.height)

		scrollViewBounces = scrollView.bounces
		scrollViewInsets = scrollView.contentInset

		var insets = scrollView.contentInset
		if self.style == .Header {
			insets.top += self.frame.size.height
		} else {
			insets.bottom += self.frame.size.height
		}
		UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
			if self.style == .Header {
				scrollView.contentOffset.y = -insets.top
			} else {
				scrollView.contentOffset.y = scrollView.contentSize.height + insets.bottom
			}
			scrollView.contentInset = insets
			}, completion: { _ in
			self.refreshCompletion?()
		})
	}

	func pulling() {
	}

	func triggered() {
	}

	func stop() {
		guard let scrollView = superview as? UIScrollView else {
			return
		}
		scrollView.bounces = self.scrollViewBounces
		UIView.animateWithDuration(0.5, animations: {
			scrollView.contentInset = self.scrollViewInsets
			}
		) { _ in
			self.state = .Pulling
		}
	}

	func finish() {
		var duration = 0.5
		var time = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
		dispatch_after(time, dispatch_get_main_queue()) {
			self.stop()
		}
		duration = duration * 2
		time = dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Double(NSEC_PER_SEC)))
		dispatch_after(time, dispatch_get_main_queue()) {
			self.removeFromSuperview()
		}
	}

	func contentOffsetY(offset: CGFloat) {
	}

	convenience init() {
		self.init(frame: CGRectMake(0, -80, 0, 80))
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func willMoveToSuperview(newSuperview: UIView?) {
		self.removeRegister()
		guard let scrollView = newSuperview else {
			return
		}
		if self.style == .Header {
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, scrollView.frame.size.width, self.frame.size.height)
		} else {
			self.frame = CGRectMake(0, (scrollView as! UIScrollView).contentSize.height, scrollView.frame.size.width, self.frame.size.height)
		}
		scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .Initial, context: &kvoContext)
		if self.style == .Footer {
			scrollView.addObserver(self, forKeyPath: contentSizeKeyPath, options: .Initial, context: &kvoContext)
		}
	}

	func removeRegister() {
		if let scrollView = self.superview as? UIScrollView {
			scrollView.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &kvoContext)
			if self.style == .Footer {
				scrollView.removeObserver(self, forKeyPath: contentSizeKeyPath, context: &kvoContext)
			}
		}
	}

	deinit {
		self.removeRegister()
	}

	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
		guard let scrollView = object as? UIScrollView else {
			return
		}

		if keyPath == contentSizeKeyPath {
			self.positionY = scrollView.contentSize.height
			return
		}
		if !(context == &kvoContext && keyPath == contentOffsetKeyPath) {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
			return
		}

		let offsetY = scrollView.contentOffset.y
		self.contentOffsetY(offsetY)
		if self.style == .Header {
			if offsetY < 0 && offsetY < -self.frame.size.height {
				if scrollView.dragging == false && self.state != .Refreshing {
					self.state = .Refreshing
				} else if self.state != .Refreshing {
					self.state = .Triggered
				}
				else if self.state == .Triggered {
					self.state = .Pulling
				}
			} else {
				if self.state == .Triggered {
					self.state = .Stop
				}
			}
		} else {
			if offsetY <= 0 {
				return
			}
			let upHeight = offsetY + scrollView.frame.size.height - scrollView.contentSize.height
			if upHeight > 0 {
				if upHeight > self.frame.size.height {
					if scrollView.dragging == false && self.state != .Refreshing {
						self.state = .Refreshing
					} else if self.state != .Refreshing { self.state = .Triggered
					}
				} else if self.state == .Triggered {
					self.state = .Pulling
				}
			}
		}
	}

}