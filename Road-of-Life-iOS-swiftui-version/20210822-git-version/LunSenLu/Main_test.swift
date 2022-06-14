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


struct WebView_test: UIViewRepresentable {
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


struct Main_test: View {
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


struct RiskView_test: View {
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
struct TragectoryView_test: View {
    var body: some View {
        WebView()
    }
}

struct SettingView_test: View {
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
//checkbox
struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let callback: (String, Bool)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 10,
        color: Color = Color.black,
        textSize: Int = 14,
        callback: @escaping (String, Bool)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(Font.system(size: size))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}
enum Checkbox: String {
    case mhb
}

//list row line change
struct HideRowSeparatorModifier: ViewModifier {
    static let defaultListRowHeight: CGFloat = 44
    var insets: EdgeInsets
    var background: Color
    
    init(insets: EdgeInsets, background: Color) {
        self.insets = insets
        var alpha: CGFloat = 0
        UIColor(background).getWhite(nil, alpha: &alpha)
        assert(alpha == 1, "Setting background to a non-opaque color will result in separators remaining visible.")
        self.background = background
    }
    
    func body(content: Content) -> some View {
        content
            .padding(insets)
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: Self.defaultListRowHeight,
                alignment: .leading
            )
            .listRowInsets(EdgeInsets())
            .background(background)
    }
}

extension EdgeInsets {
    static let defaultListRowInsets = Self(top: 0, leading: 16, bottom: 0, trailing: 16)
}

extension View {
    func hideRowSeparator(insets: EdgeInsets = .defaultListRowInsets, background: Color = .white) -> some View {
        modifier(HideRowSeparatorModifier(insets: insets, background: background))
    }
}

struct GradientBackgroundStyle: ButtonStyle {
    var background: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(background)
            .cornerRadius(40)
            //.padding(.horizontal, 10)
    }
}


struct Main_test_2: View {
    @State private var sysstate:Int = 2
    @State private var action: Int? = 0
    @State var selectedTag: String?
    let main_disease_arrays = [Main_test_disease(name: "心臟病", img: "heart", detail: "冠狀動脈症候群、心臟衰竭、高血壓性心臟病、心肌梗塞、風濕性心髒病 ...",score: "40"),Main_test_disease(name: "早產", img: "maternity", detail: "迫切早產、產前狀況或合併症、產早期分娩...", score: "20"),Main_test_disease(name: "老人痴呆症", img: "walker-2", detail: "初老年期癡呆症、老年期癡呆症併憂鬱或妄想現象、老年期精神病態 ... ", score: "8")]
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
                    
                    
                    CheckboxField(
                        id: Checkbox.mhb.rawValue,
                        label: "健康存摺",
                        size: UIScreen.main.bounds.width/30,
                        textSize: Int(UIScreen.main.bounds.width)/30,
                        callback: checkboxSelected
                    ).frame(maxWidth: .infinity, alignment: .trailing)
                }
                Spacer()
                Spacer()
                /*NavigationLink(
                    destination: sysstate == 1 ? WebView() : WebView_2()){
                    Text("aaa")
                }*/
                NavigationLink(destination: WebView(), tag: 1, selection: $action) {
                                    EmptyView()
                                }
                List{
                    ForEach(main_disease_arrays, id: \.id){ array in
                        Section(header:EmptyView()){
                            Spacer()
                            HStack{
                                Spacer()
                                Button(action:{
                                    if(array.name == "早產"){
                                        self.action = 1
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

struct Main_test_disease{
    var id = UUID()
    var name: String
    var img: String
    var detail: String
    var score: String
}

struct Main_Previews_test_2: PreviewProvider {
    static var previews: some View {
        //NavigationView{
            Main_test_2()
        //}
    }
}


struct Main_test_3: View {
    @State private var sysstate:Int = 2
    let main_prevent_arrays = [Main_test_prevent(name: "6 MWT", img: "6", detail: "6 Minutes Walking Test旨在幫助評估心肺疾病患者個人心肺功能能力，包括肺和心血管系統，血液循環... "),Main_test_prevent(name: "聊天機器人 - 早產", img: "robotic", detail: "使用聊天機器人即時傳遞正確資訊給使用者，更能在互動的過程中產生信任感，幫助產後精準預防")]
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
                    ForEach(main_prevent_arrays, id: \.id){ array in
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
struct Main_test_prevent{
    var id = UUID()
    var name: String
    var img: String
    var detail: String
}
