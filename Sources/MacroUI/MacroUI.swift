import CoreFoundation

#if canImport(UIKit)
import UIKit

@freestanding(declaration, names: arbitrary)
public macro HStack(
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution = .fill,
    spacing: CGFloat = 0,
    _: () -> Void
) = #externalMacro(module: "MacroUIMacros", type: "StackMacro")

@freestanding(declaration, names: arbitrary)
public macro VStack(
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution = .fill,
    spacing: CGFloat = 0,
    _: () -> Void
) = #externalMacro(module: "MacroUIMacros", type: "StackMacro")
#else
import AppKit

@freestanding(declaration, names: arbitrary)
public macro HStack(
    alignment: NSLayoutConstraint.Attribute = .centerY,
    spacing: CGFloat = 8,
    distribution: NSStackView.Distribution = .fill,
    _: () -> Void
) = #externalMacro(module: "MacroUIMacros", type: "StackMacro")

@freestanding(declaration, names: arbitrary)
public macro VStack(
    alignment: NSLayoutConstraint.Attribute = .centerY,
    spacing: CGFloat = 8,
    distribution: NSStackView.Distribution = .fill,
    _: () -> Void
) = #externalMacro(module: "MacroUIMacros", type: "StackMacro")
#endif

@freestanding(declaration, names: arbitrary)
public macro Spacer(minLength: CGFloat? = nil) = #externalMacro(module: "MacroUIMacros", type: "SpacerMacro")

@freestanding(declaration, names: arbitrary)
public macro View<View>(_ view: View) = #externalMacro(module: "MacroUIMacros", type: "ViewMacro")


@attached(peer)
public macro assign<View>(to reference: View) = #externalMacro(module: "MacroUIMacros", type: "AssignMacro")

@attached(peer)
public macro add<View>(to superview: View) = #externalMacro(module: "MacroUIMacros", type: "AddMacro")


@attached(peer)
public macro set<View, Property>(_ keyPath: KeyPath<View, Property>, _ value: Property) = #externalMacro(module: "MacroUIMacros", type: "SetMacro")

@attached(peer)
public macro set<View, Property>(_ keyPath: KeyPath<View, Property?>, _ value: Property) = #externalMacro(module: "MacroUIMacros", type: "SetMacro")


// MARK: -
@attached(peer)
public macro _meta() = #externalMacro(module: "MacroUIMacros", type: "_MetaMacro")

@attached(peer)
public macro _arrange<T>(_: T) = #externalMacro(module: "MacroUIMacros", type: "_ArrangeMacro")
