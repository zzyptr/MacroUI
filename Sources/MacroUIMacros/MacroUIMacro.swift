import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct StackMacro: DeclarationMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let variableName = context.makeUniqueName("")
        guard let statements = node.trailingClosure?.statements else {
            // TODO:
            return []
        }
        var declarations = [DeclSyntax]()
        declarations.append(DeclSyntax("""
        let \(variableName) = \(node.macroName)(\(node.arguments))
        """))
        for statement in statements {
            let item = statement.item
            if let expr = MacroExpansionExprSyntax(item) {
                declarations.append(DeclSyntax("""
                @_meta
                @_arrange("\(variableName)")
                \(expr)
                """))
            }
            if let decl = MacroExpansionDeclSyntax(item) {
                declarations.append(DeclSyntax("""
                @_meta
                @_arrange("\(variableName)")
                \(decl)
                """))
            }
            // TODO:
        }

        return declarations
    }
}

public struct SpacerMacro: DeclarationMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let variableName = context.makeUniqueName("")
        let declaration = DeclSyntax("""
        let \(variableName) = Spacer(\(node.arguments))
        """)
        return [declaration]
    }
}

public struct ViewMacro: DeclarationMacro {

    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let variableName = context.makeUniqueName("")
        let declaration = DeclSyntax("""
        let \(variableName) = \(node.arguments)
        """)
        return [declaration]
    }
}

// MARK: -

public struct AssignMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let declaration = VariableDeclSyntax(declaration)
        guard let attributes = declaration?.attributes else {
            return []
        }
        for element in attributes.reversed() {
            if element.description == "@_meta" {
                return []
            }
            if element.description == node.description {
                break
            }
        }
        let pattern = declaration?.bindings.first?.pattern
        guard let identifier = IdentifierPatternSyntax(pattern)?.identifier else {
            return []
        }
        guard let expression = LabeledExprListSyntax(node.arguments)?.first?.expression else {
            return []
        }
        return [
            DeclSyntax("""
            let _ = \(expression) = \(identifier)
            """)
        ]
    }
}

public struct AddMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let declaration = VariableDeclSyntax(declaration)
        guard let attributes = declaration?.attributes else {
            return []
        }
        for element in attributes.reversed() {
            if element.description == "@_meta" {
                return []
            }
            if element.description == node.description {
                break
            }
        }
        let pattern = declaration?.bindings.first?.pattern
        guard let identifier = IdentifierPatternSyntax(pattern)?.identifier else {
            return []
        }

        guard let expression = LabeledExprListSyntax(node.arguments)?.first?.expression else {
            return []
        }
        return [
            DeclSyntax("""
            let _ = \(expression).addSubview(\(identifier))
            """)
        ]
    }
}

public struct SetMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let declaration = VariableDeclSyntax(declaration)
        guard let attributes = declaration?.attributes else {
            return []
        }
        for element in attributes.reversed() {
            if element.description == "@_meta" {
                return []
            }
            if element.description == node.description {
                break
            }
        }
        let pattern = declaration?.bindings.first?.pattern
        guard let identifier = IdentifierPatternSyntax(pattern)?.identifier else {
            return []
        }
        var iterator = LabeledExprListSyntax(node.arguments)?.makeIterator()
        guard let keyPath = KeyPathExprSyntax(iterator?.next()?.expression) else {
            // Use key-path expression directly
            return []
        }
        guard let expression = iterator?.next()?.expression else {
            return []
        }
        return [
            DeclSyntax("""
            let _ = \(identifier)\(keyPath.components) = \(expression)
            """)
        ]
    }
}


public struct _MetaMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return []
    }
}

public struct _ArrangeMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let declaration = VariableDeclSyntax(declaration)
        guard let attributes = declaration?.attributes else {
            return []
        }
        for element in attributes.reversed() {
            if element.description == "@_meta" {
                return []
            }
            if element.description == node.description {
                break
            }
        }
        let pattern = declaration?.bindings.first?.pattern
        guard let identifier = IdentifierPatternSyntax(pattern)?.identifier else {
            return []
        }

        let expression = LabeledExprListSyntax(node.arguments)?.first?.expression
        guard let description = StringLiteralExprSyntax(expression)?.segments.description else {
            return []
        }
        return [
            DeclSyntax("""
            let _ = \(raw: description).addArrangedSubview(\(identifier))
            """)
        ]
    }
}

@main
struct MacroUIPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StackMacro.self,
        SpacerMacro.self,
        ViewMacro.self,

        AssignMacro.self,
        AddMacro.self,
        SetMacro.self,

        _MetaMacro.self,
        _ArrangeMacro.self,
    ]
}
