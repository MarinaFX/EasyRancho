import SwiftUI

struct FakeSearchBar: View {
    var body: some View {
        HStack {
            Text("AdicionarItensFake")
                .foregroundColor(Color(UIColor.secondaryLabel))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .padding(.leading, 30)
                .background(Color("SearchColor"))
                .cornerRadius(50)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                    }
                )
        }
    }
}

struct FakeSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        FakeSearchBar()
    }
}

