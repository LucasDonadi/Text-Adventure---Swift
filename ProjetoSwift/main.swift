import Foundation

class Jogo : Codable {
    var cenas: [Cena]
    var cena_atual: Int
}

class Cena : Codable {
    var cena_id: Int
    var cena_nome: String
    var cena_texto: String
    var objetos: [Objeto]
}

class Objeto : Codable {
    var obj_id: Int
    var obj_tipo: String
    var obj_nome: String
    var obj_texto: String
    var obj_positivo: String
    var obj_negativo: String
    var obj_comando: String
    var obj_cena_alvo: Int
    var resolvido: Bool
    var obtido: Bool
}

class Inventario {
  var itens: [Objeto]

  init (itens: [Objeto]) {
    self.itens = itens
  }
}

class MyGame {
  var inventory: Inventario
  init() {
    self.inventory = Inventario(itens: [])
  }

  func newgame() -> Jogo? { 
    if let url = try? Bundle.main.url(forResource: "Resources/newgame", withExtension: "json") {
      if let data = try? Data(contentsOf: url) {
        if let jsonData = try? JSONDecoder().decode(Jogo.self, from: data) {
          return jsonData
        } else {
          return nil
        }
      } else {
        return nil
      }
    } else {
      return nil
    }
  }

  func load() -> Jogo? {
    if let url = try? Bundle.main.url(forResource: "Resources/savedgame", withExtension: "json") {
      if let data = try? Data(contentsOf: url) {
        if let jsonData = try? JSONDecoder().decode(Jogo.self, from: data) {
          self.initInvetory(game: jsonData)
          return jsonData
        } else {
          print("Não há nenhum jogo salvo.\n")
          return nil
        }
      } else {
        return nil
      }
    } else {
      return nil
    }
  }

  func save(game: Jogo) {
    if let url = try? Bundle.main.url(forResource: "Resources/savedgame", withExtension: "json") {
      if let data = try? JSONEncoder().encode(game)
        .write(to: url) {
          print("Jogo Salvo!")
      } else {
        print("Ocorreu um erro. Tente novamente.")
      }
    } else {
      print("Ocorreu um erro. Tente novamente.")
    }
  }
  
  func help(){
    print("Olá você solicitou ajuda, logo a baixo está uma lista de comandos e seu uso:\n")
    print("Comando: HELP")
    print("Descrição: Retorna uma lista contendo os principais comandos\n")
    print("Comando: SAVE")
    print("Descrição: Salva o estado do jogo\n")
    print("Comando: LOAD")
    print("Descrição: Carrega um jogo salvo\n")
    print("Comando: NEWGAME")
    print("Descrição: Cria um novo jogo\n")
    print("Comando: INVENTORY")
    print("Descrição: Lista os objetos contifdos no seu invetário\n")
    print("Comand: CHECK")
    print("Descrição: Retorna a descrição do objeto")
    print("Exemplo: CHECK LANTERNA\n")
    print("Comand: GET")
    print("Descrição: Guarda um ojeto no seu invetário")
    print("Exemplo: GET LANTERNA\n")
    print("Comand: USE")
    print("Descrição: Interage com o objeto da cena")
    print("Exemplos: USE PORTA, USE PEDRA WITH JANELA\n")
    print("Comand: EXIT")
    print("Descrição: Sair do atual jogo\n")
  }

  func initialCommands(){
    print("Digite o comando:")
    print("LOAD para continuar o jogo salvo.")
    print("NEWGAME para começar um novo jogo.")
    print("EXIT para encerrar o programa.\n")
  }

  func initInvetory(game: Jogo) {
    for i in game.cenas {
      for j in i.objetos {
        if j.obj_tipo == "COLLECTABLE" {
          if j.obtido == true {
            self.inventory.itens.append(j)
          }
        }
      }
    }
  }

  func getInventory(){
    if inventory.itens.count > 0 {
      print("Inventário:\n")
      for j in inventory.itens {
        print("Nome: \(j.obj_nome)")
      }
    } else {
      print("Seu inventário está vazio.\n")
    }
  }

  func comand(comand: String, game: inout Jogo){
    var aux = comand.components(separatedBy: " ") 
    if aux[0].lowercased() == "use" {
      if aux.count == 4 {
        if self.hasOnInventory(obj_nome: aux[1]) == true {
          self.useWith(comando: aux, game: &game)
        } else {
          print("Comando Incorreto. Certifique-se que está passando os parametros corretos.\n")
        }
      } else if aux.count == 2 {
        self.use(comando: aux, game: &game)
      } else {
        print("Comando incorreto. Para ver a lista de comandos digite HELP.\n")
      }
    } else if aux[0].lowercased() == "check" {
      self.check(obj_nome: aux[1], game: game)
    } else if aux[0].lowercased() == "get" {
      self.getObject(obj_nome: aux[1], game: &game)
    } else if aux[0].lowercased() == "help" {
      self.help()
    } else if aux[0].lowercased() == "inventory" {
      self.getInventory()
    } else if aux[0].lowercased() == "save" {
      self.save(game: game)
    } else {
      print("Comando incorreto. Para ver a lista de comandos digite HELP.\n")
    }
  }

