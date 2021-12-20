//
//  ViewController.swift
//  DrawMeApp
//
//  Created by Asmaa Ahmed on 19/12/2021.
//

import UIKit
import PencilKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: PKCanvasView!
    
    let toolPicker = PKToolPicker()
    var strokes = [Stroke]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvasView()
        setupToolPicker()
        readData()
    }


    func setupCanvasView() {
        canvasView.delegate = self
    }
    
    func setupToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView) // This will change the visibility of toolPicker for multiple views if there.
        toolPicker.addObserver(self) // ViewController should implement PKToolPickerObserver to detect the changes in toolPicker configurations
        canvasView.becomeFirstResponder()
    }
    
    func writeData() {
        if let encodedData = try? JSONEncoder().encode(strokes) {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("jsonfile.json")
            guard let path = url else {return}
            if !FileManager.default.fileExists(atPath: path.absoluteString) {
                FileManager.default.createFile(atPath: path.path, contents: encodedData, attributes: nil)
            }
            do {
                try encodedData.write(to: path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func readData() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("jsonfile.json")
        guard let path = url else {return}
        do {
            let data = try Data(contentsOf: path)
            let resultedStrokes = try JSONDecoder().decode([Stroke].self, from: data)
            setupDrawing(strokes: resultedStrokes)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func setupDrawing(strokes: [Stroke]) {
        strokes.forEach { stroke in
            var pkPoints = [PKStrokePoint]()
            stroke.points.forEach({ point in
                let pkPoint = PKStrokePoint(location: point.location, timeOffset: point.timeOffset, size: point.size, opacity: point.opacity, force: point.force, azimuth: point.azimuth, altitude: point.altitude)
                pkPoints.append(pkPoint)
            })
            let path = PKStrokePath(controlPoints: pkPoints, creationDate: Date())
            let canvasStroke = PKStroke(ink: PKInk(stroke.inkTool.getToolByName(), color: stroke.inkColor.colorWithHexString()), path: path)
            canvasView.drawing.strokes.append(canvasStroke)
        }
    }
    
}

extension ViewController: PKCanvasViewDelegate {
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if let stroke = canvasView.drawing.strokes.last {
            var points = [Point]()
            for pathRange in stroke.maskedPathRanges {
                for pkPoint in stroke.path.interpolatedPoints(in: pathRange, by: .distance(10)) {
                    let point = Point(location: pkPoint.location, timeOffset: pkPoint.timeOffset, size: pkPoint.size, altitude: pkPoint.altitude, azimuth: pkPoint.azimuth, force: pkPoint.force, opacity: pkPoint.opacity)
                    points.append(point)
                }
            }
            strokes.append(Stroke(strokeId: strokes.last?.strokeId ?? 1, inkTool: ToolName.getToolName(tool: stroke.ink.inkType), inkColor: stroke.ink.color.hexStringFromColor(), points: points))
            writeData()
        }
    }
}

extension ViewController: PKToolPickerObserver {
    func toolPickerSelectedToolDidChange(_ toolPicker: PKToolPicker) {
        self.canvasView.tool = toolPicker.selectedTool
    }
}
