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
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, `defer`: flag)
        internalInit()
    }

    override var canBecomeMainWindow: Bool {
        return true
    }

    override var canBecomeKeyWindow: Bool {
        return true
    }
}
