//
//  PerformanceItemAdminView.swift
//  FesTracking2
//
//  Created by 松下和也 on 2025/04/17.
//
import SwiftUI

struct EditableListItemView: View {
    let text: String
    let onEdit: ()->Void
    let onDelete: ()->Void
    
    init (text: String, onEdit: @escaping ()->Void, onDelete: @escaping ()->Void){
        self.text = text
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    var body: some View {
        HStack{
            Text(text)
            Spacer()
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)
            .buttonStyle(BorderlessButtonStyle())
            .padding(.horizontal,4)
            Button {
                onEdit()
            } label: {
                Image(systemName: "square.and.pencil")
            }
            .tint(.blue)
            .buttonStyle(BorderlessButtonStyle())
            .padding(.horizontal,4)
        }
    }
}
