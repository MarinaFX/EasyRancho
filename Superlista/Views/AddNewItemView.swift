import SwiftUI
import Foundation

struct AddNewItemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var list: ListModel?
    
    @State var searchText: String
    
    let products = ProductListViewModel().productsOrdered
    
    var body: some View {
        MainScreen(customView:
            VStack {
            ProductListView(filter: $searchText, list: self.$list)
            
            Button(action: readyButtonPressed, label: {
                Text("AddNewItemViewBottomButtonLabel")
                    .font(.body)
                    .fontWeight(.bold)
            })
                .buttonStyle(MediumButtonStyle(background: Color("Button"), foreground: .white))
                .padding(.top)
                .padding(.bottom, 32)
                
            }
            .edgesIgnoringSafeArea(.bottom)
                   
        , topPadding: -15)
        .toolbar {
            ToolbarItem(placement: .principal) {
                SearchBar(text: $searchText)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.5)
            }
        }
    }
    
    func readyButtonPressed() {
        presentationMode.wrappedValue.dismiss()
    }
}
