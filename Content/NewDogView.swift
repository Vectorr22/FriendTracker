import SwiftUI

struct NewAmigoView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var nombre = ""
    @State private var edad = ""
    @State private var hobby = ""
    @State private var sexo = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Add a New Friend")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            TextField("Enter name", text: $nombre)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Enter age", text: $edad)
                .keyboardType(.numberPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Enter hobby", text: $hobby)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Enter sex", text: $sexo)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                if let edadInt = Int(edad) {
                    dataManager.addAmigo(nombre: nombre, edad: edadInt, hobby: hobby, sexo: sexo)
                    dismiss()
                }
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NewAmigoView()
}
