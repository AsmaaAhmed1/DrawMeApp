//
//  Models.swift
//  DrawMeApp
//
//  Created by Asmaa Ahmed on 20/12/2021.
//

import Foundation

struct Stroke: Codable {
    var strokeId: Int
    var inkTool: ToolName
    var inkColor: String
    var points: [Point]
}

