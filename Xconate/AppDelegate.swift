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
    //let data = image.pngData(size: nil, scale: 2)
    let nsImage = image.rasterize()
    nsImage.backgroundColor = .orange
    let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    let bitmap = NSBitmapImageRep(cgImage: cgImage)
    let data = bitmap.representation(using: .png, properties: [NSBitmapImageRep.PropertyKey : Any]())
    
    //let bitmap = image.createBitmap()!
    //let nsImage = NSImage(size: bitmap.size)
    
    let destinationUrl = URL(fileURLWithPath: "tshirt.png")
    debugPrint(destinationUrl)
    try! data!.write(to: destinationUrl)
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

