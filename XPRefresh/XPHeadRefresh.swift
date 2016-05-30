//
//  XPHeadRefresh.swift
//  XPRefreshDemo
//
//  Created by xinpinghuang on 5/30/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

import UIKit

public class XPHeadRefresh: XPBaseRefresh {

	private var indicator: UIActivityIndicatorView
	private var arrow: UIImageView

	convenience init() {
		self.init(frame: CGRectMake(0, -80, 0, 80))
	}

	override init(frame: CGRect) {
		self.arrow = UIImageView(frame: CGRectMake(0, 0, 30, 30))
		self.arrow.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
		self.arrow.image = XPRefreshKit.imageOfArrow

		self.indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
		self.indicator.bounds = CGRectMake(0, 0, 30, 30)
		self.indicator.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
		self.indicator.hidesWhenStopped = true

		super.init(frame: frame)

		self.addSubview(indicator)
		self.addSubview(arrow)
		self.autoresizingMask = .FlexibleWidth

		self.style = .Header
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		self.arrow.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
		self.indicator.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
	}

	override func start() {
		super.start()
		self.arrow.hidden = true
		self.indicator.startAnimating()
	}

	override func pulling() {
		super.pulling()

		UIView.animateWithDuration(0.2) {
			self.arrow.transform = CGAffineTransformIdentity
		}
	}

	override func triggered() {
		super.triggered()

		UIView.animateWithDuration(0.2, delay: 0, options: [], animations: {
			// -0.0000001 for the rotation direction control
			self.arrow.transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.0000001))
			}, completion: nil)
	}

	override func stop() {
		super.stop()
		self.indicator.stopAnimating()
		self.arrow.hidden = false
		UIView.animateWithDuration(0.5, animations: {
			self.arrow.transform = CGAffineTransformIdentity
		}) { _ in
		}
	}

	override func finish() {
		super.finish()
	}

	override func contentOffsetY(offset: CGFloat) {
		var alpha = fabs(offset) / (self.frame.size.height + 40)
		if alpha > 0.8 {
			alpha = 0.8
		}
		self.arrow.alpha = alpha
	}

}