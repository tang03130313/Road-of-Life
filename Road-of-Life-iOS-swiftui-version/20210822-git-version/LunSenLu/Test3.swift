//
//  Test3.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2021/1/8.
//

import Foundation
import SwiftUI
import BottomSheet


struct author_doctor_list: Identifiable,Hashable {
    var id : Int//= UUID()
    var hospital: String
    var cate: String
    var name: String
}

struct Test222: Identifiable {
    var id = UUID()
    var date: String
    var counts: String
    var check: String
}

struct Test3: View {
    @State private var selectedTab = 1
    @State var author_doctor_list_data = [author_doctor_list(id:0,hospital:"林口長庚",cate:"骨科",name:"李雍正"),author_doctor_list(id:1,hospital:"台北長庚",cate:"胸腔外科",name:"郭健民"),author_doctor_list(id:2,hospital:"台大",cate:"心臟科",name:"王健民")]
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
    func deleteListItem(whichElement: IndexSet) {
        whichElement.forEach(){ element in
            /*for index in stride(from: health_passport_data.count-1, through: element+1, by: -1){
                health_passport_data[index].id = health_passport_data[index-1].id
            }
            health_passport_data.remove(atOffsets: whichElement)*/
        }
    }
    var body: some View {
        List {
            ForEach(author_doctor_list_data,id: \.self) { array in
                HStack {
                    Image(systemName: "person.circle.fill")
                        .frame(width: UIScreen.main.bounds.width/10, height: 10, alignment: .leading)
                        .foregroundColor(Color(.systemGray))
                    VStack(alignment:.leading) {
                        Text(array.name+"醫師")
                            .font(.title3)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(.darkGray))
                        Text(array.hospital+" "+array.cate)
                            .font(.callout)
                            .foregroundColor(Color(.darkGray))
                    }.frame(width: UIScreen.main.bounds.width/2, height: 10, alignment: .leading)
                }
                .font(.title)
                .padding(.vertical,30)
                .padding(.horizontal, 10)
            }.onDelete(perform: deleteListItem)
        }
        .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("醫生授權")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button(action: {
                        print("aaa")
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                    }
                }
                    
        })
        .navigationBarTitleDisplayMode(.inline)
        .accentColor(.white)
    }
}
struct Test3_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Test3()
        }
    }
}

//var showingDetail:Bool = false

struct Test4: View {
    var colors = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = 0
    @State var selectedDate = Date()
    @State var showingPopup = false
     @State var showingDetail = false
    @Environment(\.presentationMode) var presentationMode
        static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyMMddhhmm")
            return formatter
        }()

    var body: some View {
        /*VStack {
                 Picker(selection: $selectedColor, label: Text("Please choose a color")) {
                    ForEach(0 ..< colors.count) {
                       Text(self.colors[$0])
                    }
                 }
                 Text("You selected: \(colors[selectedColor])")
              }*/
        /*VStack {
                    Text("Selected date: \(selectedDate, formatter: Self.formatter)")
                    Button("Show action sheet") {
                        self.showDatePickerAlert()
                    }
                }*/
        //GeometryReader { geometry in
            /*Button(action: {
                self.showingDetail.toggle()
                    }) {
                        Text("Show Detail")
                    }.sheet(isPresented: $showingDetail) {
                        DetailView(isPresented: self.$showingDetail)//,maxHeight: geometry.size.height*0.7)
                    }*/
        Button(action: {
            self.showingDetail.toggle()
                }) {
                    Text("Show Detail")
                        /*.bottomSheet(isPresented: $showingDetail, height: UIScreen.main.bounds.height*0.5) {
                            DetailView(isPresented: self.$showingDetail)
                        }*/
                        .sheet(isPresented: $showingDetail) {
                            //DetailView(isPresented: self.$showingDetail)//,maxHeight: geometry.size.height*0.7)
                            Text("aaa")
                        }
        }.frame(width: 200, height: 200)
        //}.edgesIgnoringSafeArea(.all)
    }
    func showDatePickerAlert() {
            let alertVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
            let datePicker: UIDatePicker = UIDatePicker()
            alertVC.view.addSubview(datePicker)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.selectedDate = datePicker.date
            }
            alertVC.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertVC.addAction(cancelAction)

            if let viewController = UIApplication.shared.windows.first?.rootViewController {
                viewController.present(alertVC, animated: true, completion: nil)
            }
        }
}
struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct DetailView: View {
    @Binding var isPresented: Bool
    func add(){
        print(isPresented)
        self.isPresented = false
    }
    func cancel(){
        print(isPresented)
        self.isPresented = false
    }
    var body: some View {
        VStack(spacing:0){
            HStack(alignment: .center) {
                Button(action: { self.cancel()}){
                        Text("取消")
                            .frame(height: UIScreen.main.bounds.height*0.5*0.07,alignment: .leading)
                            .font(Font.body.bold())
                }
                .frame(alignment: .leading)
                .padding(.leading,10)
                .padding(.bottom,10)
                Spacer()
                Text("新增醫生授權").foregroundColor(.black)
                Spacer()
                Button(action: { self.add()}){
                    Text("確定")
                        .frame(height: UIScreen.main.bounds.height*0.5*0.07,alignment: .trailing)
                        .font(Font.body.bold())
                }
                .frame(alignment: .trailing)
                .padding(.trailing,10)
                .padding(.bottom,10)
            }
            .overlay(Divider(), alignment: .bottom)
            
            HStack{
                Text("aaa").frame(height:UIScreen.main.bounds.height*0.5*0.8)
            }.background(Color.black)
        }
    }
}


