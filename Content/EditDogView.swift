import SwiftUI
import FirebaseFirestore

struct EditAmigoView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State var amigo: Amigo
    @State private var updatedNombre: String
    @State private var updatedEdad: String
    @State private var updatedHobby: String
    @State private var updatedSexo: String
    
    init(amigo: Amigo) {
        self._amigo = State(initialValue: amigo)
        self._updatedNombre = State(initialValue: amigo.nombre)
        self._updatedEdad = State(initialValue: String(amigo.edad))
        self._updatedHobby = State(initialValue: amigo.hobby)
        self._updatedSexo = State(initialValue: amigo.sexo)
    }

    var body: some View {
        VStack(spacing: 20) {
            TextField("Friend's Name", text: $updatedNombre)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Age", text: $updatedEdad)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Hobby", text: $updatedHobby)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Gender", text: $updatedSexo)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button("Save") {
                updateAmigo()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }

    func updateAmigo() {
        if let updatedEdadInt = Int(updatedEdad) {
            dataManager.updateAmigo(amigo: amigo, nuevoNombre: updatedNombre, nuevaEdad: updatedEdadInt, nuevoHobby: updatedHobby, nuevoSexo: updatedSexo)
            presentationMode.wrappedValue.dismiss()
        }
    }
}
