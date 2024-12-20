import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false

    var body: some View {
        Group {
            if userIsLoggedIn {
                ListView() // Muestra la lista de amigos
            } else {
                loginView
            }
        }
        .onAppear {
            // Detecta cambios en el estado de autenticación
            Auth.auth().addStateDidChangeListener { auth, user in
                userIsLoggedIn = (user != nil)
            }
        }
    }

    var loginView: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 60, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom))
                .frame(width: 1800, height: 600)
                .rotationEffect(.degrees(120))
                .offset(y: -400)

            VStack(spacing: 15) {
                Text("MisAmigos")
                    .foregroundColor(.white)
                    .font(.system(size: 42, weight: .semibold, design: .rounded))
                    .offset(y: -180)

                VStack(spacing: 15) {
                    TextField("", text: $email)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: email.isEmpty) {
                            Text("Email Address")
                                .foregroundColor(.white)
                                .bold()
                        }

                    Rectangle()
                        .frame(width: 330, height: 2)
                        .foregroundColor(.white)

                    SecureField("", text: $password)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(.white)
                                .bold()
                        }

                    Rectangle()
                        .frame(width: 330, height: 2)
                        .foregroundColor(.white)
                }
                .frame(width: 330)

                Button {
                    register()
                } label: {
                    Text("Sign up")
                        .bold()
                        .frame(width: 200, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top, 20)

                Button {
                    login()
                } label: {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top, 10)
            }
            .frame(width: 330)
        }
        .ignoresSafeArea()
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print("Login failed: \(error!.localizedDescription)")
            } else {
                userIsLoggedIn = true
            }
        }
    }

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print("Registration failed: \(error!.localizedDescription)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DataManager())
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
