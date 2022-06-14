//
//  Setting.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2021/1/10.
//

import Foundation
import SwiftUI
import WebKit
import CryptoSwift
import KeychainAccess
import CryptoKit
//import BottomSheet_SwiftUI
import BottomSheet

struct Account_pass: View{
    @State var password = ""
    @State var data_array = [String(keychain["email"] ?? ""),String(keychain["password"] ?? ""), "","",""]
    @State var result_out = "fail"
    @State var state = 0
    @State var error = false
    @State var account_arrays = [Account_Data(pos: 0,name: "姓名", data: ""),Account_Data(pos: 1,name: "帳號", data: "test@gmail.com"),Account_Data(pos: 2,name: "密碼", data: "Test"),Account_Data(pos: 3,name: "電話", data: "0932058728"),Account_Data(pos: 4,name: "身分證字號", data: "A338475889")]
    @State var output = ["", "", "","",""]
    func get_data(){
        let body = "email="+data_array[0]+"&password="+data_array[1]
        print(body)
        postData_get_accountdata(from:"https://lunsenlu.cf/account/get_personal_data",from: body) { result in switch result {
            case .success(let str):
                
                //print(str)
                //print(result)
                result_out = str.result
                account_arrays = [Account_Data(pos: 0,name: "姓名", data: str.name),Account_Data(pos: 1,name: "帳號", data: str.email),Account_Data(pos: 2,name: "密碼", data: data_array[1]),Account_Data(pos: 3,name: "電話", data: str.phone),Account_Data(pos: 4,name: "身分證字號", data: str.user_id)]
                output = [str.name,str.email,data_array[1],str.phone,str.user_id]
                print("aaa ",result_out)
                state = 1
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
    }
    func change_data(){
        let body = "name="+output[0]+"&email="+output[1]+"&password="+output[2]+"&phone="+output[3]+"&user_id="+output[4]
        print(body)
        postData(from:"https://lunsenlu.cf/account/edit_personal_data",from: body) { result in switch result {
            case .success(let str):
                //print(str)
                //print(result)
                result_out = str.result
                print("aaa ",result_out)
                get_data()
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
    }
    func check_password(){
        let aes = try! AES(key: aeskey, blockMode: CBC(iv: aesiv), padding: .pkcs7)
        data_array[0] = try! keychain["email"]?.decryptBase64ToString(cipher: aes) as! String
        data_array[1] = try! keychain["password"]?.decryptBase64ToString(cipher: aes) as! String
        if(data_array[1] == password){
            error = false
            get_data()
        }
        else{
            error = true
        }
    }
    
    var body: some View {
        //NavigationView{
            if(state == 0){
                ZStack{
                    Color(.systemGray4).opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(content: {
                                ToolbarItem(placement: .principal) { Text("帳戶資料") .font(.title2)
                                        .foregroundColor(.white)}
                        })
                    VStack{
                        Spacer()
                        Text("請輸入密碼")
                            .font(.title)
                            .padding(.bottom,30)
                        SecureField("",text: $password)
                            .frame(width: UIScreen.main.bounds.width/1.5,height: UIScreen.main.bounds.width/8,alignment: .center).foregroundColor(Color(red: 0.2524, green: 0.3786, blue: 0.369, opacity: 1.0))
                            .border(Color(.systemGray2), width: 1)
                            .background(Color.white)
                            .font(.title)
                        if(!error){
                            Text("")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        else{
                            Text("密碼錯誤")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        Text("為了保護您的隱私\n請再輸入一次密碼").font(.caption2)
                            .padding(.top,30)
                            .padding(.bottom,30)
                        Button(action: {check_password()}) {
                            HStack{
                                Text("確認")
                                    .fontWeight(.semibold)
                                    .font(.body)
                            }
                            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width/1.5)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 0.416, green: 0.624, blue: 0.608))
                            .cornerRadius(40)
                            .padding(.horizontal, 20)
                            
                        }
                        Spacer()
                    }
                }
            }
            else if(state == 1){
                ZStack{
                    Color(.systemGray4).opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(content: {
                                ToolbarItem(placement: .principal) {
                                    Text("帳戶資料") .font(.title2)
                                        .foregroundColor(.white)
                                        
                                        
                                    }
                                    ToolbarItem(placement: .principal) {
                                        Spacer()
                                    }
                                    
                                    ToolbarItem(placement: .principal) {
                                        Image(systemName: "gearshape.fill").foregroundColor(.white).frame( alignment: .trailing)
                                    }

                        })
                    VStack{
                        List{
                            Section(header:Text("   ")){
                                EmptyView()
                            }
                            Section(header:
                                    HStack{
                                        Spacer()
                                        Image(systemName: "person.fill").resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width/5,height: UIScreen.main.bounds.width/3)
                                    Spacer()}){
                                EmptyView()
                            }
                            ForEach(account_arrays, id: \.id) { array in
                                Section(header:Text(array.name)){
                                    Text(array.data)
                                }
                            }
                            /*Section(header: Text("ddd")){
                                Text("ddd")
                            }*/
                            Section(header:Text(account_policy_text)){
                                EmptyView()
                            }
                        }.listStyle(GroupedListStyle())
                    }
                }.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("edit")
                            state = 2
                        }) {
                            Image(systemName: "pencil.circle")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        }
                        
                    }
                }
                
            }
            else{
                ZStack{
                    Color(.systemGray4).opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(content: {
                                ToolbarItem(placement: .principal) {
                                    Text("資料更改") .font(.title2)
                                        .foregroundColor(.white)
                                        
                                        
                                    }
                                    ToolbarItem(placement: .principal) {
                                        Spacer()
                                    }
                                    
                                    ToolbarItem(placement: .principal) {
                                        Image(systemName: "gearshape.fill").foregroundColor(.white).frame( alignment: .trailing)
                                    }

                        })
                    VStack{
                        List{
                            Section(header:Text("   ")){
                                EmptyView()
                            }
                            Section(header:
                                    HStack{
                                        Spacer()
                                        Image(systemName: "person.fill").resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width/5,height: UIScreen.main.bounds.width/3)
                                    Spacer()}){
                                EmptyView()
                            }
                            ForEach(account_arrays, id: \.id) { array in
                                Section(header:Text(array.name)){
                                    TextField(array.data,text: $output[array.pos])
                                }
                            }
                            Section(header:Text(account_policy_text)){
                                EmptyView()
                            }
                        }.listStyle(GroupedListStyle())
                    }
                }.toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("cancel")
                            get_data()
                        }) {
                            Image(systemName: "xmark.circle")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("save")
                            change_data()
                        }) {
                            Image(systemName: "checkmark.circle")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
    }
}

