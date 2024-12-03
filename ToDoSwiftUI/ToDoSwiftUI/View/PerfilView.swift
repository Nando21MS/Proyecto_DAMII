import SwiftUI
import UIKit

// 1. Crear el ImagePicker como un UIViewControllerRepresentable
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage? // Se vincula la imagen seleccionada
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        // Método que se llama cuando se selecciona una imagen
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Asignar la imagen seleccionada al binding
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.image = selectedImage
            }
            picker.dismiss(animated: true, completion: nil) // Cierra el picker
        }
        
        // Método que se llama si el usuario cancela la selección
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil) // Cierra el picker
        }
    }
    
    // Crear el coordinator que manejará los eventos del picker
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // Crear el UIImagePickerController para seleccionar la imagen
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary // Usa la galería del dispositivo
        picker.allowsEditing = true // Permite la edición de la imagen si es necesario
        picker.delegate = context.coordinator // Asignamos el delegado
        return picker
    }
    
    // Método para actualizar el UIImagePickerController
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Aquí no se necesita hacer nada en este caso
    }
}

// Vista de perfil donde se selecciona la imagen
struct PerfilView: View {
    @State private var name: String
    @State private var surname: String
    @State private var age: Int
    @State private var email: String
    @State private var description: String
    @State private var profileImage: Image? // Imagen de perfil en la interfaz
    @State private var newImage: UIImage? // Nueva imagen seleccionada
    @State private var showingImagePicker = false // Controla si mostrar el ImagePicker
    @State private var isEditing = false // Controla si estamos en modo de edición
    @State private var initialName: String
    @State private var initialSurname: String
    @State private var initialAge: Int
    @State private var initialEmail: String
    @State private var initialDescription: String
    
    // Closure para guardar los datos actualizados
    let onSave: (String, String, Int, String, String, UIImage?) -> Void
    let onRefresh: () -> Void // Closure para refrescar los datos
    
    init(
        name: String,
        surname: String,
        age: Int,
        email: String,
        description: String,
        profileImage: Image? = nil,
        onSave: @escaping (String, String, Int, String, String, UIImage?) -> Void,
        onRefresh: @escaping () -> Void
    ) {
        _name = State(initialValue: name)
        _surname = State(initialValue: surname)
        _age = State(initialValue: age)
        _email = State(initialValue: email)
        _description = State(initialValue: description)
        _profileImage = State(initialValue: profileImage)
        _newImage = State(initialValue: nil) // Imagen nueva seleccionada
        _initialName = State(initialValue: name)
        _initialSurname = State(initialValue: surname)
        _initialAge = State(initialValue: age)
        _initialEmail = State(initialValue: email)
        _initialDescription = State(initialValue: description)
        self.onSave = onSave
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                
                // Foto de perfil
                Button(action: {
                    showingImagePicker.toggle() // Muestra el picker de imágenes
                }) {
                    ZStack {
                        if let newImage = newImage { // Si hay una imagen seleccionada
                            Image(uiImage: newImage) // Mostrar la imagen seleccionada
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        } else if let profileImage = profileImage { // Si ya hay una imagen de perfil
                            profileImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        } else { // Si no hay imagen
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 140, height: 140)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                )
                                .shadow(radius: 10)
                        }
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $newImage) // Usamos ImagePicker para seleccionar imagen
                }
                
                // Datos personales
                VStack(alignment: .leading, spacing: 18) {
                    
                    // Nombre
                    HStack {
                        Text("Nombre:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        if isEditing {
                            TextField("Nuevo nombre", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        } else {
                            Text(name)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Apellido
                    HStack {
                        Text("Apellido:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        if isEditing {
                            TextField("Nuevo apellido", text: $surname)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        } else {
                            Text(surname)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Correo
                    HStack {
                        Text("Correo:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        if isEditing {
                            TextField("Nuevo correo", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        } else {
                            Text(email)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Edad
                    HStack {
                        Text("Edad:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        if isEditing {
                            Stepper("Edad: \(age)", value: $age, in: 0...120)
                                .padding(.horizontal)
                        } else {
                            Text("\(age)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Descripción
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Descripción:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if isEditing {
                            TextEditor(text: $description)
                                .padding(10)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .frame(height: 100)
                                .shadow(radius: 5)
                        } else {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                }
                
                // Botón para refrescar los datos
                if isEditing {
                    Button(action: {
                        // Restaurar los valores iniciales
                        name = initialName
                        surname = initialSurname
                        age = initialAge
                        email = initialEmail
                        description = initialDescription
                    }) {
                        Text("Refrescar datos")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.blue))
                            .padding(.horizontal)
                    }
                }
                
                // Botón para guardar los cambios
                if isEditing {
                    Button(action: {
                        onSave(name, surname, age, email, description, newImage)
                        isEditing = false // Dejar de editar
                        // Actualizamos los valores iniciales luego de guardar
                        initialName = name
                        initialSurname = surname
                        initialAge = age
                        initialEmail = email
                        initialDescription = description
                        // Actualizar la foto de perfil si se seleccionó una nueva imagen
                        if let newImage = newImage {
                            profileImage = Image(uiImage: newImage)
                        }
                    }) {
                        Text("Guardar cambios")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
                            .shadow(radius: 10)
                            .padding(.horizontal)
                    }
                } else {
                    Button(action: {
                        isEditing = true // Activar modo edición
                    }) {
                        Text("Editar perfil")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.green))
                            .shadow(radius: 10)
                            .padding(.horizontal)
                    }
                }
                
                // Botón para cerrar sesión (solo cuando no estamos en modo edición)
                if !isEditing {
                    Button(action: {
                        // Acción para cerrar sesión
                        print("Cerrar sesión")
                    }) {
                        Text("Cerrar sesión")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.red))
                            .shadow(radius: 10)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Mi Perfil")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PerfilView(
            name: "Mark",
            surname: "Zuckerberg",
            age: 30,
            email: "mark_Z_@example.com",
            description: "Desarrollador de software con pasión por Swift.",
            profileImage: nil,
            onSave: { name, surname, age, email, description, newImage in
                // Acción de ejemplo para guardar datos
                print("Datos actualizados: \(name), \(surname), \(age), \(email), \(description)")
            },
            onRefresh: {
                // Acción de ejemplo para refrescar datos
                print("Datos refrescados")
            }
        )
    }
}
