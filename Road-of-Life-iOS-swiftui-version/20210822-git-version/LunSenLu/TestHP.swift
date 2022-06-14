//  TestHP.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2021/1/20.
//
import Foundation
import SwiftUI
import MHBSdk
import Zip
import CryptoSwift
import UIKit

extension String {
    var decoded: String {
        let attr = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil)

        return attr?.string ?? self
    }
}
extension Data {
    func hexString() -> String {
        let nsdataStr = NSData.init(data: self)
        return nsdataStr.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
    }
}

struct testtttt: Codable {
    let myhealthbank: Data
}

struct TestHP: View {
    
    @State var finalkey = ""
    init() {
    }
    class MHBD: MHBDelegate {

        func didStartProcSuccess(){
            
        }

        func didStartProcFailure(error: String){
            
        }

        func didFetchDataSuccess(file: Data, serverKey: String){
            //第三方 APP 自行處理 zip 檔案接收與解密
            //解密時，需以前述方法產生之解密金鑰來解密該檔案，並將結果儲存為.json 檔
            do {
                print(file)
                print(type(of: file))
                let hp_password: [UInt8] = Array(hp_apiKey.utf8)
                let hp_key = try PKCS5.PBKDF2(
                    password: hp_password,
                    salt: [UInt8](serverKey.utf8),
                    iterations: 1000,
                    keyLength: 32, /* AES-256 */
                    variant: .sha1
                ).calculate()
                let hp_key_str = hp_key.toBase64()!
                print("hp_apiKey: ",hp_apiKey)
                print("server key: ",serverKey)
                print(hp_key_str)
                print(type(of: hp_key_str))
                
                
                
                
                var documentsFolder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
                documentsFolder = documentsFolder.appendingPathComponent("archieve_final333.zip")
                let documentsDirectory_2 = NSHomeDirectory() + "/Documents/archieve_final333/"
                let destinationPath = URL(fileURLWithPath: documentsDirectory_2)
                
                do {
                    let aaa = try file.write(to: documentsFolder)
                    print("fussd   ",aaa)
                } catch {
                    print(error.localizedDescription)
                }
                
                
                try Zip.unzipFile(documentsFolder, destination: destinationPath, overwrite: true, password: hp_key_str, progress: { (progress) -> () in
                    print(progress)
                })
                print("aaaabbb")
                do{
                    let fileList = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory_2)
                    for file in fileList{
                        print(file)
                    }
                    var isDirectory:ObjCBool = false
                    do{

                        let loading = try NSString(contentsOfFile: documentsDirectory_2+fileList[0], encoding: String.Encoding.utf8.rawValue)
                        //print(loading)
                        
                        let json_data: String = loading as String
                        let range = json_data.startIndex..<json_data.index(before: json_data.index(json_data.startIndex, offsetBy: json_data.count-2))
                        //print(json_data[range])
                        
                        let body = "email="+"test@gmail.com"+"&password="+"Test"+"&user_id="+"A114236551"+"&passport_json="+json_data
                        postData(from:"https://lunsenlu.cf/health_passport/insert_health_passport_ios",from:body) { result in switch result {
                            case .success(let str):
                                print(str.result)
                                let result_out = str.result
                                if result_out != "sucess"{
                                    print("MHB fail")
                                }
                                else{
                                    print("MHB success")
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
                    }catch{
                        print("No save file")
                    }
                }
                catch{
                    print("Cannot list directory")
                }

            }
            catch {
              print("Something went wrong")
            }
        }

        func didFetchDataFailure(error: String){
            print("Error Code : "+error)
        }

        func didMHBExit(){
            
        }
    }
    let MHBC = MHBD()
    
    func didStartProcSuccess(){
    //畫面已初始化呈現於第三方 APP
        print("onUIProcStart...")
        
    }
    func didStartProcFailure(error: String){ //回傳 Error Code
        print(error)
    }
    
    func didMHBExit() {
        //SDK 經關閉後，第三方 APP 進行其他處理
        print("didMHBExited")
    }
    func starthp(){
        MHB.configure(APIKey:hp_apiKey)
        MHB.start(MHBC)
    }

    func getfile(){
        //MHB.fecfhData(self,fileTicket:[File_Ticket_[device_local_timestamp]])
        var arrR: [String] = []
        let arr = UserDefaults.standard.dictionaryRepresentation()
        for item in arr {
            if item.key.contains("File_Ticket_") { //可依已紀錄的起始/結束時間戳記區間內查詢前次 SDK 存入的檔案識別碼
                arrR.append(item.key)
            }
        }
        
        if !arrR.isEmpty{
            print(arrR)
            let arrRlast = arrR.removeLast()
            //print(arrR[0])
            MHB.fetchData(MHBC.self, fileTicket: arrRlast)
            //arrR.remove(at: 0)
        }
    }
    //加密压缩
    func zipFileWithPassword()
    {
    //添加一个异常捕捉语句，实现压缩文件
        do
        {
            
            
            //初始化一个字符串常量，表示项目中带压缩文件的路径
            let filePath = Bundle.main.url(forResource: "hp_bundle", withExtension: "bundle")!
            //获得沙箱目录中，文档文件的路径
            var documentsFolder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
            //在文档文件路径的末尾，添加文件的名称，作为压缩后的文件所在的路径。
            documentsFolder = documentsFolder.appendingPathComponent("NewArchivedFile2.zip")
            //调用第三方类库的压缩文件的方法，将数据库文件进行压缩，并设置安全密码。
            //同时设置压缩的模式为最佳模式.
            try Zip.zipFiles(paths: [filePath], zipFilePath: documentsFolder, password: "coolketang", compression: .BestCompression, progress:
            {(progress) -> () in
                    //压缩的过程中,在控制台实时输出压缩的进度。
                    print(progress)
            })
                 //输出压缩后的文件所在的绝对路径
            print("destinationPath:\(documentsFolder)")
        }
        catch
        {
            print("Something went wrong")
        }
    }
    func zipFileWithPassword_2()
    {
    //添加一个异常捕捉语句，实现压缩文件
        do
        {
            let str  = "testesetstsets。   中文 西醫 中醫 ： ， 。 住院 門診 Café"
            let file = Data(str.utf8)
            print(file)
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date_str = formatter.string(from: today)
            let filedata = ArchiveFile(filename:date_str,data:file as NSData,modifiedTime:today)
            //初始化一个字符串常量，表示项目中带压缩文件的路径
            //let filePath = Bundle.main.url(forResource: "hp_bundle", withExtension: "bundle")!
            //获得沙箱目录中，文档文件的路径
            var documentsFolder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
            //在文档文件路径的末尾，添加文件的名称，作为压缩后的文件所在的路径。
            documentsFolder = documentsFolder.appendingPathComponent("NewArchivedFile3.zip")
            //调用第三方类库的压缩文件的方法，将数据库文件进行压缩，并设置安全密码。
            //同时设置压缩的模式为最佳模式.
            try Zip.zipData(archiveFiles: [filedata], zipFilePath: documentsFolder, password: "coolketang",compression: .BestCompression, progress: { (progress) -> () in
                    print(progress)
                }) //Zip
            /*try Zip.zipFiles(paths: [filePath], zipFilePath: documentsFolder, password: "coolketang", compression: .BestCompression, progress:
            {(progress) -> () in
                    //压缩的过程中,在控制台实时输出压缩的进度。
                    print(progress)
            })*/
                 //输出压缩后的文件所在的绝对路径
            print("destinationPath:\(documentsFolder)")
        }
        catch
        {
            print("Something went wrong")
        }
    }
    //解压加密压缩
    func unzipFileWithPassword_2()
    {
        //添加一个异常捕捉语句，实现解压加密压缩
        do
        {
            //获得在沙箱目录中，文档文件夹的路径
            var documentsFolder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
            //在文档文件路径的末尾，添加文件的名称，作为在上一个方法中压缩文件所在的位置
            documentsFolder = documentsFolder.appendingPathComponent("archive_final.zip") // NewArchivedFile3
            let documentsDirectory = NSHomeDirectory() + "/Documents/archive_final/" //NewArchivedFile3
            //初始化一个网址对象，作为解压后的文件的目标位置。
            let destinationPath = URL(fileURLWithPath: documentsDirectory)
            print(destinationPath)
            //调用第三方类库的解压文件的方法，设置解压的密码，
            //将指定的压缩文件，解压到指定的文件夹。
            try Zip.unzipFile(documentsFolder, destination: destinationPath, overwrite: true, password: "coolketang", progress: { (progress) -> () in
                     //并在控制台输出解压进度
                print(progress)
            })
                 //输出解压后的文件所在的绝对路径
            print("destinationPath:\(destinationPath)")
            //let t = type(of: destinationPath)
            //print("'\(destinationPath)' of type '\(t)'")
            let fm = FileManager.default
            //let path = Bundle.main.resourcePath!
            //let url = URL(string: destinationPath)
            //let urlString = url.absoluteString

            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: destinationPath, includingPropertiesForKeys: nil)
                print(fileURLs)
                do {
                 // Get the saved data
                    //let loading = try NSString(contentsOfFile: String(contentsOf: fileURLs[0]), encoding: String.Encoding.unicode.rawValue)
                    //print(loading)
                 /*let savedData = try Data(contentsOf: fileURLs[0])
                    print(savedData)
                    print(savedData.count)
                    let bytes: Data = savedData*/
                 // Convert the data back into a string
                    /*if let savedString = String(data: savedData.subdata(in: 0 ..< savedData.count - 1), encoding: String.Encoding.utf8) {
                    print(savedString)
                 }*/
                    /*let newStr1 = String(data: savedData.subdata(in: 0 ..< savedData.count - 1), encoding: .utf8)
                    print(newStr1)*/
                    do{
                        let savedData = try Data(contentsOf: fileURLs[0])
                        let loading =  try JSONDecoder().decode([testtttt].self, from: savedData)
                        print()
                    }catch{
                        print("No save file 1 ")
                    }
                } catch {
                 // Catch any errors
                 print("Unable to read the file")
                }
                // process files
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
            
        }
        catch
        {
            print("Something went wrong")
        }
    }
    
