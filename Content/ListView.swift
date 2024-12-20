import SwiftUI
import Firebase
import FirebaseAuth
struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    @State private var showEditPopup = false
    @State private var selectedAmigo: Amigo?
    @State private var showAlert = false
    @State private var logoutAlert = false

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(dataManager.amigos) { amigo in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(amigo.nombre)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                Text("Edad: \(amigo.edad)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Hobby: \(amigo.hobby)")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                Text("Sexo: \(amigo.sexo)")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                            }
                            Spacer()

                            Button(action: {
                                selectedAmigo = amigo
                                showEditPopup = true
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }

                            Button(action: {
                                dataManager.deleteAmigo(amigo: amigo)
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(radius: 5)
                        )
                        .padding(.bottom, 5)
                    }
                }

                Button(action: {
                    showPopup.toggle()
                }) {
                    Text("Add New Friend")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }
                .padding()
            }
            .navigationTitle("Friends 👥")
            .navigationBarItems(
                leading: Button(action: {
                    logoutAlert = true
                }) {
                    Image(systemName: "arrow.backward.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                },
                trailing: Button(action: {
                    showPopup.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            )
            .alert("Are you sure you want to log out?", isPresented: $logoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    logout()
                }
            }
            .alert("Friend Added Successfully!", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            .sheet(isPresented: $showPopup) {
                NewAmigoView()
            }
            .sheet(isPresented: $showEditPopup) {
                if let selectedAmigo = selectedAmigo {
                    EditAmigoView(amigo: selectedAmigo)
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .onReceive(dataManager.$amigoAdded) { success in
            if success {
                showAlert = true
                dataManager.amigoAdded = false
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            // Cambiar la raíz de la aplicación a ContentView
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = UIHostingController(rootView: ContentView().environmentObject(dataManager))
                window.makeKeyAndVisible()
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

}

#Preview {
    ListView()
}
