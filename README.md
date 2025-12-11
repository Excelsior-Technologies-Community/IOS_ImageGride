# IOS_ImageGride

A reusable **Instagram-style image grid package** for iOS. Built with SwiftUI and UIKit Compositional Layout for a beautiful image browsing experience.

##  What's Inside

This package provides an **Instagram-style image grid** with compositional layout for displaying images in a dynamic, masonry-like pattern.

---

## ✨ Features

-   Instagram-like grid layout using `UICollectionViewCompositionalLayout`
 
---
 
## 📥 Installation

### Using Xcode (Recommended)

1. Open your iOS app project in Xcode
2. Go to **File → Add Package Dependencies…**
3. Enter the repository URL:
   ```
   https://github.com/Excelsior-Technologies-Community/IOS_ImageGride
   ```
4. Select **Dependency Rule**:
   - Choose **Branch**
   - Enter: `Stages`
5. Click **Add Package**
6. Select your app target and click **Add Package**

### Using Package.swift

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/Excelsior-Technologies-Community/IOS_ImageGride",
        branch: "Stages"
    )
]
```

Then add to your target:

```swift
.target(
    name: "YourAppTarget",
    dependencies: [
        .product(name: "ImageGridKit", package: "IOS_ImageGride")
    ]
)
```

---

##   Quick Start

### 1. Add Images to Asset Catalog

1. Open **Assets.xcassets** in your project
2. Add your images with names like: `p1`, `p2`, `p3`, etc.
3. Ensure image names match exactly what you'll use in code

### 2. Simple Example

```swift
import SwiftUI
import ImageGridKit
 struct ContentView: View {
    private let images: [ImageModel] = [
        ImageModel(imageName: "p1"),
        ImageModel(imageName: "p2"),
        ImageModel(imageName: "p3"),
        ImageModel(imageName: "p4"),
        ImageModel(imageName: "p5"),
        ImageModel(imageName: "p6"),
        ImageModel(imageName: "p7"),
        ImageModel(imageName: "p8")
    ]
    
    var body: some View {
        CompositionalCollectionView(images: images)
            .edgesIgnoringSafeArea(.all)
    }
}
```
 ---
-> Functionality Explanation 
### CompositionalCollectionView

SwiftUI view that displays images in an Instagram-style grid:

```swift
public struct CompositionalCollectionView: UIViewControllerRepresentable {
    public let images: [ImageModel]
    
    public init(images: [ImageModel])
}
```

**Usage:**
```swift
CompositionalCollectionView(images: myImages)
    .edgesIgnoringSafeArea(.all)
```

---

## 💡 Example Usage

### Basic Image Grid

```swift
struct PhotoGridView: View {
    private let images: [ImageModel] = [
        ImageModel(imageName: "photo1"),
        ImageModel(imageName: "photo2"),
        ImageModel(imageName: "photo3"),
        ImageModel(imageName: "photo4"),
        ImageModel(imageName: "photo5"),
        ImageModel(imageName: "photo6")
    ]
    
    var body: some View {
        NavigationView {
            CompositionalCollectionView(images: images)
                .navigationTitle("Photo Gallery")
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}
```
 
**Problem:** Empty or white cells in the grid

**Solution:**
- Verify asset names match exactly: `ImageModel(imageName: "p1")` requires an asset named **`p1`**
- Check that images are added to **Assets.xcassets**
- Ensure images are included in your target

### Build Error: "No such module 'ImageGridKit'"

**Solution:**
- Verify package is added: **File → Add Package Dependencies**
- Check target has package linked: **Target → General → Frameworks**
- Clean build folder: **Product → Clean Build Folder** (⇧⌘K)
- Restart Xcode

---

## 🎯 Best Practices

1. **Use consistent image naming**
   ```swift
   // ✅ Good - consistent naming pattern
   let images = (1...10).map { ImageModel(imageName: "photo\($0)") }
   
   // ❌ Inconsistent
   ImageModel(imageName: "Photo1")
   ImageModel(imageName: "image_2")
   ```

2. **Add images to correct asset catalog**
   - Place images in **Assets.xcassets** of your main app target
   - Verify images appear in the asset catalog before running

3. **Handle edge cases**
   ```swift
   let images: [ImageModel] = imageNames
       .filter { UIImage(named: $0) != nil }
       .map { ImageModel(imageName: $0) }
   ```

---
 