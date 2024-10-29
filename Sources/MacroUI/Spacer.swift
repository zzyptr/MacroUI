#if canImport(UIKit)
import UIKit

public final class Spacer: UIView {

    public var minLength: CGFloat?

    public init(minLength: CGFloat? = nil) {
        self.minLength = minLength
        super.init(frame: .zero)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .vertical)
        let priority: UILayoutPriority = minLength == nil ? .defaultLow : .defaultHigh
        setContentCompressionResistancePriority(priority, for: .horizontal)
        setContentCompressionResistancePriority(priority, for: .vertical)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        return nil
    }

    public override var intrinsicContentSize: CGSize {
        let length = minLength ?? UIView.noIntrinsicMetric
        switch (superview as? UIStackView)?.axis {
        case .horizontal:
            return CGSize(width: length, height: UIView.noIntrinsicMetric)
        case .vertical:
            return CGSize(width: UIView.noIntrinsicMetric, height: length)
        default:
            return CGSize(width: length, height: length)
        }
    }
}

#else
import AppKit

public final class Spacer: NSView {

    public var minLength: CGFloat?

    public init(minLength: CGFloat? = nil) {
        self.minLength = minLength
        super.init(frame: .zero)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultLow, for: .vertical)
        let priority: NSLayoutConstraint.Priority = minLength == nil ? .defaultLow : .defaultHigh
        setContentCompressionResistancePriority(priority, for: .horizontal)
        setContentCompressionResistancePriority(priority, for: .vertical)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        return nil
    }

    public override var intrinsicContentSize: CGSize {
        let length = minLength ?? NSView.noIntrinsicMetric
        switch (superview as? NSStackView)?.orientation {
        case .horizontal:
            return CGSize(width: length, height: NSView.noIntrinsicMetric)
        case .vertical:
            return CGSize(width: NSView.noIntrinsicMetric, height: length)
        default:
            return CGSize(width: length, height: length)
        }
    }
}
#endif
