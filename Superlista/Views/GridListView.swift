//
//  GridListView.swift
//  Superlista
//
//  Created by Marina De Pazzi on 11/05/21.
//

import SwiftUI

struct GridListView: View {
    @EnvironmentObject var listsViewModel: ListsViewModel
    
    @GestureState var longPressTap: Bool = false
    
    @State private var isPressed = false
    @State var cardWiggles: Bool = false
    
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20, content: {
                ForEach(listsViewModel.list) { list in
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 150, height: 150)
                            .cornerRadius(15)
                            .shadow(radius: 10)
                        
                        Text(list.title)
                            .frame(alignment: .bottom)
                            .padding(.bottom)
                        
                        Image(systemName: list.favorite ? "heart.fill" : "heart")
                            .foregroundColor(list.favorite ? Color.red : Color.black)
                            .position(x: 145, y: 22)
                            .onTapGesture {
                                listsViewModel.toggleListFavorite(of: list)
                            }
                        
                        Image(systemName: "minus.circle.fill")
                            .font(.title)
                            .foregroundColor(Color(.systemGray))
                            .offset(x: -75, y: -135)
                        
                    }
                    .opacity(longPressTap ? 0.4 : 1.0)
                    .rotationEffect(.degrees(cardWiggles ? 2.5 : 0))
                    .animation(Animation.easeInOut(duration: 0.15))
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .updating($longPressTap, body: { (currentState, state, transaction) in
                                state = currentState
                            })
                            .onEnded({ _ in
                                self.isPressed.toggle()
                            })
                    )
                    
                    
                    
                }
            })//.background(Color.orange)
            .padding(.top)
        }
        //.background(Color.blue)
        .padding()
        .padding(.top)
        
        //        .toolbar{
        //            ToolbarItem(placement: .destructiveAction){
        //                EditButton()
        //            }
        //        }
        .navigationTitle("Listas")
    }
    
    func animation(){
        Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)
    }
    
    func DragAndDrop(list: ListModel){
        //        Gesture {
        //            .onLongPressGesture {
        //                isEditing.toggle()
        //            }
        //            //.background(Color.green)
        //            .onDrag({
        //                listsViewModel.currentList = list
        //                return NSItemProvider(contentsOf: URL(string: "\(list.id)")!)!
        //            })
        //            .onDrop(of: [.url], delegate: DropViewDelegate(listsViewModel: listsViewModel, list: list))
        //        }
    }
}

struct GridListView_Previews: PreviewProvider {
    static var listsViewModel: ListsViewModel = ListsViewModel()
    static var previews: some View {
        NavigationView {
            GridListView()
                
                .navigationTitle("Listas")
        }
        .environmentObject(listsViewModel)
    }
}
