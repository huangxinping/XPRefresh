//
//  XPRefreshStateProtocol.swift
//  XPRefreshDemo
//
//  Created by xinpinghuang on 5/30/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

import UIKit

internal protocol XPRefreshProtocol {
	func pulling()
	func start()
	func triggered()
	func stop()
	func finish()
	func contentOffsetY(offset: CGFloat)
}
