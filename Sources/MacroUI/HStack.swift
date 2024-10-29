#if canImport(UIKit)
import UIKit

public final class HStack: UIStackView {

    private lazy var equalizer: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()

    public init(
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        spacing: CGFloat = 0
    ) {
        super.init(frame: .zero)
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }

    @available(*, unavailable)
    public required init(coder: NSCoder) {
        fatalError()
    }

    public override var axis: NSLayoutConstraint.Axis {
        get {
            return .horizontal
        }
        @available(*, unavailable, message: "HStack always be horizontal")
        set {}
    }

    public override func addArrangedSubview(_ view: UIView) {
        super.addArrangedSubview(view)
        if view.intrinsicContentSize.width == UIView.noIntrinsicMetric {
            view.widthAnchor.constraint(equalTo: equalizer.widthAnchor).isActive = true
        }
    }
}
#else
import AppKit

public final class HStack: NSStackView {

    private lazy var equalizer: NSView = {
        let view = NSView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()

    public init(
        alignment: NSLayoutConstraint.Attribute = .centerY,
        spacing: CGFloat = 8,
        distribution: NSStackView.Distribution = .fill
    ) {
        super.init(frame: .zero)
        self.alignment = alignment
        self.spacing = spacing
        self.distribution = distribution
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        return nil
    }

    public override var orientation: NSUserInterfaceLayoutOrientation {
        get {
            return .horizontal
        }
        @available(*, unavailable, message: "HStack always be horizontal")
        set {}
    }

    public override func addArrangedSubview(_ view: NSView) {
        super.addArrangedSubview(view)

        if view.intrinsicContentSize.width == NSView.noIntrinsicMetric {
            view.widthAnchor.constraint(equalTo: equalizer.widthAnchor).isActive = true
        }
    }
}
#endif
