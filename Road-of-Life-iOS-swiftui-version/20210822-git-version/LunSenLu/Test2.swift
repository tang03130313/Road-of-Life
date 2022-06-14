//
//  Test2.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2020/12/7.
//

import Foundation
import SwiftUI

struct RedView: View {
    var body: some View {
        Color.red
    }
}
struct BlueView: View {
    var body: some View {
        Color.blue
    }
}

struct GreenView: View {
    var body: some View {
        Color.gray
    }
}


struct Test2: View {
    @State private var selectedTab = 1
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
        
        TabView (selection: $selectedTab){
            RedView()
                .tabItem {
                Image(systemName: "speedometer")
                Text("風險係數")
             }.tag(0)
           BlueView()
            .tabItem {
                Image(systemName: "waveform.path.ecg.rectangle")//stethoscope waveform.path.ecg.rectangle.fill
                Text("疾病軌跡")
             }.tag(1)
            GreenView()
              .tabItem {
                 Image(systemName: "gearshape")//gearshape.fill
                 Text("設定")
              }.tag(2)
        }
        .onAppear() {
           UITabBar.appearance().barTintColor = UIColor.init(Color(red: 0.416, green: 0.624, blue: 0.608))
        }
        .accentColor(.white)
        
    }
}
struct Test2_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Test2()
        }
    }
}

