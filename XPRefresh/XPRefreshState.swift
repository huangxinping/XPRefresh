//
//  XPRefreshState.swift
//  XPRefreshDemo
//
//  Created by xinpinghuang on 5/30/16.
//  Copyright © 2016 huangxinping. All rights reserved.
//

import Foundation

internal enum XPRefreshState {
	case Pulling
	case Triggered
	case Refreshing
	case Stop
	case Finish
}