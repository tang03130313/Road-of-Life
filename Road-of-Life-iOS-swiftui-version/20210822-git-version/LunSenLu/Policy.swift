//
//  Policy.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2020/11/24.
//

import Foundation
import SwiftUI
struct Policy: View {
    func configureBackground() {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = UIColor.init(Color(red: 0.416, green: 0.624, blue: 0.608))
            UINavigationBar.appearance().standardAppearance = barAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
        }
    init() {
            configureBackground()
    }
    var body: some View {
        VStack(spacing: 0)  {
            ScrollView{
                Text(policy_text)
            }
            .toolbar(content: {
                    ToolbarItem(placement: .principal) { Text("隱私權政策") .font(.title2)
                            .foregroundColor(.white)}
            })
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,20)
            .padding(.top,10)
            .accentColor(.white)
        }
    }
}
struct Policy_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Policy()
        }
    }
}

struct Policy2: View {
    func configureBackground() {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = UIColor.init(Color(red: 0.416, green: 0.624, blue: 0.608))
            UINavigationBar.appearance().standardAppearance = barAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
        }
    init() {
            configureBackground()
    }
    @Environment(\.presentationMode) var presentation
    var body: some View {
        ZStack{
            VStack(spacing: 0)  {
                ScrollView{
                    Text(policy_text)
                        .padding(.bottom,20)
                }
                .toolbar(content: {
                        ToolbarItem(placement: .principal) { Text("隱私權政策") .font(.title2)
                                .foregroundColor(.white)}
                                    })
                .padding(.horizontal,20)
                .padding(.top,10)
                .navigationTitle("隱私權政策")
                .navigationBarTitleDisplayMode(.inline)
                
            }
            VStack{
                Spacer()
                Button(action: {
                    print("agree button tapped")
                    
                }) {
                    HStack{
                        NavigationLink("同意",destination: Register()).font(.body)
                    }
                    .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width/1.5)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 0.416, green: 0.624, blue: 0.608))
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                    
                }
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                    print("refuse button tapped")
                }) {
                    HStack{
                        Text("拒絕")
                            .fontWeight(.semibold)
                            .font(.body)
                    }
                    .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width/1.5)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(.lightGray))
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                    
                }
            }
        }.accentColor(.white)
    }
}
struct Policy2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Policy2()
        }
    }
}
