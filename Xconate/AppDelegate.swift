//
//  AppDelegate.swift
//  Xconate
//
//  Created by Leo Dion on 1/22/20.
//  Copyright © 2020 BrightDigit. All rights reserved.
//

import Cocoa
import SwiftUI
import SwiftDraw

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow!


  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()

    // Create the window and set the content view.
    let url = Bundle.main.url(forResource: "tshirt", withExtension: "svg")!
    let image = SwiftDraw.Image(fileURL: url)!
   
    let pdfDocument = CGPDFDocument(CGDataProvider(data: image.pdfData()! as CFData)!)!
    //let data = image.pngData(size: nil, scale: 2)
    
   //let nsImage = image.rasterize()
//    nsImage.backgroundColor = .orange
    
    //let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    
    
    let width = Int(image.size.width)
    let height = Int(image.size.height)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel * width
    let rawData = malloc(height * bytesPerRow)
    let bitsPerComponent = 8
   let context = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)!
    let pdfData = NSMutableData()
    var rect = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
    let pdfContext = CGContext(consumer: CGDataConsumer(data: pdfData as CFMutableData)!, mediaBox: &rect, nil)!
    pdfContext.beginPage(mediaBox: &rect)
    pdfContext.drawPDFPage(pdfDocument.page(at: 1)!)
    pdfContext.endPage()
    pdfContext.closePDF()
    
    let fillColor : NSColor = .orange
    context.setFillColor(red: fillColor.redComponent, green: fillColor.greenComponent, blue: fillColor.blueComponent, alpha: fillColor.alphaComponent)
    context.fill(rect)
    ///context.setFillColor(red: .orange, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    let flip = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: rect.size.height)
    context.concatenate(flip)
    context.draw(image)
    //context.drawPDFPage(pdfDocument.page(at: 1)!)
    
    let cgImage = context.makeImage()!
    let bitmap = NSBitmapImageRep(cgImage: cgImage)
    
    let data = bitmap.representation(using: .png, properties: [NSBitmapImageRep.PropertyKey : Any]())
    
    //let bitmap = image.createBitmap()!
    //let nsImage = NSImage(size: bitmap.size)
    
    let destinationUrl = URL(fileURLWithPath: "tshirt.png")
    let destinationPdfUrl = URL(fileURLWithPath: "tshirt.pdf")
    debugPrint(destinationUrl)
    try! data!.write(to: destinationUrl)
    try! pdfData.write(to: destinationPdfUrl)
    window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

