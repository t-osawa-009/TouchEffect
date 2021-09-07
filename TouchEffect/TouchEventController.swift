#if os(iOS)
import UIKit

public class TouchEventController {
    public struct Config {
        public var isActive = true
        public var color: UIColor = Color.blue
        public var duration: TimeInterval = 0.1
        public struct Color {
            public static let blue: UIColor = .init(red: 144 / 255, green: 215 / 255, blue: 236 / 255, alpha: 0.8)
            public static let pink: UIColor = .init(red: 255 / 255, green: 182 / 255, blue: 193 / 255, alpha: 0.8)
            public static let black: UIColor = .init(red: 0, green: 0, blue: 0, alpha: 0.8)
        }
    }
    static let shared = TouchEventController()
    private var touchViews = Set<TouchView>()
    public private(set) var config = Config()
    public func setConfig(_ config: Config) {
        self.config = config
    }
    public func sendEvent(_ event: UIEvent) {
        guard event.type == .touches, let allTouches = event.allTouches, config.isActive else {
            return
        }
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let topWindow = window else {
            return
        }
        allTouches.forEach { touch in
            switch touch.phase {
            case .began:
                let view = TouchView()
                view.backgroundColor = config.color.withAlphaComponent(0.3)
                view.layer.borderWidth = 3.0
                view.layer.borderColor = config.color.cgColor
                view.touch = touch
                view.center = touch.location(in: topWindow)
                topWindow.addSubview(view)
                touchViews.insert(view)
                
                view.alpha = 0
                view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                let animator = UIViewPropertyAnimator(duration: config.duration, curve: .easeIn) {
                    view.transform = .identity
                    view.alpha = 1.0
                }
                animator.startAnimation()
            case .moved:
                if let view = findTouchView(touch) {
                    view.center = touch.location(in: topWindow)
                }
            case .ended, .cancelled:
                if let view = findTouchView(touch) {
                    let animator = UIViewPropertyAnimator(duration: config.duration, curve: .easeIn) {
                        view.alpha = 0.0
                    }
                    animator.addCompletion { [weak self] _ in
                        view.removeFromSuperview()
                        self?.touchViews.remove(view)
                    }
                    
                    animator.startAnimation()
                }
            case .stationary, .regionEntered, .regionMoved, .regionExited:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func findTouchView(_ touch: UITouch) -> TouchView? {
        return touchViews.first(where: { touch == $0.touch })
    }
}

#endif
