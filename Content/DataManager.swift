import SwiftUI
import Firebase
import FirebaseFirestore

class DataManager: ObservableObject {
    @Published var amigos: [Amigo] = []
    
    @Published var amigoAdded: Bool = false

    init(){
        fetchAmigos()
    }

    func fetchAmigos() {
        let db = Firestore.firestore()
        let ref = db.collection("Amigos")
        
        ref.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.amigos = snapshot.documents.map { document in
                    let data = document.data()
                    let id = document.documentID
                    let nombre = data["nombre"] as? String ?? ""
                    let edad = data["edad"] as? Int ?? 0
                    let hobby = data["hobby"] as? String ?? ""
                    let sexo = data["sexo"] as? String ?? ""
                    return Amigo(id: id, nombre: nombre, edad: edad, hobby: hobby, sexo: sexo)
                }
            }
        }
    }

    func addAmigo(nombre: String, edad: Int, hobby: String, sexo: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Amigos").document(UUID().uuidString)
        ref.setData(["nombre": nombre, "edad": edad, "hobby": hobby, "sexo": sexo, "id": ref.documentID]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.fetchAmigos()
                DispatchQueue.main.async {
                    self.amigoAdded = true
                }
            }
        }
    }

    func updateAmigo(amigo: Amigo, nuevoNombre: String, nuevaEdad: Int, nuevoHobby: String, nuevoSexo: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Amigos").document(amigo.id)
        ref.updateData(["nombre": nuevoNombre, "edad": nuevaEdad, "hobby": nuevoHobby, "sexo": nuevoSexo]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.fetchAmigos()
            }
        }
    }

    func deleteAmigo(amigo: Amigo) {
        let db = Firestore.firestore()
        let ref = db.collection("Amigos").document(amigo.id)
        ref.delete { error in
            if let error = error {
                print("Error deleting amigo: \(error.localizedDescription)")
            } else {
                self.fetchAmigos()
            }
        }
    }
}
