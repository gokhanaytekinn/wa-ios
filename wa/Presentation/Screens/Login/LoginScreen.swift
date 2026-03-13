import SwiftUI

struct LoginScreen: View {
    @StateObject var viewModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .purple.opacity(0.05)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text(viewModel.isLoginMode ? "Tekrar Hoş Geldiniz" : "Hesap Oluştur")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(viewModel.isLoginMode ? "Devam etmek için giriş yapın" : "Hava durumunu takip etmeye başlayın")
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                // Form
                VStack(spacing: 20) {
                    CustomTextField(
                        label: "Kullanıcı Adı",
                        value: $viewModel.username,
                        leadingIcon: "person.fill"
                    )
                    
                    if !viewModel.isLoginMode {
                        CustomTextField(
                            label: "E-posta",
                            value: $viewModel.email,
                            leadingIcon: "envelope.fill"
                        )
                    }
                    
                    CustomTextField(
                        label: "Şifre",
                        value: $viewModel.password,
                        leadingIcon: "lock.fill",
                        isPassword: true
                    )
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 4)
                    }
                    
                    Button(action: { Task { await viewModel.handleSubmit() } }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.trailing, 8)
                            }
                            Text(viewModel.isLoginMode ? "Giriş Yap" : "Kayıt Ol")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial.opacity(0.8))
                        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
                )
                .padding(.horizontal)
                
                // Footer
                Button(action: { withAnimation { viewModel.isLoginMode.toggle() } }) {
                    HStack {
                        Text(viewModel.isLoginMode ? "Hesabınız yok mu?" : "Zaten hesabınız var mı?")
                            .foregroundColor(.secondary)
                        Text(viewModel.isLoginMode ? "Kayıt Ol" : "Giriş Yap")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
        }
        .onChange(of: viewModel.loginSuccess) { success in
            if success {
                dismiss()
            }
        }
    }
}
