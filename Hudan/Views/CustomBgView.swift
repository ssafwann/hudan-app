import SwiftUI
import PhotosUI

struct CustomBgView: View {
    @Binding var isPresented: Bool
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack(spacing: 25) {
            // Header with Close Button, just like PaywallView
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("UBtnContent"))
                        .clipShape(Circle())
                }
            }.padding(.bottom, -15)

            // Main Content, title is now here
            VStack(spacing: 15) {
                Text("Select Your Background")
                    .font(.custom("HelveticaNeue-Medium", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color("HadithText"))
                
                Text("Tap the area below to select an image from your photo library.")
                    .font(.custom("HelveticaNeue-Light", size: 14))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tracking(0.6)
                    .lineSpacing(1)
            }
            
            // Image Picker Area
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                ZStack {
                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFill()
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6))
                        
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 200)
                .cornerRadius(20)
            }
            .onChange(of: selectedItem) {
                Task {
                    if let selectedItem, let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        if let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }

            // Action Button
            VStack {
                Button(action: saveAndDismiss) {
                    Text("Save Background")
                        .font(.custom("HelveticaNeue-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("SecondaryGreen"))
                        .cornerRadius(30)
                }
                .disabled(selectedImage == nil)
                .opacity(selectedImage == nil ? 0.5 : 1.0)
            }.padding(.top, 10)

        }
        .padding(.horizontal, 25)
        .padding(.bottom, 40)
        .padding(.top, 25)
        .background(Color("AppWhite"))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
    
    private func saveAndDismiss() {
        guard let data = selectedImageData else { return }
        
        // Use the manager to save the image
        CustomBgManager.shared.saveImage(data: data)
        
        // After saving, dismiss the view
        isPresented = false
        
        // We would also need to trigger a widget timeline refresh here
        // WidgetCenter.shared.reloadAllTimelines()
        print("Widget timeline would be reloaded here.")
    }
}

#Preview {
    ZStack {
        Color.gray
        CustomBgView(isPresented: .constant(true))
    }
}
