import SwiftUI
import PhotosUI

struct CustomBgPicker: View {
    // This state simulates whether the user has paid for the feature.
    // Set to 'true' to test the photo picker, 'false' to test the paywall path.
    @State private var isFeatureUnlocked = true

    // State for the PhotosPicker view
    @State private var showPhotosPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    // State to hold the image that the user selected for a preview
    @State private var selectedImage: Image?

    var body: some View {
        VStack {
            Button(action: {
                if isFeatureUnlocked {
                    // If unlocked, show the photo picker
                    showPhotosPicker = true
                } else {
                    // If locked, this is where we'll show the paywall later
                    print("Paywall would be shown here.")
                }
            }) {
                HStack(spacing: 8) {
                    if !isFeatureUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("PrimaryGreen"))
                    }
                    Text("Set custom background")
                }
                .font(.custom("HelveticaNeue-Medium", size: 12))
                .foregroundColor(Color("HadithText"))
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
                .background(Color("CustomBgBtn"))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color("UBtn"), lineWidth: 1)
                )            }
            .buttonStyle(.plain)
            .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhotoItem, matching: .images)
            .onChange(of: selectedPhotoItem) { _, newItem in
                Task {
                    // When a new photo is selected, load its data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            // Update our state to show the preview
                            selectedImage = Image(uiImage: uiImage)
                            // Later, we will save this 'data' to the shared container
                        }
                    }
                }
            }
            
            // Show a preview of the selected image if one exists
            if let selectedImage {
                ZStack(alignment: .topTrailing) {
                    selectedImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(14)
                    
                    Button(action: {
                        // Action to remove the selected image
                        self.selectedImage = nil
                        self.selectedPhotoItem = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.6)))
                            .font(.title3)
                    }
                    .padding(4)
                }
                .padding(.top, 10)
            }
        }
    }
}

#Preview {
    CustomBgPicker()
        .padding()
}