    func unzipFileWithPassword_3()
    {
        //添加一个异常捕捉语句，实现解压加密压缩
        do
        {
            //获得在沙箱目录中，文档文件夹的路径
            var documentsFolder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
            //在文档文件路径的末尾，添加文件的名称，作为在上一个方法中压缩文件所在的位置
            documentsFolder = documentsFolder.appendingPathComponent("NewArchivedFile3.zip")
            let documentsDirectory = NSHomeDirectory() + "/Documents/NewArchivedFile3/"
            //初始化一个网址对象，作为解压后的文件的目标位置。
            let destinationPath = URL(fileURLWithPath: documentsDirectory)
            print(destinationPath)
            //调用第三方类库的解压文件的方法，设置解压的密码，
            //将指定的压缩文件，解压到指定的文件夹。
            try Zip.unzipFile(documentsFolder, destination: destinationPath, overwrite: true, password: "coolketang", progress: { (progress) -> () in
                     //并在控制台输出解压进度
                print(progress)
            })
                 //输出解压后的文件所在的绝对路径
            print("destinationPath:\(destinationPath)")
            //let t = type(of: destinationPath)
            //print("'\(destinationPath)' of type '\(t)'")
            let fm = FileManager.default
            //let path = Bundle.main.resourcePath!
            //let url = URL(string: destinationPath)
            //let urlString = url.absoluteString
            do{
                let fileList = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory)
                print(fileList)
                do{
                    let loading = try NSString(contentsOfFile: documentsDirectory+fileList[0], encoding: String.Encoding.utf8.rawValue)
                  print(loading)
                }catch{
                    print("No save file")
                }
            }
            catch{
                print("Cannot list directory")
            }
            
            
        }
        catch
        {
            print("Something went wrong")
        }
    }
    func unzipFileWithPassword_4()
    {
        //添加一个异常捕捉语句，实现解压加密压缩
        do
        {
            
            //获得在沙箱目录中，文档文件夹的路径
            var documentsFolder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
            //在文档文件路径的末尾，添加文件的名称，作为在上一个方法中压缩文件所在的位置
            documentsFolder = documentsFolder.appendingPathComponent("archive_final.zip")
            let documentsDirectory = NSHomeDirectory() + "/Documents/archive_final/"
            //初始化一个网址对象，作为解压后的文件的目标位置。
            let destinationPath = URL(fileURLWithPath: documentsDirectory)
            print(destinationPath)
            //调用第三方类库的解压文件的方法，设置解压的密码，
            //将指定的压缩文件，解压到指定的文件夹。
                 //输出解压后的文件所在的绝对路径
            print("destinationPath:\(destinationPath)")
            do{
                let fileList = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory)
                print(fileList)
                
                do{
                    let loading = try NSString(contentsOfFile: documentsDirectory+fileList[0], encoding: String.Encoding.utf8.rawValue)
                    print(loading)
                }catch{
                    print("No save file 2 ")
                }
                do{
                    let cfEnc = CFStringEncodings.macChineseTrad
                    let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                    let loading = try NSString(contentsOfFile: documentsDirectory+fileList[0], encoding:  String.Encoding(rawValue: enc).rawValue)
                    print(loading)
                }catch{
                    print("No save file 3 ")
                }
            }
            catch{
                print("Cannot list directory")
            }
            
            
        }
        catch
        {
            print("Something went wrong")
        }
    }
    
    func unzipFileWithPassword_2333()
    {
        //添加一个异常捕捉语句，实现解压加密压缩
        do
        {
            //获得在沙箱目录中，文档文件夹的路径
            var documentsFolder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
            //在文档文件路径的末尾，添加文件的名称，作为在上一个方法中压缩文件所在的位置
            documentsFolder = documentsFolder.appendingPathComponent("archive_final.zip") // NewArchivedFile3
            let documentsDirectory = NSHomeDirectory() + "/Documents/archive_final/" //NewArchivedFile3
            //初始化一个网址对象，作为解压后的文件的目标位置。
            let destinationPath = URL(fileURLWithPath: documentsDirectory)
            print(destinationPath)
            //调用第三方类库的解压文件的方法，设置解压的密码，
            //将指定的压缩文件，解压到指定的文件夹。
            try Zip.unzipFile(documentsFolder, destination: destinationPath, overwrite: true, password: "coolketang", progress: { (progress) -> () in
                     //并在控制台输出解压进度
                print(progress)
            })
                 //输出解压后的文件所在的绝对路径
            print("destinationPath:\(destinationPath)")
            //let t = type(of: destinationPath)
            //print("'\(destinationPath)' of type '\(t)'")
            let fm = FileManager.default
            //let path = Bundle.main.resourcePath!
            //let url = URL(string: destinationPath)
            //let urlString = url.absoluteString

            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: destinationPath, includingPropertiesForKeys: nil)
                print(fileURLs)
                do {
                 // Get the saved data
                    //let loading = try NSString(contentsOfFile: String(contentsOf: fileURLs[0]), encoding: String.Encoding.unicode.rawValue)
                    //print(loading)
                 /*let savedData = try Data(contentsOf: fileURLs[0])
                    print(savedData)
                    print(savedData.count)
                    let bytes: Data = savedData*/
                 // Convert the data back into a string
                    /*if let savedString = String(data: savedData.subdata(in: 0 ..< savedData.count - 1), encoding: String.Encoding.utf8) {
                    print(savedString)
                 }*/
                    /*let newStr1 = String(data: savedData.subdata(in: 0 ..< savedData.count - 1), encoding: .utf8)
                    print(newStr1)*/
                    do{
                        let savedData = try Data(contentsOf: fileURLs[0])
                        let loading =  try JSONDecoder().decode([testtttt].self, from: savedData)
                        print()
                    }catch{
                        print("No save file 1 ")
                    }
                } catch {
                 // Catch any errors
                 print("Unable to read the file")
                }
                // process files
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
            
        }
        catch
        {
            print("Something went wrong")
        }
    }
    
    func post_2(){
        let body = "email=test@gmail.com&password=Test"
        postData(from:"https://lunsenlu.cf/account/login",from:body) { result in switch result {
            case .success(let str):
                print(str)
                print(str.result)
                var result_output = str.result
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
    
    func test(){
        //zipFileWithPassword_2()
        //unzipFileWithPassword_2()
        post_2()
        do{
            let hp_password: [UInt8] = Array(hp_apiKey.utf8)
            let serverKey = "229517c14c124d6abd62b7e44f0df968"
            //let hp_salt: [UInt8] = Array("0123456789abcdefghij0123456789abcdefghij".utf8) //0123456789abcdefghij0123456789abcdefghij f2adef5f631a4b9f8b260d690d839085
            let hp_key = try PKCS5.PBKDF2(
                password: hp_password,
                salt: [UInt8](serverKey.utf8),
                iterations: 1000,
                keyLength: 32, /* AES-256 */
                variant: .sha1
            ).calculate()
            //let hp_key_str = bytesToRadix(hp_key, radix: 36) //
            let hp_key_str = hp_key.toBase64()!
            print("hp_apiKey: ",hp_apiKey)
            print("server key: ",serverKey)
            print(hp_key_str)
            print(type(of: hp_key_str))
            
            var documentsFolder = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
            documentsFolder = documentsFolder.appendingPathComponent("archieve_final333.zip")
            let documentsDirectory_2 = NSHomeDirectory() + "/Documents/archieve_final333/"
            let destinationPath = URL(fileURLWithPath: documentsDirectory_2)
            
            
            
            try Zip.unzipFile(documentsFolder, destination: destinationPath, overwrite: true, password: hp_key_str, progress: { (progress) -> () in
                print(progress)
            })
            print("aaaabbb")
            do{
                let fileList = try FileManager.default.contentsOfDirectory(atPath: documentsDirectory_2)
                for file in fileList{
                    print(file)
                }
                do{
                    let loading = try NSString(contentsOfFile: documentsDirectory_2+fileList[0], encoding: String.Encoding.utf8.rawValue)
                    
                    let json_data: String = loading as String
                    print(json_data)
                    let range = json_data.startIndex..<json_data.index(before: json_data.index(json_data.startIndex, offsetBy: json_data.count-2))
                    print(String(json_data[range]))
                    
                    //let body = ["email": "test@gmail.com","password": "Test","user_id": "A114236551","passport_json": json_data]
                    let body = "email="+"test@gmail.com"+"&password="+"Test"+"&user_id="+"A114236551"+"&passport_json="+json_data
                    postData(from:"https://lunsenlu.cf/health_passport/insert_health_passport_ios",from:body) { result in switch result {
                        case .success(let str):
                            print(str.result)
                            let result_out = str.result
                            if result_out != "sucess"{
                                print("MHB fail")
                            }
                            else{
                                print("MHB success")
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
                    
                }catch{
                    print("No save file")
                }
                
                
            }
            catch{
                print("Cannot list directory")
            }
        }catch{
            print("error rrrr ")
        }
        
        
        
    }
    
    
    var body: some View {
        NavigationView {
            VStack{
                Button(action: {self.starthp()}) {
                    Text("new")
                }
                Button(action: {self.getfile()}) {
                    Text("get")
                }
                Button(action: {self.test()}) {
                    Text("test")
                }
            }
        }
    }
}



/*
struct TestHP_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView{
            TestHP()
        //}
    }
}*/
/*
struct Testaaa: View {
    
    
    var body: some View {
       Text("aaa")
    }
}

struct Testaaa_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Testaaa()
        }
    }
}*/


struct testttstset: Codable {
    let myhealthbank: String
}
