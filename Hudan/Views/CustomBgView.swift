import SwiftUI
import PhotosUI

struct CustomBgView: View {
    @Binding var isPresented: Bool
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedImage: Image?
    
    var body: some View {
        ZStack {
            // Semi-transparent background, tapping it dismisses the view
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 20) {
                // Header with Title and Close Button
                HStack {
                    Text("Your Custom Background")
                        .font(.custom("HelveticaNeue-Medium", size: 20))
                        .foregroundColor(Color("HadithText"))
                    
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color("UBtnContent"))
                            .clipShape(Circle())
                    }
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
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            if let uiImage = UIImage(data: data) {
                                selectedImage = Image(uiImage: uiImage)
                            }
                        }
                    }
                }
                
                Text("Tap the area above to select an image from your photo library. This will be your new widget background.")
                    .font(.custom("HelveticaNeue-Light", size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .tracking(0.6)
                    .lineSpacing(1)
                
                // Action Button
                Button(action: saveAndDismiss) {
                    Text("Done")
                        .font(.custom("HelveticaNeue-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("SecondaryGreen"))
                        .cornerRadius(30)
                }
                .disabled(selectedImage == nil)
                .opacity(selectedImage == nil ? 0.5 : 1.0)
                .padding(.top, 10)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 40)
            .padding(.top, 25)
            .background(Color("White"))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal, 20)
        }
    }
    
    private func saveAndDismiss() {
        // Here we would save the 'selectedImageData' to our App Group storage
        print("Image data would be saved here.")
        
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
