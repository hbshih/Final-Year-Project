//
//  AlbumBrowserViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 29/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class FromLocalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SKPhotoBrowserDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [SKPhotoProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Static setup
        SKPhotoBrowserOptions.displayAction = true
        SKPhotoBrowserOptions.displayStatusbar = true
        // SKPhotoBrowserOptions.backgroundColor = UIColor.white
        
        setupTestData()
        setupCollectionView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - UICollectionViewDataSource
extension FromLocalViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exampleCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell else {
            return UICollectionViewCell()
        }
        var imagest: [UIImage] = []
        var fileName: [String] = []
        let defaults = UserDefaults.standard
        
        let myarray = defaults.object(forKey: "imageFileName") as? [String] ?? [String]()
        
        if myarray.count != 0
        {
            let fileManager = FileManager.default
            var counter = 0
            for imageName in myarray
            {
                fileName.append(imageName)
                print(imageName)
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                if fileManager.fileExists(atPath: imagePath){
                    if let outputImage = UIImage(contentsOfFile: imagePath)
                    {
                        imagest.append(outputImage)
                        counter += 1
                    }
                }else{
                    print("Panic! No Image!")
                }
            }
        }
        cell.exampleImageView.image = imagest[indexPath.row]
        
        /*cell.exampleImageView.image = UIImage(named: "image\((indexPath as NSIndexPath).row % 10).jpg")*/
        //        cell.exampleImageView.contentMode = .ScaleAspectFill
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FromLocalViewController {
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        //        browser.updateCloseButton(UIImage(named: "image1.jpg")!)
        
        present(browser, animated: true, completion: {})
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 5, height: 300)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 5, height: 200)
        }
    }
}

// MARK: - SKPhotoBrowserDelegate

extension FromLocalViewController {
    /*
     func didShowPhotoAtIndex(_ index: Int) {
     collectionView.visibleCells.forEach({$0.isHidden = false})
     collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = true
     }
     
     func willDismissAtPageIndex(_ index: Int) {
     collectionView.visibleCells.forEach({$0.isHidden = false})
     collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = true
     }
     
     func willShowActionSheet(_ photoIndex: Int) {
     // do some handle if you need
     }
     
     func didDismissAtPageIndex(_ index: Int) {
     collectionView.cellForItem(at: IndexPath(item: index, section: 0))?.isHidden = false
     }
     
     func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
     // handle dismissing custom actions
     }
     
     func removePhoto(index: Int, reload: (() -> Void)) {
     reload()
     }
     
     func viewForPhoto(_ browser: SKPhotoBrowser, index: Int) -> UIView? {
     return collectionView.cellForItem(at: IndexPath(item: index, section: 0))
     }*/
}

// MARK: - private

private extension FromLocalViewController {
    
    func setupTestData() {
        images = createLocalPhotos()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLocalPhotos() -> [SKPhotoProtocol]
    {
        var images: [UIImage] = []
        var fileName: [String] = []
        let defaults = UserDefaults.standard
        
        let myarray = defaults.object(forKey: "imageFileName") as? [String] ?? [String]()
        
        if myarray.count != 0
        {
            let fileManager = FileManager.default
            var counter = 0
            for imageName in myarray
            {
                fileName.append(imageName)
                print(imageName)
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                if fileManager.fileExists(atPath: imagePath){
                    if let outputImage = UIImage(contentsOfFile: imagePath)
                    {
                        images.append(outputImage)
                        //
                        counter += 1
                    }
                }else{
                    print("Panic! No Image!")
                }
            }
        }
        return (0..<images.count).map { (i: Int) -> SKPhotoProtocol in
            let photo = SKPhoto.photoWithImage(images[i])
            print("count")
            photo.caption = caption[i%10]
            //            photo.contentMode = .ScaleAspectFill
            return photo
        }
    }
}

class ExampleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var exampleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exampleImageView.image = nil
        layer.cornerRadius = 25.0
        layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        exampleImageView.image = nil
    }
}

var caption = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
               "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
               "It has survived not only five centuries, but also the leap into electronic typesetting",
               "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
               "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
               "It has survived not only five centuries, but also the leap into electronic typesetting",
               "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
               "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
               "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
               "It has survived not only five centuries, but also the leap into electronic typesetting",
               "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
]

