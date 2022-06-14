//
//  Variables.swift
//  LunSenLu
//
//  Created by BioLab.NTUT on 2020/11/24.
//

import Foundation
import CryptoSwift
import KeychainAccess

struct Responseget: Decodable {
    var result: String
}

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}
struct AccountData: Codable {
    var email: String
    var name: String
    var phone: String
    var result: String
    var user_id: String
}




func testPoseData(from urlString: String,from body:Dictionary<String, String>, completion: @escaping (Result<Responseget, NetworkError>) -> Void) {
    
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }
    
    var request = URLRequest(url: url)
    
    // Create model
   struct UploadData: Codable {
       let email: String
       let password: String
   }
   
   // Add data to the model
   let uploadDataModel = UploadData(email: "test@gmail.com", password: "Test")
   
   // Convert model to JSON data
   guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
       print("Error: Trying to convert model to JSON data")
       return
   }
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
    request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
    request.httpBody = jsonData
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling POST")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Error: Cannot convert data to JSON object")
                return
            }
            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                print("Error: Cannot convert JSON object to Pretty JSON data")
                return
            }
            guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                print("Error: Couldn't print JSON in String")
                return
            }
            
            print(prettyPrintedJson)
        } catch {
            print("Error: Trying to convert JSON data to string")
            return
        }
    }.resume()
    
}

