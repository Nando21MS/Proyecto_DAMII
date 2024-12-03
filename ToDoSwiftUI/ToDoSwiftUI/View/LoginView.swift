import SwiftUI

struct LoginRegisterView: View {
    @State private var isLoginSelected = true // Estado para controlar si estamos en el formulario de Login o Registro
    @State private var username: String = "" // Nombre de usuario
    @State private var password: String = "" // Contraseña
    @State private var confirmPassword: String = "" // Confirmar contraseña para registro
    @State private var email: String = "" // Email para registro
    @State private var isAuthenticated: Bool = false // Estado de autenticación
    @State private var showAlert: Bool = false // Alerta de error
    @State private var alertMessage: String = "" // Mensaje de alerta
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo blanco
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer() // Empuja todo hacia el centro de la pantalla

                    VStack(spacing: 20) {
                        // Título: Iniciar sesión / Registrarse
                        Text(isLoginSelected ? "Iniciar sesión" : "Registrarse")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.black) // Título en color negro
                        
                        // Caja de texto para el nombre de usuario
                        TextField("Nombre de usuario", text: $username)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.bottom, 10)
                        
                        // Email, solo si estamos en el registro
                        if !isLoginSelected {
                            TextField("Correo electrónico", text: $email)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                                .padding(.horizontal)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding(.bottom, 10)
                        }
                        
                        // Caja de texto para la contraseña
                        SecureField("Contraseña", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        
                        // Confirmar contraseña, solo si estamos en el registro
                        if !isLoginSelected {
                            SecureField("Confirmar contraseña", text: $confirmPassword)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                        }
                        
                        // Botón de acción dependiendo del estado (Login o Register)
                        Button(action: {
                            if isLoginSelected {
                                loginUser()
                            } else {
                                registerUser()
                            }
                        }) {
                            Text(isLoginSelected ? "Iniciar sesión" : "Registrarse")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 12).fill(isLoginSelected ? Color.blue : Color.green))
                                .shadow(radius: 10)
                                .padding(.horizontal)
                                .scaleEffect(1.05)
                                .animation(.spring(), value: isLoginSelected)
                        }
                        
                        // Cambio entre Login y Registro
                        HStack {
                            Text(isLoginSelected ? "¿No tienes cuenta?" : "¿Ya tienes cuenta?")
                                .foregroundColor(.black) // Texto en negro para mayor contraste
                            
                            Button(action: {
                                withAnimation {
                                    isLoginSelected.toggle() // Cambiar entre Login y Registro
                                }
                            }) {
                                Text(isLoginSelected ? "Registrarse" : "Iniciar sesión")
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow) // Color amarillo para el botón
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                    .frame(width: geometry.size.width * 0.85) // Ajustar el ancho del formulario

                    Spacer() // Empuja el contenido hacia el centro de la pantalla
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            
            // Alerta si las credenciales son incorrectas
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Función de inicio de sesión
    private func loginUser() {
        if username.isEmpty || password.isEmpty {
            alertMessage = "Por favor, ingresa tanto el nombre de usuario como la contraseña."
            showAlert = true
        } else if username == "usuario" && password == "contraseña" {
            isAuthenticated = true
            alertMessage = "Bienvenido, \(username)!"
            showAlert = true
        } else {
            alertMessage = "Nombre de usuario o contraseña incorrectos."
            showAlert = true
        }
    }
    
    // Función de registro
    private func registerUser() {
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty || email.isEmpty {
            alertMessage = "Por favor, completa todos los campos."
            showAlert = true
        } else if password != confirmPassword {
            alertMessage = "Las contraseñas no coinciden."
            showAlert = true
        } else {
            alertMessage = "¡Registro exitoso!"
            showAlert = true
        }
    }
}

#Preview {
    LoginRegisterView()
}
