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
            nextBtn.setTitle("Go started".localized, for: .normal)
        }else {
            nextBtn.setTitle("Next".localized, for: .normal)
        }
    }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [

            OnboardingSlide(title: "Chat".localized, description: "keep in touch with old and and new friend, chitchat with them".localized, image:UIImage(named: "Chat")!),
            OnboardingSlide(title: "Share".localized, description: "Eshare photos, video, audio and everything you want".localized, image:UIImage(named: "Share")!),
            OnboardingSlide(title: "Welcome".localized, description: "Enter your personal information and start journey with us".localized, image:UIImage(named: "Welcome")!)

        ]
        

//        collectionView.delegate = self
//        collectionView.dataSource = self


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
