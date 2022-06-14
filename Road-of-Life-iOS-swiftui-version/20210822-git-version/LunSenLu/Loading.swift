//
//  ContentView.swift
//  test
//
//  Created by BioLab.NTUT on 2020/11/3.
//

import SwiftUI
import CryptoSwift
import KeychainAccess
import CryptoKit

struct Loading: View {
    @State private var isActive:Bool = false
    
    init() {
        //check aes key and iv
        if(keychain["AESkey"] == nil){
            let password: [UInt8] = Array("lunsenlu.cf".utf8)
            let salt: [UInt8] = Array("nacllcan".utf8)
            let key = try! PKCS5.PBKDF2(
                password: password,
                salt: salt,
                iterations: 4096,
                keyLength: 16, /* AES-256 */
                variant: .sha256
            ).calculate()
            print(key)
            //let data = Data(bytes: key)
            let string = bytesToRadix(key, radix: 36)
            //let baseString = String(key, radix: 64, uppercase: false)
            keychain["AESkey"] = string
            print(keychain["AESkey"])
        }
        if (keychain["AESiv"] == nil){
            let iv = AES.randomIV(AES.blockSize)
            let string = bytesToRadix(iv, radix: 36)
            keychain["AESiv"] = string
            print(keychain["AESiv"])
        }
        aeskey = radixToBytes(keychain["AESkey"]!, radix: 36)
        aesiv = radixToBytes(keychain["AESiv"]!, radix: 36)
    }
    var body: some View {
        NavigationView {
            VStack {
                if(isActive){
                    if(keychain["email"] != nil || keychain["password"] != nil ){
                        Main()
                    }
                    else {
                        Login()
                    }
                }
                else{
                    Image("logo_2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width/2,height: UIScreen.main.bounds.width/2)
                    NavigationLink(
                        destination: Login()){
                        Text("Loading...")
                            .font(.title)
                            .foregroundColor(Color(red: 0.416, green: 0.624, blue: 0.608))
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }

            }
            .navigationTitle("loading")
            .navigationBarHidden(true)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    withAnimation{
                        self.isActive = true
                }
                }

            }
            
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
