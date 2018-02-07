//
//  ViewController.swift
//  Heart
//
//  Created by josh on 31/01/2018.
//  Copyright (c) 2018 Joshua Webb. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var gripHandle: NSImageView!
    // TODO: does this guy leak memory by caching resized images?
    //       are those ever reclaimed?
    @IBOutlet weak var mainImageView: NSImageView!

    var isLocked = false
    var cursor: NSCursor = NSCursor.resizeNorthWestSouthEastCursor()

    var gripHandleEnabled = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func toggleResizeHandle() {
        gripHandleEnabled = !gripHandleEnabled
        gripHandle.hidden = !gripHandleEnabled
        view.window!.invalidateShadow()
    }

    override func rightMouseDown(theEvent: NSEvent) {
        if (self.isLocked) {
            return
        }

        toggleResizeHandle()
    }

    var isDragging: Bool = false
    var isResize: Bool = false
    var initialWidth: CGFloat = 0
    var initialLocation: NSPoint? = nil

    override func mouseDown(theEvent: NSEvent) {
        if (self.isLocked) {
            return
        }

        super.mouseDown(theEvent)

        self.isResize = gripHandle.hitTest(theEvent.locationInWindow) != nil
        self.isDragging = mainImageView.hitTest(theEvent.locationInWindow) != nil
        self.initialWidth = self.view.window!.frame.width
        self.initialLocation = theEvent.locationInWindow
    }

    override func mouseDragged(theEvent: NSEvent) {
        if (self.isLocked) {
            return
        }

        super.mouseDragged(theEvent)
        if initialLocation == nil {
            return
        }

        if (isResize) {
            self.view.window!.disableCursorRects()
            resizeWindow(theEvent)
        } else {
            dragWindow(theEvent)
        }
    }

    func resizeWindow(theEvent: NSEvent) {
        if (self.isLocked) {
            return
        }

        var screenFrame = NSScreen.mainScreen()!.frame
        var currentFrame = self.view.window!.frame
        let minSize = self.view.window!.minSize

        let currentLocation = theEvent.locationInWindow
        let xDiff = (currentLocation.x - initialLocation!.x)
        let yDiff = (currentLocation.y - initialLocation!.y)

        // Due to the coordinate system used by Apple, the
        // y coordinate is constantly updated in the opposite
        // direction so that the resize handle stays with the
        // cursor, the coordinate does not move.
        let newWidth = max(initialWidth + xDiff, minSize.width)
        let newHeight = max(currentFrame.size.height - yDiff, minSize.height)
        let actualYDiff = currentFrame.size.height - newHeight
        let newYCoordinate = currentFrame.origin.y + actualYDiff

        let newFrame = NSRect(
            x: currentFrame.origin.x,
            y: newYCoordinate,
            width: newWidth,
            height: newHeight)

        self.view.window!.setFrame(newFrame, display: true)
    }

    func dragWindow(theEvent: NSEvent) {
        if (self.isLocked) {
            return
        }

        var screenFrame = NSScreen.mainScreen()!.frame
        var windowFrame = self.view.window!.frame
        var newOrigin = windowFrame.origin

        let currentLocation = theEvent.locationInWindow
        newOrigin.x += (currentLocation.x - initialLocation!.x)
        newOrigin.y += (currentLocation.y - initialLocation!.y)

        self.view.window!.setFrameOrigin(newOrigin)
    }

    override func mouseUp(theEvent: NSEvent) {
        initialLocation = nil
        if (isResize) {
            self.view.window!.enableCursorRects()
        }
        isResize = false
    }
}

