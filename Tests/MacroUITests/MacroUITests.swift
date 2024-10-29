import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(MacroUIMacros)
import MacroUIMacros

let testMacros: [String: Macro.Type] = [
    "HStack": StackMacro.self,
    "VStack": StackMacro.self,
    "Spacer": SpacerMacro.self,
    "View": ViewMacro.self,

    "assign": AssignMacro.self,
    "add": AddMacro.self,
    "set": SetMacro.self,

    "_meta": _MetaMacro.self,
    "_arrange": _ArrangeMacro.self,
]
#endif

final class MacroUITests: XCTestCase {
    func testMacro() throws {
        #if canImport(MacroUIMacros)
        assertMacroExpansion(
            ##"""
            let spacer: Spacer
            @add(to: view)
            #HStack {
                #VStack {
                    #View(a)
                    @assign(to: spacer)
                    #Spacer(minLength: 10)
                    #View(b)
                }
                #VStack {
                    #View(x)
                    #View(y)
                    #View(z)
                }
            }
            """##,
            expandedSource: """
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
