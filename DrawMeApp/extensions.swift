//
//  extensions.swift
//  DrawMeApp
//
//  Created by Asmaa Ahmed on 20/12/2021.
//
import Foundation
import PencilKit
import UIKit

extension UIColor {
    func hexStringFromColor() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
//        print(hexString)
        return hexString
     }

    
}

extension String {
    func colorWithHexString() -> UIColor {
        var colorString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {
        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0
        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        return floatValue
    }
    
}

enum ToolName: Codable {
    case pen
    case pencil
    case marker
    
    func getToolByName() -> PKInkingTool.InkType {
        switch self {
        case .pen:
            return .pen
        case .pencil:
            return .pencil
        case .marker:
            return .marker
        }
    }
    
    static func getToolName(tool: PKInkingTool.InkType) -> ToolName {
        switch tool {
        case .pen:
            return .pen
        case .pencil:
            return .pencil
        case .marker:
            return .marker
        default:
            return .pen
        }
    }
}
