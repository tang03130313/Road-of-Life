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

struct Responseapi: Decodable {
    var result: String
}

struct WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            if let url = URL(string: "https://1qigvox2btm9q6ppyry9wq-on.drv.tw/MyWebsite/kidding/mobile.html") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
           
            return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    typealias UIViewType = WKWebView
}


struct WebView_2: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            if let url = URL(string: "https://lunsenlu.cf/views/comorbidity_main") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
           
            return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    typealias UIViewType = WKWebView
}


struct Main: View {
    @State private var selectedTab = 1
    @State var state:Int = 0
    //@State private var sysstate:Int = 2
    let main_disease_arrays = [Main_test_disease(name: "心臟衰竭", img: "heart", detail: "管狀動脈的疾病、高血壓、心瓣膜疾病 ...",score: "40"),Main_test_disease(name: "早產", img: "maternity", detail: "迫切早產、產前狀況或合併症、產早期分娩...", score: "20"),Main_test_disease(name: "老人痴呆症", img: "walker-2", detail: "初老年期癡呆症、老年期癡呆症併憂鬱或妄想現象、老年期精神病態 ... ", score: "8")]
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
                    Main_test_3()
                        .tabItem {
                            Image(systemName: "speedometer")
                            Text("精準預防")
                         }.tag(0)
                    HomePage()
                        .tabItem {
                            Image(systemName: "house")//stethoscope waveform.path.ecg.rectangle.fill
                            Text("首頁")
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
                    ToolbarItem(placement: .principal) { Text(selectedTab == 0 ? "精準預防": (selectedTab == 1 ? "首頁" : "設定")) .font(.title2)
                        .foregroundColor(.white)}
                    }
                )
                .navigationTitle(selectedTab == 2 ? "設定" : "首頁")
            }.accentColor(.white)
        }
        else{
            Login()
        }
    }
}
struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}


