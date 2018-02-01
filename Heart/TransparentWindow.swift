import Foundation
import Cocoa

class TransparentWindow: NSWindow {
    func internalInit() {
        self.backgroundColor = NSColor.clearColor()
        self.opaque = false
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .Hidden
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        internalInit()
    }
    
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, `defer`: flag)
        internalInit()
    }
}