struct Account_Data{
    var id = UUID()
    var pos : Int
    var name: String
    //var img: String
    var data: String
}

struct Account_pass_preview : PreviewProvider {
    static var previews: some View {
        NavigationView{
            Account_pass()
        }.accentColor(.white)
    }
}



//health_passport


struct health_passport_list: Identifiable,Hashable {
    var id : Int//= UUID()
    var date: String
    var counts: String
    var check: String
}

struct Health_Passport: View {
    @State private var selectedTab = 1
    @State var state = 0
    @State var data_array = [String(keychain["email"] ?? ""),String(keychain["password"] ?? "")]
    @State var health_passport_data = [health_passport_list(id:0,date:"2020/01/10 04:33:43",counts: "2",check:"record.circle"),health_passport_list(id:1,date:"2020/01/08 11:23:22",counts: "3",check:"circle"),health_passport_list(id:2,date:"2020/01/09 10:22:33",counts: "8",check:"circle")]
    @State var health_passport_data_2 = [health_passport_list(id:0,date:"日期",counts: "0",check:"record.circle")]
    @State var result_out = "fail"
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
    func check_password(){
        let aes = try! AES(key: aeskey, blockMode: CBC(iv: aesiv), padding: .pkcs7)
        data_array[0] = try! keychain["email"]?.decryptBase64ToString(cipher: aes) as! String
        data_array[1] = try! keychain["password"]?.decryptBase64ToString(cipher: aes) as! String
    }
    func get_data(){
        check_password()
        let body = "email="+data_array[0]+"&password="+data_array[1]
        print(body)
        postData(from:"https://lunsenlu.cf/account/check_id",from: body) { result in switch result {
            case .success(let str):
                result_out = str.result
                print("aaa ",result_out)
                let body_2 = "email="+data_array[0]+"&user_id="+result_out
                postData_get_mhbdata(from:"https://lunsenlu.cf/health_passport/get_health_passport",from: body_2) { result in switch result {
                    case .success(let str):
                        print(str)
                        result_out = str.result
                        //health_passport_data_2 = str.mhb_data
                        state = health_passport_data_2[0].date != "日期" ? 2 : 1
                        print("aaa ",result_out)
                    case .failure(let error):
                        switch error {
                        case .badURL:
                            print("Bad URL")
                        case .requestFailed:
                            print("Network problems")
                        case .unknown:
                            print("Unknown error")
                        }
                    }
                }
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
    }
    func deleteListItem(whichElement: IndexSet) {
        whichElement.forEach(){ element in
            if health_passport_data[element].check == "record.circle"{
                if element != 0{
                    health_passport_data[element-1].check = "record.circle"
                }
                else{
                    health_passport_data[element+1].check = "record.circle"
                }
            }
            for index in stride(from: health_passport_data.count-1, through: element+1, by: -1){
                health_passport_data[index].id = health_passport_data[index-1].id
            }
            health_passport_data.remove(atOffsets: whichElement)
        }
    }
    func change_clicked(id: Int){
        if health_passport_data[id].check == "circle"{
            for index in 0...health_passport_data.count-1{
                if health_passport_data[index].check == "record.circle"{
                    health_passport_data[index].check = "circle"
                }
            }
            health_passport_data[id].check = "record.circle"
        }
    }
    var body: some View {
        Group{
            if(state == 0){
                CircleLoader()
            }
            else if (state == 1){
                Text("目前並無下載過健康存摺")
            }
            else{
                List {
                    ForEach(health_passport_data_2,id: \.self) { array in
                        HStack {
                            Image(systemName: "book.circle.fill")
                                .frame(width: UIScreen.main.bounds.width/10, height: 10, alignment: .leading)
                                .foregroundColor(Color(.systemGray))
                            VStack(alignment:.leading) {
                                Text(array.date)
                                    .font(.title3)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color(.darkGray))
                                Text(array.counts+"個疾病資料")
                                    .font(.callout)
                                    .foregroundColor(Color(.darkGray))
                            }.frame(width: UIScreen.main.bounds.width/2, height: 10, alignment: .leading)
                            Button(action: {
                                change_clicked(id: array.id)
                            }) {
                                Image(systemName: array.check)
                                    .frame(width: UIScreen.main.bounds.width/4, height: 10, alignment: .trailing)
                                    .foregroundColor(Color(red: 0.416, green: 0.624, blue: 0.608))
                            }
                        }
                        .font(.title)
                        .padding(.vertical,30)
                        .padding(.horizontal, 10)
                    }.onDelete(perform: deleteListItem)
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                Text("健康存摺")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Button(action: {
                    print("aaa")
                }) {
                    Image(systemName: "plus")
                }
            }
                
    })
    .navigationBarTitleDisplayMode(.inline)
        
        
    }
}
struct Health_Passport_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView{
            Health_Passport()
        //}
    }
}