struct HomePage: View {
    @State private var sysstate:Int = 2
    @State private var checkid:Bool = false
    @State private var actionlink: Int? = 0
    @State var selectedTag: String?
    @State var useMHB = false
    @State var checkMHB = false
    @State var activateMHB = false
    let home_disease_arrays = [HomePage_disease(name: "心臟衰竭", img: "heart", detail: "管狀動脈的疾病、高血壓、心瓣膜疾病 ...",score: "40"),HomePage_disease(name: "早產", img: "maternity", detail: "迫切早產、產前狀況或合併症、產早期分娩...", score: "20"),HomePage_disease(name: "老人痴呆症", img: "walker-2", detail: "初老年期癡呆症、老年期癡呆症併憂鬱或妄想現象、老年期精神病態 ... ", score: "8")]
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .systemGray6
       UITableView.appearance().backgroundColor = .systemGray6
    }
    /*func checkboxSelected(id: String, isMarked: Bool) {
            print("\(id) is marked: \(isMarked)")
        }*/
    var body: some View {
        
        ZStack{
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            VStack{
                Text("   ")
                    .frame(width:UIScreen.main.bounds.width/10 , height: UIScreen.main.bounds.width/10)
                HStack{
                    Button(action:{
                        print("111")
                        self.sysstate = 1
                    }){
                        
                        Text("軌跡系統")
                            .fontWeight(.semibold)
                            .font( .headline)
                        
                    }
                    .buttonStyle(GradientBackgroundStyle(background: sysstate == 1 ? Color(red: 0.416, green: 0.624, blue: 0.608) : Color(UIColor.systemGray3)))
                    .frame(width: UIScreen.main.bounds.width/3)
                    .offset(x: UIScreen.main.bounds.width/20, y: 0)
                    .zIndex(sysstate == 1 ? 1: 0)
                    
                    Button(action:{
                        print("111")
                        self.sysstate = 2
                    }){
                        
                        Text("共病系統")
                            .fontWeight(.semibold)
                            .font( .headline)
                        
                    }
                    .buttonStyle(GradientBackgroundStyle(background: sysstate == 1 ? Color(UIColor.systemGray3) : Color(red: 0.416, green: 0.624, blue: 0.608)))
                    .frame(width: UIScreen.main.bounds.width/3)
                    .offset(x: -UIScreen.main.bounds.width/20, y: 0)
                    .zIndex(sysstate == 1 ? 0: 1)
                    
                    NavigationLink(destination: Health_Passport(), isActive: $activateMHB) {
                        Button(action:{
                            //self.checkMHB = true
                            print(checkMHB)
                            useMHB = !useMHB
                        }){
                            
                            HStack{
                                Image(systemName: useMHB ? "checkmark.square": "square")
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width/30, height: UIScreen.main.bounds.width/30)
                                    .foregroundColor(.black)
                                    
                                Text("健康存摺")
                                    .foregroundColor(Color.black)
                                    .font(.caption)
                           }
                            
                        }.alert(isPresented:$checkMHB) {
                            Alert(title: Text("未同意使用健康存摺"), message: Text("您還尚未同意並使用自己的健康存摺分析系統，\n前往登入健康存摺並下載"), primaryButton: .default(Text("是的")) {
                                    print("goto mhb")
                                    activateMHB = true
                            }, secondaryButton: .destructive(Text("取消")))
                        }
                    }
                    
                    /*CheckboxField(
                            id: Checkbox.mhb.rawValue,
                            label: "健康存摺",
                            size: UIScreen.main.bounds.width/30,
                            textSize: Int(UIScreen.main.bounds.width)/30,
                            callback: checkboxSelected
                        ).frame(maxWidth: .infinity, alignment: .trailing)
                    }*/
                }
                
                Spacer()
                Spacer()
                NavigationLink(destination: WebView(), tag: 1, selection: $actionlink) {
                                    EmptyView()
                                }
                NavigationLink(destination: WebView_2(), tag: 2, selection: $actionlink) {
                                    EmptyView()
                                }
                List{
                    ForEach(home_disease_arrays, id: \.id){ array in
                        Section(header:EmptyView()){
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action:{
                                    if(sysstate == 1 && array.name == "早產"){
                                        self.actionlink = 1
                                    }
                                    else if(sysstate == 2 && array.name == "心臟衰竭"){
                                        self.actionlink = 2
                                    }
                                    
                                }){
                                    HStack{
                                        Image(array.img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                            .padding(.horizontal,2)
                                            .padding(.vertical, 30)
                                        Rectangle()
                                            .fill(Color(UIColor.systemGray6))
                                            .frame(width: UIScreen.main.bounds.width/120, height: UIScreen.main.bounds.width/6)
                                            
                                        VStack{
                                            Text(array.name)
                                                .font(Font.title2.weight(.bold))
                                                .foregroundColor(Color(UIColor.darkGray))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(1)
                                            Text(array.detail)
                                                .font(Font.caption.weight(.light))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        Spacer()
                                        Text(array.score+"%")
                                            .font(Font.title.weight(.bold))
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white.shadow(color: .gray, radius: 2, x: 1, y: 2))
                                }
                                Spacer()
                            }
                            
                                
                            
                            
                        }.hideRowSeparator(background: Color(UIColor.systemGray6))
                    }
                }
            }
        }
        
    }
}

struct HomePage_disease{
    var id = UUID()
    var name: String
    var img: String
    var detail: String
    var score: String
}