func postData(from urlString: String,from body:String, completion: @escaping (Result<Responseget, NetworkError>) -> Void) {
    // check the URL is OK, otherwise return with a failure
    print(urlString)
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.httpBody = body.data(using: String.Encoding.utf8)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    //DispatchQueue.global().async{
    URLSession.shared.dataTask(with: request) { data, response, error in
        // the task has completed – push our work back to the main thread
        DispatchQueue.main.async {
            if let data = data {
                // success: convert the data to a string and send it back
                //let stringData = String(decoding: data, as: UTF8.self)
                do {
                    let Data = try JSONDecoder().decode(Responseget.self, from: data)
                    //let Data = try JSONSerialization.jsonObject(with: data, options: [])
                    print(Data)
                    print(type(of: Data))
                    completion(.success(Data as! Responseget))
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
    //}
}

struct DoctorAuth: Codable{
    var result: String
    var doctor_auth : [Doctor_auth]
    
    struct Doctor_auth: Codable,Identifiable,Hashable{
        var id: Int
        var department: String
        var hospital: String
        var name: String
    }
}

func postData_get_doctorauthdata(from urlString: String,from body:String, completion: @escaping (Result<DoctorAuth, NetworkError>) -> Void) {
    // check the URL is OK, otherwise return with a failure
    print(urlString)
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.httpBody = body.data(using: String.Encoding.utf8)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    DispatchQueue.global().async{
        URLSession.shared.dataTask(with: request) { data, response, error in
            // the task has completed – push our work back to the main thread
            DispatchQueue.main.async {
                if let data = data {
                    // success: convert the data to a string and send it back
                    //let stringData = String(decoding: data, as: UTF8.self)
                    do {
                        let Data = try JSONDecoder().decode(DoctorAuth.self, from: data)
                        print(Data)
                        print(type(of: Data))
                        completion(.success(Data as! DoctorAuth))
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
}

struct MHB_Data: Codable{
    var result: String
    var mhb_data : [MHB_data]
    
    struct MHB_data: Codable,Identifiable,Hashable{
        var id: Int
        var department: String
        var hospital: String
        var name: String
    }
}

func postData_get_mhbdata(from urlString: String,from body:String, completion: @escaping (Result<MHB_Data, NetworkError>) -> Void) {
    // check the URL is OK, otherwise return with a failure
    print(urlString)
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.httpBody = body.data(using: String.Encoding.utf8)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    DispatchQueue.global().async{
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let Data = try JSONDecoder().decode(MHB_Data.self, from: data)
                        print(Data)
                        print(type(of: Data))
                        completion(.success(Data as! MHB_Data))
                    } catch {
                        print(error)
                    }
                    
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
}

func postData_get_accountdata(from urlString: String,from body:String, completion: @escaping (Result<AccountData, NetworkError>) -> Void) {
    // check the URL is OK, otherwise return with a failure
    print(urlString)
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.httpBody = body.data(using: String.Encoding.utf8)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) { data, response, error in
        // the task has completed – push our work back to the main thread
        DispatchQueue.main.async {
            if let data = data {
                // success: convert the data to a string and send it back
                //let stringData = String(decoding: data, as: UTF8.self)
                do {
                    let Data = try JSONDecoder().decode(AccountData.self, from: data)
                    //let Data = try JSONSerialization.jsonObject(with: data, options: [])
                    print(Data)
                    print(type(of: Data))
                    completion(.success(Data as! AccountData))
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

func postData_get_doctordata(from urlString: String,from body:String, completion: @escaping (Result<Doctor_get_data, NetworkError>) -> Void) {

    print(urlString)
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = body.data(using: String.Encoding.utf8)
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    DispatchQueue.global().async{
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let Data = try JSONDecoder().decode(Doctor_get_data.self, from: data)
                        print(Data)
                        completion(.success(Data as! Doctor_get_data))
                    } catch {
                        print(error)
                    }
                    
                } else if error != nil {
                    completion(.failure(.requestFailed))
                } else {
                    completion(.failure(.unknown))
                }
            }
        }.resume()
    }
}


func postData_2(from request:URLRequest, completion: @escaping (Result<Responseget, NetworkError>) -> Void) {
    // check the URL is OK, otherwise return with a failure

    URLSession.shared.dataTask(with: request) { data, response, error in
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

struct Doctor_get_data: Codable{
    var result: String
    var data : Array<String>
}
import Foundation
func getData_hospitals(from urlString: String, completion: @escaping (Result<Doctor_get_data, NetworkError>) -> Void) {
    print(urlString)
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }
    DispatchQueue.global().async{
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let Data = try JSONDecoder().decode(Doctor_get_data.self, from: data)
                        print(Data)
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
}

func getData(from urlString: String, completion: @escaping (Result<Responseget, NetworkError>) -> Void) {
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


func bytesToRadix<C: RangeReplaceableCollection>(_ bytes: C, radix: Int, isUppercase: Bool = false, isBigEndian: Bool = true) -> String where C.Element == UInt8 {

    // Nothing to process or radix outside of 2...36, return an empty string.
    guard !bytes.isEmpty, 2...36 ~= radix else { return "" }

    let bytes = isBigEndian ? bytes : C(bytes.reversed())

    // For efficiency in calculation, combine 7 bytes into one Int.
    let chunk = 7
    let numvalues = bytes.count
    var ints = Array(repeating: 0, count: (numvalues + chunk - 1)/chunk)
    var rem = numvalues % chunk == 0 ? chunk : numvalues % chunk
    var index = 0
    var accum = 0

    for value in bytes {
        accum = (accum << 8) + Int(value)
        rem -= 1
        if rem == 0 {
            rem = chunk
            ints[index] = accum
            index += 1
            accum = 0
        }
    }

    // Array to hold the result, in reverse order
    var digits = [Int]()

    // Repeatedly divide value by radix, accumulating the remainders.
    // Repeat until original number is zero
    while !ints.isEmpty {
        var carry = 0
        for (index, value) in ints.enumerated() {
            var total = (carry << (8 * chunk)) + value
            carry = total % radix
            total /= radix
            ints[index] = total
        }

        digits.append(carry)

        // Remove leading Ints that have become zero.
        ints = .init(ints.drop { $0 == 0 })
    }

    // Create mapping of digit Int to String
    let letterOffset = Int(UnicodeScalar(isUppercase ? "A" : "a").value - 10)
    let letters = (0 ..< radix).map { d in d < 10 ? "\(d)" : String(UnicodeScalar(letterOffset + d)!) }

    // Reverse the digits array, convert them to String, and join them
    return digits.reversed().map { letters[$0] }.joined()
}
func radixToBytes(_ radixString: String, radix: Int) -> [UInt8] {

    let digitMap: [Character : Int] = [
        "0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5,
        "6": 6, "7": 7, "8": 8, "9": 9, "a": 10, "b": 11,
        "c": 12, "d": 13, "e": 14, "f": 15, "g": 16, "h": 17,
        "i": 18, "j": 19, "k": 20, "l": 21, "m": 22, "n": 23,
        "o": 24, "p": 25, "q": 26, "r": 27, "s": 28, "t": 29,
        "u": 30, "v": 31, "w": 32, "x": 33, "y": 34, "z": 35
    ]

    // Convert input string into array of Int digits
    let digits = Array(radixString).compactMap { digitMap[$0] }

    // Nothing to process? Return an empty array.
    guard digits.count > 0 else { return [] }

    let numdigits = digits.count

    // Array to hold the result, in reverse order
    var bytes = [UInt8]()

    // Convert array of digits into array of Int values each
    // representing 6 digits of the original number.  Six digits
    // was chosen to work on 32-bit and 64-bit systems.
    // Compute length of first number.  It will be less than 6 if
    // there isn't a multiple of 6 digits in the number.
    let chunk = 6
    var ints = Array(repeating: 0, count: (numdigits + chunk - 1)/chunk)
    var rem = numdigits % chunk
    if rem == 0 {
        rem = chunk
    }
    var index = 0
    var accum = 0
    for digit in digits {
        accum = accum * radix + digit
        rem -= 1
        if rem == 0 {
            rem = chunk
            ints[index] = accum
            index += 1
            accum = 0
        }
    }

    // Repeatedly divide value by 256, accumulating the remainders.
    // Repeat until original number is zero
    var mult = 1
    for _ in 1...chunk {
        mult *= radix
    }

    while ints.count > 0 {
        var carry = 0
        for (index, value) in ints.enumerated() {
            var total = carry * mult + value
            carry = total % 256
            total /= 256
            ints[index] = total
        }

        bytes.append(UInt8(truncatingIfNeeded: carry))

        // Remove leading Ints that have become zero
        ints = .init(ints.drop { $0 == 0 })
    }

    // Reverse the array and return it
    return bytes.reversed()
}



let hp_apiKey = "b433ca88bc914bd6ae7ab8afb7fb47c3" //8bf841483aba48129bb6d0d851da9075

let keychain = Keychain(service: "com.lunsenlu.cf")

var aeskey: Array<UInt8> = Array()
var aesiv: Array<UInt8> = Array()


let account_policy_text = "Road Of Life所蒐集的資料可能涉及您的隱私及個人醫療資訊，如經您提供，代表您以書面同意本APP依使用者條款蒐集、處理及利用您的個人資料"

let policy_text = "人生之路(以下簡稱本服務)是由「國立台北科技大學資訊工程系生醫資訊實驗室(以下簡稱本實驗室)所建置。本實驗室係依照以下服務條款之約定(以下稱「本條款」)提供本實驗室人生之路使用者(以下稱「本服務使用者」)使用本實驗室之各項網路資訊服務(以下簡稱「網路資訊服務」)，使用本實驗室之各項網路資訊服務者請務必詳細閱讀本條款相關內容以保障權益，當本服務使用者開始使用本實驗室之各項網路資訊服務時，視為務使用者已確實閱讀丶瞭解並冋意遵守本條款。服務使用者於本條款為任何修改或變更後仍繼續使用本實驗室之各項網路資訊服務時，視為使用者已確實閱讀丶暸瞭解並同意遵守本條款之修改或變更。\n\n一、隱私權保護政策的適用範圍\n\n隱私權保護政策內容，包括本服務如何處理在您使用本實驗室之各項網路資訊服務時收集到的個人識別資料。隱私權保護政策不適用於本服務以外的相關連結，也不適用於非本服務所委託或參與管理的人員。\n\n二丶資料的蒐集與使用方式\n\n為了在本服務上提供您最佳互動性服務。可能會請您提供相關個人的資料，其範圍如下:\n於一般瀏覽時，伺服器會自行記錄相關行徑，包括您使用時間丶瀏覽及點選資料記錄等。做為我們增進本實驗室之各項網路資訊服務的參考依據，此記錄為內部應用，決不對外公布。除非取得您的同意或其他法令之特別規定，本服務絕不會將您的個人資料揭露於第三人或使用於蒐集目的以外之其他用途以下針對收集的資料類型丶收集這些資料的原因以及些資料的用途說明：\n個人資料之類別：\n1.辨識個人者：如您的姓名丶岀生年月日丶行動門號丶電子郵件信箱地址等。\n2.政府資料中之辨識者：如身分證統一編號丶護照號碼等。\n3.個人描迹：如年齡丶性別等。\n4.身體描娏：如血壓值丶血糖值丶血氧濃度丶體溫、身高丶體重等。\n5.個人相關疾病史：如慢性病、感冒等。\n三丶資料之保護\n\n本服務主機均設有防火牆丶防毒系統等相關的各項資訊安全設備及必要的安全防護措施，加以保護服務及您的個人資料。\n\n四丶服務對外的相關連結\n\n本服務提供其他服務之網路連結，您也可經由本服務所提供的連結，點選進入其他服務。但該連結之服務不適用於本服務的隱私權保護政策。您必須參考該連結之服務的隱私權保護政策。\n\n五丶隱私權保護政策之修正\n\n本服務隱私權保護政策將因應需求隨時進行修正，修正後的條款將刊登於服務上。\n\n六丶網路協定安全\n\n本實驗室服務對於所有重要的個人資料均會經過安全加密保護均以國際安全標準的 SSL protocol( Secure Socket Layer通訊協定)加密處理。\n\n七、服務之停止或終止\n\n1. 本服務如發生下列情形之一時，本實驗室有權不經通知逕行停止或中斷提供服務，如因此致用戶或第三人產生困擾丶不便或損害，均不負任何法律責任：\n對電子通信設備進行必要之保養及施工時。\n發生突發性之電子通信設備故障時。\n由於所申請之電子通信服務因仼何原因被停止，無法提供服務時。\n由於天災等不可抗力之因素致無法提供服務時。\n對於本服務相關系統設備進行遷移丶更換或維護時。\n因不可歸責於本分公司事由所造成服務之停止或中斷。\n因不可抗力所造成服務之停止或中斷。\n2.基於網際網路之特性本服務使用者瞭解並同意於使用本分公司之各項網路資訊服務時，應自行採取防護措施,如因本分公司丶協力廠商或相關電信業者網路系統軟硬體設備之故障丶失靈或人為操作上之疏失而致本公司之各項網路資訊服務全部或一部中斷丶暫時無法使用丶遲延丶或造成資料傳輸或儲存上之漏誤丶或遭第三人侵入系統篡改偽造資料時，本實驗室不負仼何賠償責任。\n3.如本服務使用者有違反本條款或相關法令或有其他不當使用之情形發生時，本實驗室得不經催告逕行加以限制或終止其使用本實驗室之各項網路資訊服務之權利。用戶不得因此要求補償或賠償。\n\n八丶擔保責仼免除及責任限制\n\n本實驗室就各項網路資訊服務，不負擔任何明示或默示之擔保責任，亦不保證各項服務之穩定丶安全丶無誤丶及不中斷。本實驗室不保證使用各項網路資訊服務之結果或經由本實驗室服務獲得之資訊符合用戶之期望，亦不保證用戶不會因此接觸到不適當之內容。本服務使用者如無法使用本服務時，其所致之任何直接丶間接丶衍生丶或特別損害等本實驗室均不負任何賠償責任。\n\n九丶權利歸屬及智慧財產權\n\n本實驗室服務上所使用或提供之軟體丶程式及內容(包括但不限於文字丶說明丶圖畫丶圖片丶圖形丶檔案丶頁面設計丶服務規劃與安排等)之專利權丶著作權丶商標權丶營業秘密丶專門技術及其他智慧財產權均屬本實驗室或其他權利人所有，非經權利人事先書面授權同意本服務使用者不得重製丶公開傳播丶公開播送丶公開上映丶改作、編輯丶出租丶散布丶進行還原工程丶解編、反向組譯丶或其他方式之使用，如有違反，除應自行負法律責任外，如因而對本實驗室造成損害或損失，本實驗室有權向該服務使用者請求損害賠償。\n\n十丶準據法及管轄法院\n\n關於本條款之解釋或適用以中華民國之法律為準據法。本服務使用者因使用本服務而與本實驗室所生之爭議，同意依誠信原則解決之，如有訴訟之必要時，同意以台灣台北地方法院為第一審管轄法院。\n\n十一、本條款修訂之權利\n\n本實驗室有權隨時修訂本條款及相關告知事項，並隨時透過本服務公佈公告之，修正之內容自公告時起生效，不另行個別通知，本服務使用者不得因此而要求任何補償或賠償。"
