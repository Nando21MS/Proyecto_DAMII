//
//  RegisterView.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 3/12/24.
//

import SwiftUI


import SwiftUI

struct RegisterView: View {
    @State private var username = ""
    @State private var fullName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var selectedGender: String? = nil
    @State private var month = ""
    @State private var day = ""
    @State private var year = ""
    @State private var agreeToTerms = false
    @StateObject private var viewModel = RegisterViewModel()
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo azul degradado
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.black.opacity(0.8)]),
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Text("Registrate")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 40)

                        // Campos de texto
                        Group {
                            CustomTextField(placeholder: "Nombre completo", text: $fullName, autocapitalization: .words)
                            CustomTextField(placeholder: "E-mail", text: $email, keyboardType: .emailAddress, autocapitalization: .never)
                            CustomTextField(placeholder: "Celular", text: $phoneNumber, keyboardType: .numberPad)
                        }

                        // Selección de género
                        HStack {
                            Text("Gender:")
                                .foregroundColor(.white)
                            Spacer()
                            GenderButton(title: "Male", isSelected: selectedGender == "Male") {
                                selectedGender = "Male"
                            }
                            GenderButton(title: "Female", isSelected: selectedGender == "Female") {
                                selectedGender = "Female"
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)

                        VStack(spacing: 20) {
                            Text("Date of Birth")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            HStack(spacing: 10) {
                                // Mes
                                TextField("MM", text: $month)
                                    .frame(width: 60)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)

                                // Día
                                TextField("DD", text: $day)
                                    .frame(width: 60)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)

                                // Año
                                TextField("YYYY", text: $year)
                                    .frame(width: 80)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                            }
                        }

                        CustomTextField(placeholder: "Nombre Usuario", text: $username)
                        // Contraseña
                        CustomTextField(placeholder: "Password", text: $password, isSecure: true)

                        // Aceptar términos
                        Toggle(isOn: $agreeToTerms) {
                            Text("Agree with Terms & Conditions")
                                .foregroundColor(.white)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .orange))

                        // Botón de registro
                        Button(action: {
                            let dateOfBirth = "\(month)/\(day)/\(year)"
                            guard !fullName.isEmpty, !email.isEmpty, !phoneNumber.isEmpty, !username.isEmpty, !password.isEmpty else {
                                viewModel.errorMessage = "Por favor, completa todos los campos."
                                return
                            }
                            guard agreeToTerms else {
                                viewModel.errorMessage = "Debes aceptar los términos y condiciones."
                                return
                            }

                            viewModel.registerUser(
                                fullName: fullName,
                                email: email,
                                phoneNumber: phoneNumber,
                                username: username,
                                password: password,
                                gender: selectedGender ?? "Not specified",
                                dateOfBirth: dateOfBirth
                            ) { success in
                                if success {
                                    print("Usuario registrado exitosamente")
                                } else {
                                    print("Error: \(viewModel.errorMessage ?? "Error desconocido")")
                                }
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            } else {
                                Text("Create Account")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.top, 20)
                        .disabled(!agreeToTerms || viewModel.isLoading)
                    }
                    .padding()
                }
            }
        }
    }
}

// Campo de texto personalizado
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    var autocapitalization: TextInputAutocapitalization = .never
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
        .foregroundColor(.white)
    }
}

// Botón para seleccionar género
struct GenderButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .background(isSelected ? Color.orange : Color.white.opacity(0.1))
                .foregroundColor(isSelected ? .white : .white)
                .cornerRadius(8)
        }
    }
}

#Preview {
    RegisterView()
}

