#if os(iOS)
import ObjectiveC
import UIKit
import os
import Combine

private var hasSwizzled = false
private var key = 0

extension UIWindow {
    public func setupSwizzle() {
        guard !hasSwizzled else { return }
        
        guard let sendEvent = class_getInstanceMethod(
            object_getClass(self),
            #selector(UIApplication.sendEvent(_:))
        ) else {
            return
        }
        let swizzledSendEvent = class_getInstanceMethod(
            object_getClass(self),
            #selector(UIWindow.swizzled_sendEvent(_:))
        )
        method_exchangeImplementations(sendEvent, swizzledSendEvent!)
        
        hasSwizzled = true
    }
}

// MARK: - Swizzle
extension UIWindow {
    @objc public func swizzled_sendEvent(_ event: UIEvent) {
        TouchEventController.shared.sendEvent(event)
        swizzled_sendEvent(event)
    }
}
#endif