//authored doctor

struct doctor_authorization_list: Identifiable,Hashable {
    var id : Int//= UUID()
    var hospital: String
    var department: String
    var name: String
}

struct Doctor_Authorization: View {
    @State private var selectedTab = 1
    @State var insertview = false
    @State var showingDetail = false
    @State var data_array = [String(keychain["email"] ?? ""),String(keychain["password"] ?? "")]
    @State var author_doctor_list_data = [doctor_authorization_list(id:0,hospital:"林口長庚",department:"骨科",name:"李雍正"),doctor_authorization_list(id:1,hospital:"台北長庚",department:"胸腔外科",name:"郭健民"),doctor_authorization_list(id:2,hospital:"台大",department:"心臟科",name:"王健民")]
    @State var author_doctor_list_data_2 = [DoctorAuth.Doctor_auth(id:0,department:"科別",hospital:"醫院",name:"姓名")]
    @State var state = 0
    @State private var isLoading = false
    @State var result_out = "fail"
    
    @State var isAnimating: Bool = true
    var count: UInt = 3
    var width: CGFloat = 2
    var spacing: CGFloat = 1
    func configureBackground() {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = UIColor.init(Color(red: 0.416, green: 0.624, blue: 0.608))
            UINavigationBar.appearance().standardAppearance = barAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
    }
    func check_password(){
        let aes = try! AES(key: aeskey, blockMode: CBC(iv: aesiv), padding: .pkcs7)
        data_array[0] = try! keychain["email"]?.decryptBase64ToString(cipher: aes) as! String
        data_array[1] = try! keychain["password"]?.decryptBase64ToString(cipher: aes) as! String
    }
    func get_data(){
        check_password()
        let body = "email="+data_array[0]+"&password="+data_array[1]
        print(body)
        postData(from:"https://lunsenlu.cf/account/check_id",from: body) { result in switch result {
            case .success(let str):
                result_out = str.result
                print("aaa ",result_out)
                let body_2 = "email="+data_array[0]+"&user_id="+result_out
                postData_get_doctorauthdata(from:"https://lunsenlu.cf/doctor_auth/get_doctor_auth_ios",from: body_2) { result in switch result {
                    case .success(let str):
                        print(str)
                        result_out = str.result
                        author_doctor_list_data_2 = str.doctor_auth
                        state = author_doctor_list_data_2[0].name != "姓名" ? 2 : 1
                        print(state)
                        print("aaa ",result_out)
                    case .failure(let error):
                        switch error {
                        case .badURL:
                            print("Bad URL")
                        case .requestFailed:
                            print("Network problems")
                        case .unknown:
                            print("Unknown error")
                        }
                    }
                }
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
    }
    init() {
        configureBackground()
        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
    }
    func deleteListItem(whichElement: IndexSet) {
        whichElement.forEach(){ element in
            author_doctor_list_data.remove(atOffsets: whichElement)
            print(author_doctor_list_data_2[element].name)
            let body = "email="+data_array[0]+"&password="+data_array[1]
            print(body)
            postData(from:"https://lunsenlu.cf/account/check_id",from: body) { result in switch result {
                case .success(let str):
                    result_out = str.result
                    print("aaa ",result_out)
                    let body_2 = "email="+data_array[0]+"&user_id="+result_out+"&position="+String(element)
                    postData_get_doctorauthdata(from:"https://lunsenlu.cf/doctor_auth/delete_doctor_auth",from: body_2) { result in switch result {
                        case .success(let str):
                            
                            print(str)
                            //print(result)
                            result_out = str.result
                            print("delete doctor_auth ",result_out)
                        case .failure(let error):
                            switch error {
                            case .badURL:
                                print("Bad URL")
                            case .requestFailed:
                                print("Network problems")
                            case .unknown:
                                print("Unknown error")
                            }
                        }
                    }
                case .failure(let error):
                    switch error {
                    case .badURL:
                        print("Bad URL")
                    case .requestFailed:
                        print("Network problems")
                    case .unknown:
                        print("Unknown error")
                    }
                }
            }
        }
    }
    func insertchange(_ tag:Bool){
        print(tag)
        get_data()
    }
    func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
            Group { () -> Path in
                var p = Path()
                p.addArc(center: CGPoint(x: geometrySize.width/2, y: geometrySize.height/2),
                         radius: geometrySize.width/2 - width/2 - CGFloat(index) * (width + spacing),
                         startAngle: .degrees(0),
                         endAngle: .degrees(Double(Int.random(in: 120...300))),
                         clockwise: true)
                return p.strokedPath(.init(lineWidth: width))
            }
            .frame(width: geometrySize.width, height: geometrySize.height)
        }
    var body: some View {
        Group{
            if(state == 0){
                CircleLoader()
            }
            else if (state == 1){
                Text("目前並無授權給醫生")
            }
            else{
                List {
                    ForEach(author_doctor_list_data_2,id: \.self) { array in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .frame(width: UIScreen.main.bounds.width/10, height: 10, alignment: .leading)
                                .foregroundColor(Color(.systemGray))
                            VStack(alignment:.leading) {
                                Text(array.name+"醫師")
                                    .font(.title3)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color(.darkGray))
                                Text(array.hospital+" "+array.department)
                                    .font(.callout)
                                    .foregroundColor(Color(.darkGray))
                            }.frame(width: UIScreen.main.bounds.width/2, height: 10, alignment: .leading)
                        }
                        .font(.title)
                        .padding(.vertical,30)
                        .padding(.horizontal, 10)
                    }.onDelete(perform: deleteListItem)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
        .bottomSheet(isPresented: $showingDetail, height: UIScreen.main.bounds.height*0.4) {
            DoctorInsertView(isPresented: self.$showingDetail)
        }
        .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("醫生授權")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button(action: {
                        //get_data()
                        self.showingDetail = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                    
        }) .onAppear {
            get_data()
        }
        
        
    }
}


struct Doctor_Authorization_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Doctor_Authorization()
        }
    }
}


