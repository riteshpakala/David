//
//  TableView.swift
//  Stoic
//
//  Created by Ritesh Pakala Rao on 5/2/23.
//

/* Basic TableView starter implementation w/ resultBuilder
 
 Example Usage:
 
 TableView {
     TableRow(text: .init("Table Row 1")) {
         // action
     }
 }.tableViewStyle(.init(title: "TableView",
                        rowHeight: 66,
                        paddingRow: .init(12, 0)))
 
 
 */

import Foundation
import SwiftUI

//MARK: TableView

public struct TableView : View {
    @Environment(\.tableViewStyle) var style
    
    @State var toggleDropdown: Bool = false
    
    let rows: (() -> [TableRow])
    
    init(@TableRowBuilder rows : @escaping () -> [TableRow]) {
        self.rows = rows
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = style.title {
                Text(title)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, style.paddingRow.leading)
            }
            
            ForEach(rows()) { row in
                seperator
                
                HStack {
                    Text(row.textModel.leading)
                    
                    Spacer()
                    
                    switch row.kind {
                    case .dropdown:
                        Image(systemName: "arrowtriangle.down.fill")
                            .frame(width: 12, height: 12)
                    case .toggle:
                        if let trailingText = row.textModel.trailing {
                            Text(trailingText)
                        }
                    default:
                        if let trailingText = row.textModel.trailing {
                            Text(trailingText)
                        }
                    }
                }
                .padding(style.paddingRow)
                .frame(maxWidth: .infinity)
                .frame(height: style.rowHeight)
                .background(style.backgroundColor)
                .onTapGesture {
                    if case let .dropdown(properties) = row.kind {
                        properties.selector.wrappedValue = "nice"
                    }
                    switch row.kind {
                    case .dropdown:
                        toggleDropdown.toggle()
                    default:
                        if row.kind.isInteractable {
                            row.action?()
                        }
                    }
                }
            }
            
            seperator
        }
        .padding(style.paddingTable)
        .background(style.background)
    }
    
    var seperator: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 1)
            .foregroundColor(Color.white.opacity(0.66))
            .padding(.leading, style.paddingRow.leading)
    }
}

//MARK: TableRow

public enum TableRowKind {
    case dropdown(DropdownProperties)
    case toggle
    case none
    
    public struct DropdownProperties {
        let options: [String]
        let selector: Binding<String>
    }
    
    var isInteractable: Bool {
        switch self {
        case .dropdown, .toggle:
            return false
        default:
            return true
        }
    }
}

public struct TableRow : Identifiable, Hashable, Equatable {
    public let id: UUID = .init()
    
    var index: Int = 0
    let kind: TableRowKind
    let textModel: TextModel
    let action: (() -> Void)?
    
    init(kind: TableRowKind = .none, text: TextModel, _ action: (() -> Void)? = nil) {
        self.kind = kind
        self.textModel = text
        self.action = action
    }
    
    struct TextModel {
        let leading: LocalizedStringKey
        let trailing: LocalizedStringKey?
        
        init(_ leading: LocalizedStringKey, trailing: LocalizedStringKey? = nil) {
            self.leading = leading
            self.trailing = trailing
        }
    }
    
    public mutating func updateIndex(_ index: Int) -> TableRow {
        self.index = index
        return self
    }
    
    //Equatable & Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: TableRow, rhs: TableRow) -> Bool {
        lhs.id == rhs.id
    }
}

//MARK: TableViewStyle

public struct TableViewStyle {
    let title: LocalizedStringKey?
    let rowHeight: CGFloat
    let backgroundColor: Color
    let background: AnyView
    let paddingRow: EdgeInsets
    let paddingTable: EdgeInsets
    
    public init(title: LocalizedStringKey? = nil,
                rowHeight: CGFloat = 75,
                backgroundColor: Color = .black,
                paddingRow: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0),
                paddingTable: EdgeInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0),
                @ViewBuilder background: (() -> some View) = { EmptyView() }) {
        self.title = title
        self.rowHeight = rowHeight
        self.backgroundColor = backgroundColor
        self.paddingRow = paddingRow
        self.paddingTable = paddingTable
        self.background = AnyView(background())
    }
}

private struct TableViewStyleKey: EnvironmentKey {
    static let defaultValue: TableViewStyle = .init() { }
}

extension EnvironmentValues {
    var tableViewStyle: TableViewStyle {
        get { self[TableViewStyleKey.self] }
        set { self[TableViewStyleKey.self] = newValue }
    }
}

extension View {
    func tableViewStyle(_ style: TableViewStyle) -> some View {
        return self.environment(\.tableViewStyle, style)
    }
}

//MARK: TableRow ResultBuilder

public protocol TableViewRowGroup {
    
    var rows : [TableRow] { get }
    
}

extension TableRow : TableViewRowGroup {
    
    public var rows: [TableRow] {
        [self]
    }
    
}

extension Array: TableViewRowGroup where Element == TableRow {
    
    public var rows: [TableRow] {
        self
    }
    
}

@resultBuilder public struct TableRowBuilder {
    
    public static func buildBlock() -> [TableRow] {
        []
    }
    
    public static func buildBlock(_ row : TableRow) -> [TableRow] {
        [row]
    }
    
    public static func buildBlock(_ rows: TableViewRowGroup...) -> [TableRow] {
        rows.flatMap { $0.rows }
    }
    
    public static func buildEither(first row: [TableRow]) -> [TableRow] {
        row
    }
    
    public static func buildEither(second row: [TableRow]) -> [TableRow] {
        row
    }
    
    public static func buildOptional(_ rows: [TableRow]?) -> [TableRow] {
        rows?.flatMap { $0.rows } ?? []
    }
    
}