  func getCurrentScene(game: Jogo) {
    for i in game.cenas {
      if i.cena_id == game.cena_atual {
        print("\nCena: \(i.cena_nome)\n\(i.cena_texto)\n")
      }
    }
  }

  func getObject(obj_nome: String, game: inout Jogo) {
    var erro = true
    for i in game.cenas {
      if i.cena_id == game.cena_atual {
        for j in i.objetos {
          if j.obj_nome == obj_nome {
            erro = false
            if j.obj_tipo == "COLLECTABLE" {
              if j.obtido == true {
                print("Esse objeto já está em seu invetário.")
              } else {
                j.obtido = true
                self.inventory.itens.append(j)
                print("Objeto coletado com sucesso!")
              }
            } else {
              print("Esse tipo de objeto não pode ser carregado em no inventário.")
            }
          }
        }
      }
    }
    if erro == true {
      print("Comando incorreto. Para ver a lista de comandos digite HELP.\n")
    }
  }

  func hasOnInventory(obj_nome: String) -> Bool {
    var isTrue = false
    if self.inventory.itens.count != 0 {
      for i in 0...self.inventory.itens.count-1 {
        if self.inventory.itens[i].obj_nome.lowercased() == obj_nome.lowercased() {
          isTrue = true
        }   
      }
    }
    return isTrue
  }

  func use(comando: [String], game: inout Jogo) {
    var erro = true
    for i in game.cenas {
      if i.cena_id == game.cena_atual {
        for j in i.objetos {
          if j.obj_nome == comando[1] {
            erro = false
            if j.obj_comando == "NENHUM" {
                print(j.obj_negativo)
            } else if comando.joined(separator:" ").lowercased() == j.obj_comando.lowercased() {
              game.cena_atual = j.obj_cena_alvo
              print(j.obj_positivo)
              return;
            } else {
              print(j.obj_negativo)
            }
          }
        }
      }
    } 
    if erro == true {
      print("Comando Incorreto. Certifique-se que está passando os parametros corretos.\n")
    }
  }

  func useWith(comando: [String], game: inout Jogo) {
    var erro = true
    for i in game.cenas {
      if i.cena_id == game.cena_atual {
        for j in i.objetos {
          if j.obj_nome == comando[3] {
            erro = false
            if j.obj_comando == "NENHUM" {
              print(j.obj_negativo)
            } else if comando.joined(separator:" ").lowercased() == j.obj_comando.lowercased() {
              j.resolvido = true
              game.cena_atual = j.obj_cena_alvo
              print(j.obj_positivo)
              return;
            } else {
              print(j.obj_negativo)
            }
          }
        }
      }
    }
    if erro == true {
      print("Comando incorreto. Para ver a lista de comandos digite HELP.\n")
    }
  }

  func check(obj_nome: String, game: Jogo){
    var erro = true
    for i in game.cenas {
      if i.cena_id == game.cena_atual {
        for j in i.objetos {
          if j.obj_nome == obj_nome {
            erro = false
            print("\nNome: \(j.obj_nome)")
            print("Descrição: \(j.obj_texto)")
          }
        }
      }
    }
    if erro == true {
      print("Comando incorreto. Para ver a lista de comandos digite HELP.\n")
    }
  }
}

func main() {
  let myGame = MyGame()
  var i = 1, j = 1;
  while i != 0 {
    myGame.initialCommands()
    print("/>", terminator: " ")
    let comando = readLine()
    if comando!.lowercased() == "newgame" || comando!.lowercased == "load" {
      var game = comando!.lowercased() == "newgame" ? myGame.newgame() : myGame.load()
      j = 1
      if game == nil {
        j = 0
      }
      if game!.cena_atual == -1 {
          j=0
          print("O jogo salvo já foi finalizado, inicie um novo jogo.\n")
      }
      while j != 0 {
        myGame.getCurrentScene(game: game!)
        print("/>", terminator: " ")
        let comand = readLine()
        if comand!.lowercased() == "exit" {
          j = 0
        } else {
          myGame.comand(comand: comand!, game: &game!)
        }
      }
    } else if comando!.lowercased() == "exit" {
      i = 0
    } else {
      print("Comando incorreto.\n")
    }
  }
}


main()