import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField(NSLocalizedString("SearchBarPlaceholder", comment: "SearchBarPlaceholder"), text: $text)
                .foregroundColor(Color(UIColor.secondaryLabel))
                .padding(10)
                .padding(.leading, 30)
                .background(Color("searchColor"))
                .cornerRadius(50)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                            .accessibility(hidden: true)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .padding(.trailing, 8)
                                    .accessibilityHint("ACSearchBarXHint")
                            }
                        }
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
            
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
