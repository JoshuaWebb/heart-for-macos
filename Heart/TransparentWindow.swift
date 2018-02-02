import Foundation
import Cocoa

class TransparentWindow: NSWindow {
    func internalInit() {
        self.backgroundColor = NSColor.clearColor()
        self.opaque = false
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .Hidden

        self.styleMask = NSBorderlessWindowMask
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        internalInit()
    }

    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag)
        internalInit()
    }

    override var canBecomeKeyWindow: Bool {
        return true
    }

    func toggleResizeHandle() {
        // TODO: display a resize control/grab handle
        NSLog("TODO: toggleResizeHandle")
    }

    override func rightMouseDown(theEvent: NSEvent) {
        NSLog("rightMouseDown")
        toggleResizeHandle()
    }

    var initialLocation: NSPoint? = nil

    override func mouseDown(theEvent: NSEvent) {
        self.initialLocation = theEvent.locationInWindow
    }

    override func mouseDragged(theEvent: NSEvent) {
        if initialLocation == nil {
            return
        }

        var screenFrame = NSScreen.mainScreen()!.frame
        var windowFrame = frame
        var newOrigin = windowFrame.origin

        let currentLocation = theEvent.locationInWindow
        newOrigin.x += (currentLocation.x - initialLocation!.x)
        newOrigin.y += (currentLocation.y - initialLocation!.y)

        setFrameOrigin(newOrigin)
    }

    override func mouseUp(theEvent: NSEvent) {
        initialLocation = nil
    }
}