struct DoctorInsertView: View {
    @Binding var isPresented: Bool

    @State var data_array = [String(keychain["email"] ?? ""),String(keychain["password"] ?? "")]
    @State private var hospitals = ["-"]//["林口長庚醫院","台北長庚醫院","台大醫院","榮民總醫院"]
    @State private var selectedHospitals = 0
    @State private var catelogorys = ["-"]//["骨科","心臟科","肝膽腸胃科","榮民總醫院","神經外科","神經科"]
    @State private var selectedCatelogorys = 0
    @State private var doctorname = ["-"]//["王維陽","王維哲","林俊嘉"]
    @State private var selectedDoctorname = 0
    func check_password(){
        let aes = try! AES(key: aeskey, blockMode: CBC(iv: aesiv), padding: .pkcs7)
        data_array[0] = try! keychain["email"]?.decryptBase64ToString(cipher: aes) as! String
        data_array[1] = try! keychain["password"]?.decryptBase64ToString(cipher: aes) as! String
    }
    func add(){
        check_password()
        print(hospitals[selectedHospitals]," ",catelogorys[selectedCatelogorys]," ",doctorname[selectedDoctorname])
        let body = "email="+data_array[0]+"&password="+data_array[1]
        postData(from:"https://lunsenlu.cf/account/check_id",from: body) { result in switch result {
            case .success(let str):
                print("id ",str.result)
                let body_2 = "user_id"+str.result+"&hospital="+hospitals[selectedHospitals]+"&department="+catelogorys[selectedCatelogorys]+"&name="+doctorname[selectedDoctorname]
                print(body_2)
                postData(from:"https://lunsenlu.cf/doctor_auth/insert_doctor_auth",from: body_2) { result in switch result {
                    case .success(let str):
                        //result_out = str.result
                        print("insert doctor_auth ",str.result)
                    case .failure(let error):
                        switch error {
                        case .badURL:
                            print("Bad URL")
                        case .requestFailed:
                            print("Network problems")
                        case .unknown:
                            print("Unknown error")
                        }
                    }
                }
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
        print(isPresented)
        self.isPresented = false
    }
    func cancel(){
        print(isPresented)
        self.isPresented = false
        
    }
    
    func get_hospitals(){
        getData_hospitals(from:"https://lunsenlu.cf/doctor/get_hospitals_ios") { result in switch result {
            case .success(let str):
                print(str)
                hospitals = ["-"]
                hospitals += str.data
                print("get hospitals ",str.result)
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
    }
    
    func hospitalChange(_ tag:Int){
        print(hospitals[tag])
        let body = "hospital="+hospitals[tag]
        postData_get_doctordata(from:"https://lunsenlu.cf/doctor/get_departments_ios",from: body) { result in switch result {
            case .success(let str):
                
                print(str)
                catelogorys = ["-"]
                doctorname = ["-"]
                catelogorys += str.data
                selectedCatelogorys = 0
                selectedDoctorname = 0
                print("get doctor department ",str.result)
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
        sleep(1)
    }
    

    
    func departmentChange(_ tag:Int){
        print(hospitals[selectedHospitals],"  ",catelogorys[tag])
        let body = "hospital="+hospitals[selectedHospitals]+"&department="+catelogorys[tag]
        postData_get_doctordata(from:"https://lunsenlu.cf/doctor/get_doctors_ios",from: body) { result in switch result {
            case .success(let str):
                print(str)
                doctorname = ["-"]
                doctorname += str.data
                selectedDoctorname = 0
                print("get doctor doctors ",str.result)
            case .failure(let error):
                switch error {
                case .badURL:
                    print("Bad URL")
                case .requestFailed:
                    print("Network problems")
                case .unknown:
                    print("Unknown error")
                }
            }
        }
        sleep(1)
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
                Text("新增醫生授權").foregroundColor(.white).font(.title3).padding(10)
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
            .onAppear {
                get_hospitals()
            }
            Form {
                Section {
                    Picker(selection: $selectedHospitals.onChange(hospitalChange), label: Text("醫院")) {
                        ForEach(0 ..< hospitals.count) {
                            Text(self.hospitals[$0])
                        }
                    }.id(hospitals.count)
                }
                Section {
                    Picker(selection: $selectedCatelogorys.onChange(departmentChange), label: Text("科別")) {
                        ForEach(0 ..< catelogorys.count) {
                            Text(self.catelogorys[$0])
                        }
                    }.id(catelogorys.count)
                }
                Section {
                    Picker(selection: $selectedDoctorname, label: Text("姓名")) {
                        ForEach(0 ..< doctorname.count) {
                            Text(self.doctorname[$0])
                        }
                    }.id(doctorname.count)
                }
                Section(header:Text("   ")){
                    EmptyView()
                }
            }.navigationBarTitle("取消")
            }.navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
           
        }.accentColor(.white)
        
    }
}
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