struct Test4_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Test4()
        }
    }
}

//import BottomSheet_SwiftUI

struct Test5: View {
    var colors = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = 0
    @State var selectedDate = Date()
    @State var showingPopup = false
     @State var showingDetail = false
    @Environment(\.presentationMode) var presentationMode
        static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyMMddhhmm")
            return formatter
        }()

    var body: some View {
        /*VStack {
                 Picker(selection: $selectedColor, label: Text("Please choose a color")) {
                    ForEach(0 ..< colors.count) {
                       Text(self.colors[$0])
                    }
                 }
                 Text("You selected: \(colors[selectedColor])")
              }*/
        /*VStack {
                    Text("Selected date: \(selectedDate, formatter: Self.formatter)")
                    Button("Show action sheet") {
                        self.showDatePickerAlert()
                    }
                }*/
        //GeometryReader { geometry in
            /*Button(action: {
                self.showingDetail.toggle()
                    }) {
                        Text("Show Detail")
                    }.sheet(isPresented: $showingDetail) {
                        DetailView(isPresented: self.$showingDetail)//,maxHeight: geometry.size.height*0.7)
                    }*/
        /*Button(action: {
            //self.showingDetail.toggle()
            self.showingDetail = true
                }) {
                    Text("Show Detail")
                        .bottomSheet(isPresented: $showingDetail, height: UIScreen.main.bounds.height*0.5) {
                            //DetailView_2(isPresented: self.$showingDetail)
                            Text("aaa")
                        }
                }*/
        NavigationView{
        Text("Show Detail")
            .bottomSheet(isPresented: $showingDetail, height: UIScreen.main.bounds.height*0.4) {
                DetailView_2(isPresented: self.$showingDetail)
            }
            .navigationBarItems(
                    trailing: Button(action: { self.showingDetail = true }) {
                        Text("Show")
                    }
                )
        }
        //}.edgesIgnoringSafeArea(.all)
    }
    func showDatePickerAlert() {
            let alertVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
            let datePicker: UIDatePicker = UIDatePicker()
            alertVC.view.addSubview(datePicker)

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.selectedDate = datePicker.date
            }
            alertVC.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertVC.addAction(cancelAction)

            if let viewController = UIApplication.shared.windows.first?.rootViewController {
                viewController.present(alertVC, animated: true, completion: nil)
            }
        }
}


struct NavigationBarModifier: ViewModifier {

var backgroundColor: UIColor = .clear

init(backgroundColor: UIColor, tintColor: UIColor = .white) {
    self.backgroundColor = backgroundColor

    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.backgroundColor = backgroundColor
    coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = tintColor
}

func body(content: Content) -> some View {
    ZStack{
        content
        VStack {
            GeometryReader { geometry in
                Color(self.backgroundColor)
                    .frame(height: geometry.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.top)
                Spacer()
            }
        }
    }
}}

struct DetailView_2: View {
    struct NavigationConfigurator: UIViewControllerRepresentable {
        var configure: (UINavigationController) -> Void = { _ in }

