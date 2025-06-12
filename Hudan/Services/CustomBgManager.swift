import SwiftUI
import Combine

// Represents a single custom background image with its data and a unique ID.
struct CustomBgImage: Identifiable, Codable, Equatable {
    let id: UUID
    let data: Data
}

@MainActor
final class CustomBgManager: ObservableObject {
    static let shared = CustomBgManager()
    private let savedImagesKey = "customBackgroundImages"
    private let selectedImageIDKey = "selectedCustomBgID"
    
    @Published private(set) var savedImages: [CustomBgImage] = []
    @Published var selectedImageID: UUID? {
        didSet {
            persistSelectedImageID()
        }
    }

    private init() {
        loadImages()
        loadSelectedImageID()
    }
    
    func saveImage(data: Data) {
        // Create a new image object
        let newImage = CustomBgImage(id: UUID(), data: data)
        savedImages.insert(newImage, at: 0)
        persistSavedImages()
        
        // Automatically select the newly added image
        selectImage(with: newImage.id)
    }
    
    func deleteImage(with id: UUID) {
        savedImages.removeAll { $0.id == id }
        
        // If the deleted image was the selected one, clear the selection
        // or select the first available image.
        if selectedImageID == id {
            selectImage(with: savedImages.first?.id)
        }
        
        persistSavedImages()
    }
    
    func selectImage(with id: UUID?) {
        selectedImageID = id
    }
    
    private func loadImages() {
        guard let data = UserDefaults.standard.data(forKey: savedImagesKey) else { return }
        
        do {
            let images = try JSONDecoder().decode([CustomBgImage].self, from: data)
            self.savedImages = images
        } catch {
            print("Failed to decode custom images: \(error)")
        }
    }
    
    private func persistSavedImages() {
        do {
            let data = try JSONEncoder().encode(savedImages)
            UserDefaults.standard.set(data, forKey: savedImagesKey)
        } catch {
            print("Failed to encode custom images: \(error)")
        }
    }
    
    private func loadSelectedImageID() {
        guard let data = UserDefaults.standard.data(forKey: selectedImageIDKey) else { return }
        self.selectedImageID = try? JSONDecoder().decode(UUID.self, from: data)
    }
    
    private func persistSelectedImageID() {
        do {
            let data = try JSONEncoder().encode(selectedImageID)
            UserDefaults.standard.set(data, forKey: selectedImageIDKey)
        } catch {
            print("Failed to encode selected image ID: \(error)")
        }
    }
}
