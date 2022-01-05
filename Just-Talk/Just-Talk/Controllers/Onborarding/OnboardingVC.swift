//
//  OnboardingVC.swift
//  Just-Talk
//
//  Created by AryafAlaqabali on 01/06/1443 AH.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides : [OnboardingSlide] = []
    
    var currentPage = 0 {
    didSet {
        pageControl.currentPage = currentPage

        if currentPage == slides.count - 1 {
            nextBtn.setTitle("Go started", for: .normal)
        }else {
            nextBtn.setTitle("Next", for: .normal)
        }
    }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
//            OnboardingSlide(title: "5555555", description: "66666666666", image:UIImage(named: "1")!),
            OnboardingSlide(title: "chat", description: "keep in touch with old and and new friend, chitchat with them", image:UIImage(named: "2")!),
            OnboardingSlide(title: "Share", description: "Eshare photos, video, audio and everything you want", image:UIImage(named: "3")!),
            OnboardingSlide(title: "Hello, Friend!", description: "Enter your personal details and start journey with us", image:UIImage(named: "4")!)


        ]
        

        collectionView.delegate = self
        collectionView.dataSource = self


    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
        currentPage += 1
        let indexPath = IndexPath(item: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    }
}


extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}
