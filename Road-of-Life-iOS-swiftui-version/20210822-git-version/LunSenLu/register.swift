//
//  Register.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2020/11/23.
//

import Foundation
import SwiftUI
import CryptoSwift

struct Register: View {
    let lyrics = ["姓名", "手機", "email","密碼","密碼確認"]
    let img_lyrics = ["user", "call", "envelope_2","lock_2","lock_2"]
    @State var output = ["", "", "","",""]
    @State var result_out = "fail"
    @State var accounterror = false
    var body: some View {
        if result_out == "sucess"{
            Main()
        }
        else{
            VStack(spacing: 0)  {
                ForEach(lyrics.indices) { (index) in
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 50){
                        Spacer()
                        Image(img_lyrics[index])
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width/20,height: UIScreen.main.bounds.width/20)
                        
                        TextField(lyrics[index],text: $output[index])
                                .frame(width: UIScreen.main.bounds.width/2).foregroundColor(Color(red: 0.416, green: 0.624, blue: 0.608))
                        
                        Spacer()
                    }.padding(10)
                    LineView().frame(width: UIScreen.main.bounds.width/1.3, height: 1.0, alignment: .center)
                    Spacer()
                }
                Spacer()
                Button(action: {
                    print("Hello button tapped!")
                    let body = "name="+output[0]+"&phone="+output[1]+"&email="+output[2]+"&password="+output[3]
                    postData(from:"https://lunsenlu.cf/account/register",from:body) { result in switch result {
                        case .success(let str):
                            print(str.result)
                            result_out = str.result
                            if result_out != "sucess"{
                                accounterror = true
                            }
                            else{
                                accounterror = false
                                let aes = try! AES(key: aeskey, blockMode: CBC(iv: aesiv), padding: .pkcs7)
                                keychain["email"] = try! aes.encrypt(output[2].bytes).toBase64()
                                keychain["password"] = try! aes.encrypt(output[3].bytes).toBase64()
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
                }) {
                    HStack{
                        Text("註冊")
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
            }.padding(.vertical, UIScreen.main.bounds.height/20)
            .accentColor(Color(red: 0.416, green: 0.624, blue: 0.608))
        }
    }
}
struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