struct PreventLink: View {
    @State private var sysstate:Int = 2
    let preventlink_prevent_arrays = [PreventLink_prevent(name: "6 MWT", img: "6", detail: "6 Minutes Walking Test旨在幫助評估心肺疾病患者個人心肺功能能力，包括肺和心血管系統，血液循環... "),PreventLink_prevent(name: "聊天機器人 - 早產", img: "robotic", detail: "使用聊天機器人即時傳遞正確資訊給使用者，更能在互動的過程中產生信任感，幫助產後精準預防")]
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .systemGray6
       UITableView.appearance().backgroundColor = .systemGray6
    }
    func checkboxSelected(id: String, isMarked: Bool) {
            print("\(id) is marked: \(isMarked)")
        }
    var body: some View {
        ZStack{
            Color(UIColor.systemGray6)
                                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("   ")
                    .frame(width:UIScreen.main.bounds.width/4 , height: UIScreen.main.bounds.width/4)
    
                List{
                    ForEach(preventlink_prevent_arrays, id: \.id){ array in
                        Section(header:EmptyView()){
                            Spacer()
                            Button(action:{
                                print("111")
                                
                            }){
                                HStack{
                                    Image(array.img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width/10,height: UIScreen.main.bounds.width/10)
                                        .padding(.horizontal,2)
                                        .padding(.vertical, 30)
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray6))
                                        .frame(width: UIScreen.main.bounds.width/120, height: UIScreen.main.bounds.width/6)
                                        
                                    VStack{
                                        Text(array.name)
                                            .font(Font.title2.weight(.bold))
                                            .foregroundColor(Color(UIColor.darkGray))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(1)
                                        Text(array.detail)
                                            .font(Font.caption.weight(.light))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }.frame(maxHeight: UIScreen.main.bounds.width/3)
                                    Spacer()
                                    Image("foreign")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width/15,height: UIScreen.main.bounds.width/15)
                                        .padding(.horizontal,2)
                                        .padding(.vertical, 30)
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.shadow(color: .gray, radius: 2, x: 1, y: 2))
                            }
                            
                            
                        }.hideRowSeparator(background: Color(UIColor.systemGray6))
                    }
                }
            }
        }
    }
}

struct PreventLink_prevent{
    var id = UUID()
    var name: String
    var img: String
    var detail: String
}

struct RiskView: View {
    var body: some View {
        VStack{
            Image("dashboard_preview")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width/4,height: UIScreen.main.bounds.width/4)
            Text("敬請期待")
                .font(.title2)
                .foregroundColor(Color(red: 0.416, green: 0.624, blue: 0.608))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
struct TragectoryView: View {
    var body: some View {
        WebView()
    }
}

struct SettingView: View {
    @Binding var state:Int
    func logout(){
        keychain["email"] = nil
        keychain["password"] = nil
        state = 1
    }
    let arrays = [Setting(name: "健康存摺",img: "notebook",details: ["健康存摺","醫生授權"]),Setting(name: "一般設定",img: "settings_2",details: ["通知","帳號"]),Setting(name: "其他",img: "more",details: ["隱私權政策","版本號"])]
    var body: some View {
        List{
            ForEach(arrays, id: \.id) { array in
                Section(header:
                            HStack{
                                Image(array.img).resizable()
                                    .scaledToFill().frame(width: UIScreen.main.bounds.width/20,height: UIScreen.main.bounds.width/20).padding(.trailing, 10)
                                
                                Text(array.name)
                                
                            }){
                    ForEach(array.details, id: \.self){detail in
                        if(detail == "健康存摺"){
                            NavigationLink(
                                destination: Health_Passport()){
                                Text(detail).accentColor(.white)
                            }
                        }
                        else if(detail == "醫生授權"){
                            NavigationLink(
                                destination: Doctor_Authorization()){
                                Text(detail).accentColor(.white)
                            }
                        }
                        else if(detail == "帳號"){
                            NavigationLink(
                                destination: Account_pass()){
                                Text(detail)
                            }
                        }
                        else if(detail != "版本號"){
                            NavigationLink(
                                destination: Policy()){
                                Text(detail)
                            }
                        }
                        else{
                            HStack{
                                Text(detail)
                                Spacer()
                                Text("1.0.1")
                            }
                        }
                        
                    }
                }
            }.padding(.top,10)
            ZStack{
                Button(action: {logout()}){
                    Text("登出")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.red)
                }
                NavigationLink(
                    destination: Login()){
                        EmptyView()
                }.buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct Setting {
    var id = UUID()
    var name: String
    var img: String
    var details: Array<String>
}
