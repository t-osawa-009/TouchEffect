import UIKit

final class TouchView: UIView {
    weak var touch: UITouch?
    convenience init() {
        self.init(frame: .init(x: 0, y: 0, width: 44, height: 44))
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isUserInteractionEnabled = false
        layer.masksToBounds = true
        layer.cornerCurve = .continuous
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
}
