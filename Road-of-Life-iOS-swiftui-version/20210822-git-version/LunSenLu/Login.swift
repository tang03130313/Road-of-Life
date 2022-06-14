//
//  test2.swift
//  test
//
//  Created by BioLab.NTUT on 2020/11/4.
//

import Foundation
import SwiftUI
import CryptoSwift
import KeychainAccess
import CryptoKit

struct Login: View {
    @State var email = ""
    @State var password = ""
    @State var result_out = "fail"
    @State var accounterror = false
    func login(){
        //print(email)
        //print(password)
        let body = "email="+email+"&password="+password
        postData(from:"https://lunsenlu.cf/account/login",from:body) { result in switch result {
            case .success(let str):
                print(str.result)
                result_out = str.result
                if result_out != "sucess"{
                    accounterror = true
                }
                else{
                    accounterror = false
                    let aes = try! AES(key: aeskey, blockMode: CBC(iv: aesiv), padding: .pkcs7)
                    keychain["email"] = try! aes.encrypt(email.bytes).toBase64()
                    keychain["password"] = try! aes.encrypt(password.bytes).toBase64()
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
    
    var body: some View {
        if result_out == "sucess"{
            Main()
        }
        else{
            NavigationView{
                VStack(spacing: 0)  {
                    Image("logo_2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width/2.5,height: UIScreen.main.bounds.width/2.5)
                    Group{
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 50){
                            Spacer()
                            Image("envelope_2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width/20,height: UIScreen.main.bounds.width/20)
                            TextField("example.com",text: $email)
                                    .frame(width: UIScreen.main.bounds.width/2).foregroundColor(Color(red: 0.2524, green: 0.3786, blue: 0.369, opacity: 1.0))
                            
                            Spacer()
                        }.padding(10)
                        LineView().frame(width: UIScreen.main.bounds.width/1.3, height: 1.0, alignment: .center).padding(.bottom,20)
                    }
                    Group{
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 50){
                            Image("lock_2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width/20,height: UIScreen.main.bounds.width/20)
                            SecureField("............",text: $password)
                                .frame(width: UIScreen.main.bounds.width/2).foregroundColor(Color(red: 0.2524, green: 0.3786, blue: 0.369))
                        }.padding(10)
                        LineView().frame(width: UIScreen.main.bounds.width/1.3, height: 1.0, alignment: .center)
                    }
                    Spacer()
                    if self.accounterror{
                        Text("錯誤的帳號或密碼").foregroundColor(.red)
                    }
                    else{
                        Text("").foregroundColor(.red)
                        
                    }
                    Spacer()
                    
                    Button(action: {self.login()}) {
                        HStack{
                            Text("登入")
                                .fontWeight(.semibold)
                                .font(.body)
                        }
                        .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width/1.5)//.infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 0.416, green: 0.624, blue: 0.608))
                        .cornerRadius(40)
                        .padding(.horizontal, 20)
                        
                    }
                    
                    Spacer()
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10){
                        NavigationLink("忘記密碼",destination: Test()).foregroundColor(Color(red: 0.416, green: 0.624, blue: 0.608))
                        Text("|").foregroundColor(Color(red: 0.416, green: 0.624, blue: 0.608))
                        
                        NavigationLink("註冊會員", destination: Policy2()).foregroundColor(Color(red: 0.416, green: 0.624, blue: 0.608))
                        
                    }.padding(5)
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 50){
                        NavigationLink("隱私權政策", destination: Policy()).foregroundColor(Color(red: 0.416, green: 0.624, blue: 0.608))
                    }.padding(10)
                    
                }.navigationTitle("登入")
                .navigationBarHidden(true)
                .padding(.vertical, UIScreen.main.bounds.height/7)
            }.accentColor(.white)
        }
        
    }
}
struct LineView: UIViewRepresentable {

    typealias UIViewType = UIView
    func makeUIView(context: UIViewRepresentableContext<LineView>) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LineView>) {
    }
}
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}


