import SwiftUI

struct CustomBgRow: View {
    @ObservedObject var customBgManager = CustomBgManager.shared
    var onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // A fixed button to add a new background
            AddBackgroundButton(onAdd: onAdd)
            
            // A scrollable list for the saved images
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
            }
        }
    }
}

private struct AddBackgroundButton: View {
    var onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("CustomBgBtn"))
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("UBtn"), lineWidth: 1)

                
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color("HadithText"))
            }
            .frame(width: 64, height: 64)
        }
        .buttonStyle(.plain)
        // Apply matching padding to ensure vertical alignment with CustomBgItem
        .padding(.top, 8)
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
                    } else {
                        Color.gray
                    }
                }
                .frame(width: 64, height: 64)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("AppLightText"), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            
            if isSelected {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.4))
                    Image("TickIcon")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.white)
                }
                .frame(width: 64, height: 64)
            }
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .offset(x: 6, y: -6)
        }
        .padding(.top, 8)
    }
}

#Preview {
    CustomBgRow(onAdd: {})
}
