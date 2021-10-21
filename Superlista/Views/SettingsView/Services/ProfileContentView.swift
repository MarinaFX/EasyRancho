////
////  ProfileContentView.swift
////  Superlista
////
////  Created by Luiz Eduardo Mello dos Reis on 19/10/21.
////
//
//import SwiftUI
//
//struct ProfileContentView: View {
//    @Binding var shouldUpdateContent: Bool
//
//    init( shouldUpdateContent: Binding<Bool>) {
//        self._shouldUpdateContent = shouldUpdateContent
//    }
//    
//    var defaultImage: some View {
//        HStack(alignment: .center) {
//            Spacer()
//            #warning("Atualizar a string com o nome do banco de dados")
//            ProfilePicture(nameUser: "Luiz")
//            Spacer()
//        }
//    }
//        
//    var nameWithEdit: some View {
//        Group {
//            if !viewModel.isEditingName {
//                Button(action: { viewModel.isEditingName.toggle() }, label: {
//                    HStack(alignment: .center) {
//                        Title(text: viewModel.userName, weight: .semibold)
//                            .lineLimit(1)
//                        Image(systemName: "pencil.circle")
//                            .foregroundColor(.orange)
//                    }
//                    .padding(.leading, 22)
//                })
//                .padding(.horizontal)
//            } else {
//                VStack {
//                    HStack(alignment: .center) {
//                            TextField("", text: $viewModel.userName)
//                                .font(.title.weight(.semibold))
//                                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
//                                .cornerRadius(8)
//                                .multilineTextAlignment(.center)
//                            
//                        Button(action: { viewModel.finishNameEditing(saveIn: userProgress) }, label: {
//                                Image(systemName: "checkmark.circle")
//                                    .foregroundColor(.green)
//                            })
//                            
//                            Spacer()
//                        }
//                    
//                    Divider()
//                }
//                .padding(.horizontal)
//            }
//        }
//    }
//    
//    var content: some View {
//        VStack {
//            VStack(spacing: 8) {
//                // MARK: - Images
//                Button(action: { viewModel.showingImagePicker = true }) {
//                    ZStack(alignment: .bottom) {
//                        if userProgress.imageName != nil {
//                            UserImage(width: 96, height: 96)
//                        } else {
//                            defaultImage
//                        }
//                        
//                        ZStack {
//                            Image(systemName: "camera.circle")
//                                .foregroundColor(.orange)
//                                .background(Color.white)
//                                .cornerRadius(20)
//                                .font(.headline)
//                            .offset(x: 35, y: -10)
//                        }
//                    }
//                }
//                
//                nameWithEdit
//            }
//            // MARK: - My Swift
//            HStack {
//                Headline(text: "My Swift", weight: .semibold)
//                Spacer()
//            }
//            .padding(.horizontal)
//            .padding(.top, 12)
//            
//            ProgressProfile(wavePhase: .constant(0.0), progressValue: $viewModel.progressValue, userLevel: $viewModel.userLevel)
//                .padding(.horizontal)
//                .padding(.top, 10)
//            
//            // MARK: - Statistics
//            HStack {
//                Headline(text: "Statistics", weight: .semibold)
//                Spacer()
//            }
//            .padding(.horizontal)
//            .padding(.top, 20)
//            
//            StatisticsProfile(circleProgressValue: $viewModel.statisticProgress,
//                              progressValue: $viewModel.progressValue,
//                              totalValue: $viewModel.maxXPForLevel, currentXP: $viewModel.currentXP, currentLevel: $viewModel.userLevel, nextLevel: viewModel.getNextLevel(), lastChallengeDay: viewModel.getLastChallengeTimeFormatted(withData: userProgress))
//                .padding(.horizontal)
//                .padding(.vertical, 12)
//        }
//        .padding(.top, 24)
//    }
//}
//
////MARK: - Preview
//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileContentView(shouldUpdateContent: .constant(true))
//            .previewDevice("iPhone SE")
//    }
//}
