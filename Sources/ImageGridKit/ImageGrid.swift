import UIKit
import SwiftUI

struct CompositionalCollectionView: UIViewControllerRepresentable {
    let images: [ImageModel]
    
    // Define the type of data we're feeding to the collection view
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ImageModel>
    
    // Context needed for the coordinator (used for delegation, not strictly needed here)
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // 🌉 Create the UIKit view controller
    func makeUIViewController(context: Context) -> UIViewController {
        let layout = CompositionalLayoutBuilder.createInstagramLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // --- Cell Registration ---
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, ImageModel> { cell, indexPath, model in
            
            // Access the image name from the model
            let imageName = model.imageName
            
            // Create a UIImageView for the image
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            // Add the image view to the cell's content view
            cell.contentView.subviews.forEach { $0.removeFromSuperview() } // Clean up
            cell.contentView.addSubview(imageView)
            
            // Constrain the image view to fill the cell
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            ])
        }
        
        // --- Data Source Setup ---
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
        context.coordinator.dataSource = dataSource
        
        // --- Apply Initial Data Snapshot ---
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(images, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // Wrap the collection view in a parent view controller
        let vc = UIViewController()
        vc.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
        ])
        
        // Set the collection view's background to match the typical view background
        collectionView.backgroundColor = .systemBackground
        
        return vc
    }

    // 🔄 Update the UIKit view controller
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // If your image data changes, you would update the snapshot here.
        // For simplicity, we only set the initial data in makeUIViewController.
    }
    
    // Coordinator (required for a representable)
    class Coordinator: NSObject {
        var parent: CompositionalCollectionView
        var dataSource: DataSource?

        init(parent: CompositionalCollectionView) {
            self.parent = parent
        }
    }
}
import UIKit

class CompositionalLayoutBuilder {
    
    static func createInstagramLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            // Define a margin/spacing between items
            let spacing: CGFloat = 1.0
            
            // --- 1. Small Item Definition (1/3 of the main group width, 1/2 of the main group height) ---
            let smallItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), // Fills its parent group
                heightDimension: .fractionalHeight(0.5) // Half the height of the vertical group
            )
            let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
            smallItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            // --- 2. Vertical Group of Two Small Items (1/3 width, 1.0 height) ---
            let smallVerticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)
            )
            let smallVerticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: smallVerticalGroupSize,
                subitem: smallItem,
                count: 2 // Two items stacked vertically
            )
            
            // --- 3. Two-Column Group (2/3 width, 1.0 height) ---
            // This group holds two vertical groups, resulting in 4 small square cells.
            let twoColumnGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1.0)
            )
            let twoColumnGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: twoColumnGroupSize,
                subitem: smallVerticalGroup,
                count: 2 // Two vertical groups side-by-side
            )
            
            // --- 4. Large Item Definition (1/3 width, 1.0 height) ---
            let largeItemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)
            )
            let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
            largeItem.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            // --- 5. Main Repeating Group (1.0 width, fixed height) ---
            // This defines the repeating pattern: [Large Item (1/3)] + [Two-Column Group (2/3)]
            let mainGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                // Fix the height to maintain square aspect ratio for all small cells
                heightDimension: .fractionalWidth(1/3) // Height is 1/3 of the total width
            )
            let mainGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: mainGroupSize,
                subitems: [largeItem, twoColumnGroup]
            )
            
            // --- 6. Section Definition ---
            let section = NSCollectionLayoutSection(group: mainGroup)
            
            return section
        }
        
        return layout
    }
}
struct ImageModel: Identifiable, Hashable {
    let id = UUID()
    let imageName: String // e.g., "post_1", "post_2", etc.
}
