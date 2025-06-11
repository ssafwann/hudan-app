
import SwiftUI

struct CustomBgRow: View {
    @ObservedObject var customBgManager = CustomBgManager.shared
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(customBgManager.savedImages) { image in
                    CustomBgItem(
                        imageData: image.data,
                        isSelected: customBgManager.selectedImageID == image.id,
                        onSelect: {
                            customBgManager.selectImage(with: image.id)
                        },
                        onDelete: {
                            customBgManager.deleteImage(with: image.id)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct CustomBgItem: View {
    let imageData: Data
    let isSelected: Bool
    var onSelect: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: onSelect) {
                ZStack {
                    if let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray)
                            .frame(width: 64, height: 64)
                    }
                    
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("LightText"), lineWidth: 1)
                    
                    if isSelected {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.3))
                        Image("TickIcon")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .offset(x: 8, y: -8)
        }
        .padding(.top, 8)
        .padding(.trailing, 8)
    }
}

#Preview {
    CustomBgRow()
}
