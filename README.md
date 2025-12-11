
````markdown
# Excelsior-Technologies-Community-IOS_ImageGride

A reusable **Instagram-style image grid** for iOS, built with:

- **SwiftUI** (for easy integration)
- **UIKit Compositional Layout** (for advanced grid behaviour under the hood)

This package lets you quickly show a **dynamic, masonry-like image grid** similar to the Instagram Explore/Search page by just passing an array of image names.

---

##  Features

-   Instagram-like grid layout using `UICollectionViewCompositionalLayout`
-   Easy to use from **SwiftUI**
-   Simple API: just pass `[ImageModel]` with image names from your asset catalog
-   Built as a **Swift Package** – add via SPM and reuse across projects

---

##   Requirements

- **iOS** 15.0+
- **Xcode** 15+
- **Swift Package Manager** (built-in to Xcode)

---

##   Installation (Swift Package Manager)

You can install this package either via **Xcode UI** or by editing `Package.swift`.

###   Using Xcode – Add Package Dependency

1. Open your **iOS app project** in Xcode.
2. Go to:  
   **File → Add Package Dependencies…**
3. In the search / URL field, paste this repo URL:

   ```text
   https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_ImageGride
````

4. In **Dependency Rule**:

   * Select **Branch**
   * Enter: `Stages`
5. Click **Add Package**.
6. On the next screen, make sure your **app target** is checked.
7. Finish by clicking **Add Package**.

Xcode will now download and link **ImageGridKit** into your project.

---

###   Using `Package.swift` (for modular projects / frameworks)

If you manage dependencies manually via `Package.swift`, add this to your `dependencies`:

```swift
.dependencies: [
    .package(
        url: "https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_ImageGride",
        branch: "Stages"
    )
]
```

Then add **`ImageGridKit`** to your target’s dependencies:

```swift
.target(
    name: "YourAppTarget",
    dependencies: [
        .product(name: "ImageGridKit", package: "Excelsior-Technologies-Community-IOS_ImageGride")
    ]
)
```

---

##  Setup: Images

The grid shows images from your **asset catalog** using **image names**.

1. Open your app’s **Assets.xcassets**.

2. Add your images (for example):

   * `p1`
   * `p2`
   * `p3`
   * `p4`
   * …

3. Make sure the names in assets **match exactly** the names you pass into `ImageModel(imageName: "…")`.

---

##   Quick Start (SwiftUI)

In your app, create a simple `ContentView` and use the grid.

```swift
import SwiftUI
import ImageGridKit

struct ContentView: View {

    // 1. Create some sample data
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
        // 2. Use the compositional image grid
        CompositionalCollectionView(images: images)
            .edgesIgnoringSafeArea(.all)
    }
}
```

Run the app and you should see a **beautiful Instagram-style grid** of your images.

---

##   Public API Overview

### `ImageModel`

Simple model representing one image in the grid:

```swift
public struct ImageModel: Identifiable, Hashable {
    public let id: UUID
    public let imageName: String

    public init(imageName: String) {
        self.id = UUID()
        self.imageName = imageName
    }
}
```

### `CompositionalCollectionView`

SwiftUI wrapper around a `UICollectionView` with a compositional layout:

```swift
public struct CompositionalCollectionView: UIViewControllerRepresentable {

    public let images: [ImageModel]

    public init(images: [ImageModel]) {
        self.images = images
    }

    // makeUIViewController / updateUIViewController implemented internally
}
```

Just pass an array of `ImageModel` and it will automatically:

* Build a `UICollectionView` with a compositional layout
* Register and configure cells
* Display your images in a repeating Instagram-style pattern

---

##   Under the Hood (for curious devs)

Internally, the grid uses:

* `UICollectionViewCompositionalLayout`

* A custom layout builder:

  ```swift
  public class CompositionalLayoutBuilder {
      public static func createInstagramLayout() -> UICollectionViewLayout { ... }
  }
  ```

* `UICollectionViewDiffableDataSource<Int, ImageModel>`
  to efficiently manage and update the collection view.

You don’t need to touch any of this to use the library, but it’s there if you want to learn or extend it.

---

##   FAQ / Common Issues

### 1. I see empty (white) cells, no images?

* Check that the **asset names** match the `imageName`:

  * If you use `ImageModel(imageName: "p1")`, you must have an image named **exactly** `"p1"` in `Assets.xcassets`.

### 2. Build error: `No such module 'ImageGridKit'`

* Make sure:

  * The SPM package was added correctly in **File → Add Package Dependencies…**
  * Your target has **ImageGridKit** added under
    **Target → General → Frameworks, Libraries, and Embedded Content**.

### 3. Crash due to nil images?

* If `UIImage(named: imageName)` fails, it returns `nil`.
  Double check your asset catalog names.

---

##   Summary

* Add the package from:

  ```text
  https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_ImageGride
  ```

* Import the module:

  ```swift
  import ImageGridKit
  ```

* Pass your image names into `ImageModel` and use:

  ```swift
  CompositionalCollectionView(images: myImages)
  ```

…that’s it. You get a reusable, Instagram-like image grid with almost no setup.

---

##   Author / Community

This package is part of **Excelsior Technologies Community iOS** reusable components.

Feel free to:

* Open issues
* Suggest improvements
* Use it in your own apps and experiments 

```
 