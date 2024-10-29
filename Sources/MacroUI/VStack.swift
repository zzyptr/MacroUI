#if canImport(UIKit)
import UIKit

public final class VStack: UIStackView {

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
        super.axis = .vertical
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
            return .vertical
        }
        @available(*, unavailable, message: "VStack always be vertical")
        set {}
    }

    public override func addArrangedSubview(_ view: UIView) {
        super.addArrangedSubview(view)
        if view.intrinsicContentSize.height == UIView.noIntrinsicMetric {
            view.heightAnchor.constraint(equalTo: equalizer.heightAnchor).isActive = true
        }
    }
}
#else
import AppKit

public final class VStack: NSStackView {

    private lazy var equalizer: NSView = {
        let view = NSView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()

    public init(
        alignment: NSLayoutConstraint.Attribute = .centerX,
        spacing: CGFloat = 8,
        distribution: NSStackView.Distribution = .fill
    ) {
        super.init(frame: .zero)
        super.orientation = .vertical
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
            return .vertical
        }
        @available(*, unavailable, message: "VStack always be vertical")
        set {}
    }

    public override func addArrangedSubview(_ view: NSView) {
        super.addArrangedSubview(view)

        if view.intrinsicContentSize.height == NSView.noIntrinsicMetric {
            view.heightAnchor.constraint(equalTo: equalizer.heightAnchor).isActive = true
        }
    }
}
#endif
