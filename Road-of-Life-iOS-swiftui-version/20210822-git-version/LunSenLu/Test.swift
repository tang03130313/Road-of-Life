//
//  Test.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2020/11/26.
//
import Foundation
import SwiftUI
import CryptoSwift
import KeychainAccess
import CryptoKit



struct Test: View {
    //@State var results = Result()
    @State private var result_output = ""
    func configureBackground() {
            let barAppearance = UINavigationBarAppearance()
            barAppearance.backgroundColor = UIColor.init(Color(red: 0.416, green: 0.624, blue: 0.608))
            UINavigationBar.appearance().standardAppearance = barAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = barAppearance
        }
    func get(){
        if let url = URL(string: "https://lunsenlu.cf/health_passport/get_api") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let aaa = try JSONDecoder().decode(Responseget.self, from: data)
                        print(aaa)
                        print(aaa.result)
                        //result = aaa.result
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    func post_2(){
        let body = "email=test@gmail.com&password=Test"
        postData(from:"https://lunsenlu.cf/account/login",from:body) { result in switch result {
            case .success(let str):
                print(str)
                print(str.result)
                result_output = str.result
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
    func post(){
        if let url = URL(string: "https://lunsenlu.cf/account/login") {
            var request = URLRequest(url: url)
            request.setValue(
                "authToken",
                forHTTPHeaderField: "Authorization"
            )
            let body = ["email": "test@gmail.com","password":"Test"]
            let bodyData = try? JSONSerialization.data(
                withJSONObject: body,
                options: []
            )
            request.httpMethod = "POST"
            request.httpBody = bodyData
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let aaa = try JSONDecoder().decode(Responseget.self, from: data)
                        //print(aaa)
                        print(aaa.result)
                        result_output = aaa.result
                        //return completion(aaa.result)
                        let t = type(of: aaa)
                        print("'\(aaa)' of type '\(t)'")
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    func fetchData(from urlString: String, completion: @escaping (Result<Responseget, NetworkError>) -> Void) {
        // check the URL is OK, otherwise return with a failure
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            // the task has completed – push our work back to the main thread
            DispatchQueue.main.async {
                if let data = data {
                    // success: convert the data to a string and send it back
                    //let stringData = String(decoding: data, as: UTF8.self)
                    do {
                        let Data = try JSONDecoder().decode(Responseget.self, from: data)
                        completion(.success(Data))
                    } catch {
                        print(error)
                    }
                    
                } else if error != nil {
                    // any sort of network failure
                    completion(.failure(.requestFailed))
                } else {
                    // this ought not to be possible, yet here we are
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
    /*func encrypt(){
        let keychain = Keychain(service: "com.lunsenlu.cf")
        let key = radixToBytes(keychain["AESkey"]!, radix: 36)
        var iv = radixToBytes(keychain["AESiv"]!, radix: 36)
        //let key = Array(keychain["AESkey"]!.utf8)
        //var iv = Array(keychain["AESiv"]!.utf8)
        
        let t = type(of:key)
        print(key)
        
        let str = "sadfads12312sdfsd"
        var aes = try! AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
        
        //开始加密
        let encrypted = try! aes.encrypt(str.bytes)
        print(encrypted)
        let encryptedBase64 = encrypted.toBase64() //将加密结果转成base64形式
        print("加密结果(base64)：\(encryptedBase64!)")
         
        //开始解密1（从加密后的字符数组解密）
        let decrypted1 = try! aes.decrypt(encrypted)
        print("解密结果1：\(String(data: Data(decrypted1), encoding: .utf8)!)")
        //开始解密2（从加密后的base64字符串解密）
        let decrypted2 = try! encryptedBase64?.decryptBase64ToString(cipher: aes)
        print("解密结果2：\(decrypted2!)")
    }
    
    func ende(){
        let keychain = Keychain(service: "com.lunsenlu.cf")
        let str = "test123test"
        print(str)
        let key = keychain["AESkey"]
        let iv = keychain["AESiv"]
        let aes = try! AES(key:key!.bytes , blockMode: CBC(iv:iv!.bytes))
        let encrypted = try! aes.encrypt(str.bytes)
        print("加密結果： \(encrypted.toBase64()!)")
        let decrypted = try! aes.decrypt(encrypted)
        print("解密結果： \(String(data: Data(decrypted), encoding: .utf8)!)")
    }*/
    
    init() {
        configureBackground()
        let body: [String:String] = ["email": "test@gmail.com","password": "Test"]
        testPoseData(from:"https://lunsenlu.cf/account/get_personal_data",from: body){ result in switch result {
            case .success(let str):
                
                //print(str)
                //print(result)
                //result_out = str.result
                print(str.result)
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
        //get()
        //post()
        //encrypt()
        /*let keychain = Keychain(service: "com.lunsenlu.cf")
        keychain["AESkey"] = nil
        keychain["AESiv"] = nil
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
            //print(keychain["AESkey"])
        }
        if (keychain["AESiv"] == nil){
            let iv = AES.randomIV(AES.blockSize)
            let string = bytesToRadix(iv, radix: 36)
            keychain["AESiv"] = string
            //print(keychain["AESiv"])
        }*/
        //ende()
        //encrypt()
    }
    
    
    var body: some View {
        VStack{
            Text("aaa").toolbar(content: {
                ToolbarItem(placement: .principal) { Text("隱私權政策") .font(.title2)
                    .foregroundColor(.white)}
                            }).navigationBarTitleDisplayMode(.inline)
            .onAppear(){
                //self.post_2()
                /*self.fetchData(from: "https://lunsenlu.cf/health_passport/get_api") { result in
                            switch result {
                            case .success(let str):
                                print(str)
                                print(str.result)
                                result_output = str.result
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
                        }*/
            }
            Text(result_output)
        }
    }
}
struct Test_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Test()
        }
    }
}

import WebKit

struct WebView2: UIViewRepresentable {
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

struct WebView2_Previews: PreviewProvider {
    static var previews: some View {
        WebView2()
    }
}



class KeychainService {
    func save(_ password: String, for account: String) {
        let password = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return print("save error")
        }
    }
    func retrivePassword(for account: String) -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: account,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue]
        
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        
        guard let data = retrivedData as? Data else {return nil}
        return String(data: data, encoding: String.Encoding.utf8)
    }
}








