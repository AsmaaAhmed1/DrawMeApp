//
//  Point.swift
//  DrawMeApp
//
//  Created by Asmaa Ahmed on 20/12/2021.
//

import Foundation
import PencilKit

struct Point: Codable {
    var location: CGPoint
    var timeOffset: TimeInterval
    var size: CGSize
    var altitude: CGFloat
    var azimuth: CGFloat
    var force: CGFloat
    var opacity: CGFloat
}