        func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
            UIViewController()
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
            if let nc = uiViewController.navigationController {
                self.configure(nc)
            }
        }

    }
    
    @Binding var isPresented: Bool
    var hospitals = ["林口長庚醫院","台北長庚醫院","台大醫院","榮民總醫院"]
    @State private var selectedHospitals = 0
    var catelogorys = ["骨科","心臟科","肝膽腸胃科","榮民總醫院","神經外科","神經科"]
    @State private var selectedCatelogorys = 0
    var doctorname = ["王維陽","王維哲","林俊嘉"]
    @State private var selectedDoctorname = 0
    func add(){
        print(isPresented)
        self.isPresented = false
    }
    func cancel(){
        print(isPresented)
        self.isPresented = false
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing:0){
            HStack(alignment: .center) {
                Button(action: { self.cancel()}){
                        Text("取消")
                            .frame(height: UIScreen.main.bounds.height*0.5*0.07,alignment: .leading)
                            .font(Font.body.bold())
                            .foregroundColor(.white)
                }
                .frame(alignment: .leading)
                .padding(.leading,10)
                Spacer()
                Text("新增醫生授權").foregroundColor(.white).font(.title3)
                Spacer()
                Button(action: { self.add()}){
                    Text("確定")
                        .frame(height: UIScreen.main.bounds.height*0.5*0.07,alignment: .trailing)
                        .font(Font.body.bold())
                        .foregroundColor(.white)
                }
                .frame(alignment: .trailing)
                .padding(.trailing,10)

            }
            .overlay(Divider(), alignment: .bottom)
            .background(Color(red: 0.416, green: 0.624, blue: 0.608))
            Form {
                Section {
                    Picker(selection: $selectedHospitals, label: Text("醫院")) {
                        ForEach(0 ..< hospitals.count) {
                            Text(self.hospitals[$0])
                        }
                    }
                }
                Section {
                    Picker(selection: $selectedCatelogorys, label: Text("科別")) {
                        ForEach(0 ..< catelogorys.count) {
                            Text(self.catelogorys[$0])
                        }
                    }
                }
                Section {
                    Picker(selection: $selectedDoctorname, label: Text("姓名")) {
                        ForEach(0 ..< doctorname.count) {
                            Text(self.doctorname[$0])
                        }
                    }
                }
                Section(header:Text("   ")){
                    EmptyView()
                }
            }.navigationBarTitle("取消")
            .accentColor(.white)
            .edgesIgnoringSafeArea(.all)
            }.navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .modifier(NavigationBarModifier(backgroundColor: UIColor(Color(red: 0.416, green: 0.624, blue: 0.608)), tintColor: .white))
           
        }
    }
}


struct Test5_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView{
            Test5()
        //}
    }
}

/*
struct Test6: View {
    @State private var selectedTab = 1
    @State var author_doctor_list_data = [doctor_authorization_list(id:0,hospital:"林口長庚",department:"骨科",name:"李雍正"),doctor_authorization_list(id:1,hospital:"台北長庚",department:"胸腔外科",name:"郭健民"),doctor_authorization_list(id:2,hospital:"台大",department:"心臟科",name:"王健民")]
    @State var showingDetail = false
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
    func deleteListItem(whichElement: IndexSet) {
        whichElement.forEach(){ element in
            /*for index in stride(from: health_passport_data.count-1, through: element+1, by: -1){
                health_passport_data[index].id = health_passport_data[index-1].id
            }
            health_passport_data.remove(atOffsets: whichElement)*/
        }
    }
    var body: some View {
        NavigationView{
                List {
                ForEach(author_doctor_list_data,id: \.self) { array in
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .frame(width: UIScreen.main.bounds.width/10, height: 10, alignment: .leading)
                            .foregroundColor(Color(.systemGray))
                        VStack(alignment:.leading) {
                            Text(array.name+"醫師")
                                .font(.title3)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color(.darkGray))
                            Text(array.hospital+" "+array.cate)
                                .font(.callout)
                                .foregroundColor(Color(.darkGray))
                        }.frame(width: UIScreen.main.bounds.width/2, height: 10, alignment: .leading)
                    }
                    .font(.title)
                    .padding(.vertical,30)
                    .padding(.horizontal, 10)
                }.onDelete(perform: deleteListItem)
            }
            .toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        Text("醫生授權")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        Button(action: {
                            self.showingDetail = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                        
            })
            .navigationBarTitleDisplayMode(.inline)
            }
            .accentColor(.white)
            .bottomSheet(isPresented: $showingDetail, height: UIScreen.main.bounds.height*0.4) {
                DetailView_2(isPresented: self.$showingDetail)
            }
    }
}
struct Test6_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView{
            Test6()
        //}
    }
}
*/
enum Suit: String {
    case heart, club, spade, diamond

    var displayImage: Image {
        return Image(systemName: "suit.\(self.rawValue).fill")
    }
}

struct Test7: View {
    var frameworks = ["UIKit", "Core Data", "CloudKit", "SwiftUI"]
    @State private var selectedFrameworkIndex = 0
    var hospitals = ["林口長庚醫院","台北長庚醫院","台大醫院","榮民總醫院"]
    @State private var selectedHospitals = 0
    var catelogorys = ["骨科","心臟科","肝膽腸胃科","榮民總醫院","神經外科","神經科"]
    @State private var selectedCatelogorys = 0
    var doctorname = ["王維陽","王維哲","林俊嘉"]
    @State private var selectedDoctorname = 0
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $selectedHospitals, label: Text("醫院")) {
                        ForEach(0 ..< hospitals.count) {
                            Text(self.hospitals[$0])
                        }
                    }
                }
                Section {
                    Picker(selection: $selectedCatelogorys, label: Text("科別")) {
                        ForEach(0 ..< catelogorys.count) {
                            Text(self.catelogorys[$0])
                        }
                    }
                }
                Section {
                    Picker(selection: $selectedDoctorname, label: Text("姓名")) {
                        ForEach(0 ..< doctorname.count) {
                            Text(self.doctorname[$0])
                        }
                    }
                }
            }
            .navigationBarTitle("Favorites")
        }
    }
}

struct Test7_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView{
            Test7()
        //}
    }
}
