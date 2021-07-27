import Foundation

//  class Jogo {
//      var cenas = [Cena]
//      var cena_atual: Int
//  }

//  class Cena {
//      var key: Int
//      var titulo: String
//      var descricao: String
//      var objetos = [Objeto]
// }

// class Objeto {
//     var id: Int
//     var tipo: String
//     var nome: String
//     var descricao: String
//     var resultado_positivo: String
//     var resultado_negativo: String
//     var comando_correto: String
//     var cena_alvo: Int
//     var resolvido: Bool
//     var obtido: Bool
// }

// let jogo = Jogo()

// if let file = Bundle.main.url(forResource: "cenarios", withExtension: "json") {
//             let data = try Data(contentsOf: file)
//             let json = try JSONSerialization.jsonObject(with: data, options: [])
//             if let object = json as? [String: Any] {
//                 // json is a dictionary
//                 print(object)
//             } else if let object = json as? [Any] {
//                 // json is an array
//                 print(object)
//             } else {
//                 print("JSON is invalid")
//             }
//         } else {
//             print("no file")
//         }

// if let url = Bundle.main.url(forResource: cenarios, withExtension: "json") {
//         do {
//             let data = try Data(contentsOf: url)
//             let decoder = JSONDecoder()
//             let jsonData = try decoder.decode(Jogo.self, from: data)
//             return jsonData.cena
//         } catch {
//             print("error:\(error)")
//         }
//     }

struct ResponseData: Decodable {
    var person: [Person]
}
struct Person : Decodable {
    var name: String
    var age: String
    var employed: String
}

    // func loadJson(filename fileName: String) -> [Person]? {
    // if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
    //     do {
    //         let data = try Data(contentsOf: url)
    //         let decoder = JSONDecoder()
    //         let jsonData = try decoder.decode(ResponseData.self, from: data)
    //         return jsonData.person
    //     } catch {
    //         print("error:\(error)")
    //     }
    // }
    // else{
    //     print("errou")
    // }
    // return nil
    // }

    // if let path = Bundle.main.path(forResource: "teste", ofType: "json") {
    //     do {
    //         let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    //         let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
    //         if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let person = jsonResult["person"] as? [Any] {
    //                     // do stuff
    //         }
    //     } catch {
    //         // handle error
    //     }
    // }

    let url = Bundle.main.url(forResource: "teste", withExtension: "json")
    print(url)
    // let path = Bundle.main.url(forResource: "teste", ofType: "json")
    // let url = URL(fileURLWithPath: path!)
    // let data = try Data(contentsOf: url)
    // let decoder = JSONDecoder()
    // let jsonData = try decoder.decode(ResponseData.self, from: data)

    // print(jsonData)

// print(data)

