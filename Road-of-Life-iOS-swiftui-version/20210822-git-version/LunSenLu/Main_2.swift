//
//  Main.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2020/11/25.
//

import Foundation
import SwiftUI
import WebKit
import CryptoSwift
import KeychainAccess
import CryptoKit


struct Main_2: View {
    @State private var selectedTab = 1
    @State var state:Int = 0
    func configureBackground() {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = UIColor.init(Color(red: 0.416, green: 0.624, blue: 0.608))
            UINavigationBar.appearance().standardAppearance = barAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
        }
    init() {
        configureBackground()
        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
    }
    
    
    var body: some View {
        if (self.state == 0){
            NavigationView{
                TabView (selection: $selectedTab){
                    RiskView()
                        .tabItem {
                            Image(systemName: "speedometer")
                            Text("風險係數")
                         }.tag(0)
                    TragectoryView()
                        .tabItem {
                            Image(systemName: "waveform.path.ecg.rectangle")//stethoscope waveform.path.ecg.rectangle.fill
                            Text("疾病軌跡")
                         }.tag(1)
                    SettingView(state: $state)
                          .tabItem {
                             Image(systemName: "gearshape")//gearshape.fill
                             Text("設定")
                          }.tag(2)
                }
                .onAppear() {
                   UITabBar.appearance().barTintColor = UIColor.init(Color(red: 0.416, green: 0.624, blue: 0.608))
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                ToolbarItem(placement: .principal) { Text("疾病軌跡") .font(.title2)
                        .foregroundColor(.white)}
                    }
                )
                .navigationTitle("主畫面")
            }.accentColor(.white)
        }
        else{
            Login()
        }
    }
}
struct Main_2_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}

