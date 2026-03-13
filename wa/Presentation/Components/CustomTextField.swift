import SwiftUI

struct CustomTextField: View {
    let label: String
    @Binding var value: String
    let leadingIcon: String?
    var isPassword: Bool = false
    var isError: Bool = false
    var errorMessage: String? = nil
    
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                if let icon = leadingIcon {
                    Image(systemName: icon)
                        .foregroundColor(isError ? .red : .primary.opacity(0.6))
                        .frame(width: 24)
                }
                
                ZStack(alignment: .leading) {
                    if value.isEmpty {
                        Text(label)
                            .foregroundColor(.primary.opacity(0.4))
                    }
                    
                    if isPassword && !isPasswordVisible {
                        SecureField("", text: $value)
                    } else {
                        TextField("", text: $value)
                    }
                }
                
                if isPassword {
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.primary.opacity(0.6))
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isError ? Color.red : Color.primary.opacity(0.2), lineWidth: 1)
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary.opacity(0.05))
            )
            
            if isError, let message = errorMessage {
                Text(message)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
    }
}
