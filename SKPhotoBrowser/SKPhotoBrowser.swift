//
//  SKPhotoBrowser.swift
//  SKViewExample
//
//  Created by suzuki_keishi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

//@objc public protocol SKPhotoBrowserDelegate {
//    
//    /**
//     Tells the delegate that the browser started displaying a new photo
//     
//     - Parameter index: the index of the new photo
//     */
//    optional func didShowPhotoAtIndex(index: Int)
//    
//    /**
//     Tells the delegate the browser will start to dismiss
//     
//     - Parameter index: the index of the current photo
//     */
//    optional func willDismissAtPageIndex(index: Int)
//    
//    /**
//     Tells the delegate that the browser will start showing the `UIActionSheet`
//     
//     - Parameter photoIndex: the index of the current photo
//     */
//    optional func willShowActionSheet(photoIndex: Int)
//    
//    /**
//     Tells the delegate that the browser has been dismissed
//     
//     - Parameter index: the index of the current photo
//     */
//    optional func didDismissAtPageIndex(index: Int)
//    
//    /**
//     Tells the delegate that the browser did dismiss the UIActionSheet
//     
//     - Parameter buttonIndex: the index of the pressed button
//     - Parameter photoIndex: the index of the current photo
//     */
//    optional func didDismissActionSheetWithButtonIndex(buttonIndex: Int, photoIndex: Int)
//
//    /**
//     Tells the delegate that the browser did scroll to index
//
//     - Parameter index: the index of the photo where the user had scroll
//     */
//    optional func didScrollToIndex(index: Int)
//
//    /**
//     Tells the delegate the user removed a photo, when implementing this call, be sure to call reload to finish the deletion process
//     
//     - Parameter browser: reference to the calling SKPhotoBrowser
//     - Parameter index: the index of the removed photo
//     - Parameter reload: function that needs to be called after finishing syncing up
//     */
//    optional func removePhoto(browser: SKPhotoBrowser, index: Int, reload: (() -> Void))
//    
//    /**
//     Asks the delegate for the view for a certain photo. Needed to detemine the animation when presenting/closing the browser.
//     
//     - Parameter browser: reference to the calling SKPhotoBrowser
//     - Parameter index: the index of the removed photo
//     
//     - Returns: the view to animate to
//     */
//    optional func viewForPhoto(browser: SKPhotoBrowser, index: Int) -> UIView?
//    
//}

public let SKPHOTO_LOADING_DID_END_NOTIFICATION = "photoLoadingDidEndNotification"

// MARK: - SKPhotoBrowser
open class SKPhotoBrowser: UIViewController {
    
    let pageIndexTagOffset: Int = 1000
    
//<<<<<<< HEAD
//    // custom abilities
//    public var displayAction: Bool = true
//    public var shareExtraCaption: String? = nil
//    public var actionButtonTitles: [String]?
//    public var displayToolbar: Bool = true
//    public var displayCounterPageControl: Bool = true
////    public var displayCounterLabel: Bool = true
////    public var displayBackAndForwardButton: Bool = true
//    public var disableVerticalSwipe: Bool = false
//    public var displayDeleteButton = false
//    public var displayCloseButton = true // default is true
//    /// If it is true displayCloseButton will be false
//    public var displayCustomCloseButton = false
//    /// If it is true displayDeleteButton will be false
//    public var displayCustomDeleteButton = false
//    public var bounceAnimation = false
//    public var enableZoomBlackArea = true
//    public var enableSingleTapDismiss = false
//    /// Set nil to force the statusbar to be hidden
//    public var statusBarStyle: UIStatusBarStyle?
//=======
    fileprivate var closeButton: SKCloseButton!
    fileprivate var deleteButton: SKDeleteButton!
    fileprivate var toolbar: SKToolbar!
//>>>>>>> swift3
    
    // actions
    fileprivate var activityViewController: UIActivityViewController!
    open var activityItemProvider: UIActivityItemProvider? = nil
    fileprivate var panGesture: UIPanGestureRecognizer!

    // tool for controls
//<<<<<<< HEAD
//    private var applicationWindow: UIWindow!
//    private var backgroundView: UIView!
//    private var toolBar: UIToolbar!
////    private var toolCounterLabel: UILabel!
//    private var toolCountPageControl: UIPageControl!
//    private var toolCounterButton: UIBarButtonItem!
////    private var toolPreviousButton: UIBarButtonItem!
//    private var toolActionButton: UIBarButtonItem!
////    private var toolNextButton: UIBarButtonItem!
//    private var pagingScrollView: UIScrollView!
//    private var panGesture: UIPanGestureRecognizer!
//    // MARK: close button
//    private var closeButton: UIButton!
//    private var closeButtonShowFrame: CGRect!
//    private var closeButtonHideFrame: CGRect!
//    // MARK: delete button
//    private var deleteButton: UIButton!
//    private var deleteButtonShowFrame: CGRect!
//    private var deleteButtonHideFrame: CGRect!
//    
//    // MARK: - custom buttons
//    // MARK: CustomCloseButton
//    private var customCloseButton: UIButton!
//    public var customCloseButtonShowFrame: CGRect!
//    public var customCloseButtonHideFrame: CGRect!
//    public var customCloseButtonImage: UIImage!
//    public var customCloseButtonEdgeInsets: UIEdgeInsets!
//    
//    // MARK: CustomDeleteButton
//    private var customDeleteButton: UIButton!
//    public var customDeleteButtonShowFrame: CGRect!
//    public var customDeleteButtonHideFrame: CGRect!
//    public var customDeleteButtonImage: UIImage!
//    public var customDeleteButtonEdgeInsets: UIEdgeInsets!
//    
//    // photo's paging
//    private var visiblePages = [SKZoomingScrollView]()//: Set<SKZoomingScrollView> = Set()
//    private var recycledPages = [SKZoomingScrollView]()
//=======
    fileprivate var applicationWindow: UIWindow!
    fileprivate lazy var pagingScrollView: SKPagingScrollView = SKPagingScrollView(frame: self.view.frame, browser: self)
    var backgroundView: UIView!
//>>>>>>> swift3
    
    var initialPageIndex: Int = 0
    var currentPageIndex: Int = 0
    
    // for status check property
    fileprivate var isEndAnimationByToolBar: Bool = true
    fileprivate var isViewActive: Bool = false
    fileprivate var isPerformingLayout: Bool = false
    
    // pangesture property
    fileprivate var firstX: CGFloat = 0.0
    fileprivate var firstY: CGFloat = 0.0
    
    // timer
    fileprivate var controlVisibilityTimer: Timer!
    
    // delegate
    fileprivate let animator = SKAnimator()
    open weak var delegate: SKPhotoBrowserDelegate?
    
    // photos
    var photos: [SKPhotoProtocol] = [SKPhotoProtocol]()
    var numberOfPhotos: Int {
        return photos.count
    }
    
    // statusbar initial state
    private var statusbarHidden: Bool = UIApplication.shared.isStatusBarHidden
    
    // MARK - Initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    public convenience init(photos: [SKPhotoProtocol]) {
        self.init(nibName: nil, bundle: nil)
        let pictures = photos.flatMap { $0 }
        for photo in pictures {
            photo.checkCache()
            self.photos.append(photo)
        }
    }
    
    public convenience init(originImage: UIImage, photos: [SKPhotoProtocol], animatedFromView: UIView) {
        self.init(nibName: nil, bundle: nil)
        animator.senderOriginImage = originImage
        animator.senderViewForAnimation = animatedFromView
        
        let pictures = photos.flatMap { $0 }
        for photo in pictures {
            photo.checkCache()
            self.photos.append(photo)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        guard let window = UIApplication.shared.delegate?.window else {
            return
        }
        applicationWindow = window
        
        modalPresentationCapturesStatusBarAppearance = true
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleSKPhotoLoadingDidEndNotification(_:)), name: NSNotification.Name(rawValue: SKPHOTO_LOADING_DID_END_NOTIFICATION), object: nil)
    }
    
    // MARK: - override
    override open func viewDidLoad() {
        super.viewDidLoad()
        
//<<<<<<< HEAD
//        view.backgroundColor = .blackColor()
//        view.clipsToBounds = true
//        view.opaque = false
//        
//        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
//        backgroundView.backgroundColor = .blackColor()
//        backgroundView.alpha = 0.0
//        applicationWindow.addSubview(backgroundView)
//        
//        // setup paging
//        let pagingScrollViewFrame = frameForPagingScrollView()
//        pagingScrollView = UIScrollView(frame: pagingScrollViewFrame)
//        pagingScrollView.pagingEnabled = true
//        pagingScrollView.delegate = self
//        pagingScrollView.showsHorizontalScrollIndicator = true
//        pagingScrollView.showsVerticalScrollIndicator = true
//        pagingScrollView.backgroundColor = .clearColor()
//        pagingScrollView.contentSize = contentSizeForPagingScrollView()
//        view.addSubview(pagingScrollView)
//        
//        // toolbar
//        toolBar = UIToolbar(frame: frameForToolbarAtOrientation())
//        toolBar.backgroundColor = .clearColor()
//        toolBar.clipsToBounds = true
//        toolBar.translucent = true
//        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
//        view.addSubview(toolBar)
//        
//        if !displayToolbar {
//            toolBar.hidden = true
//        }
//        
//        // arrows:back
////        let previousBtn = UIButton(type: .Custom)
////        let previousImage = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_back_wh", inBundle: bundle, compatibleWithTraitCollection: nil) ?? UIImage()
////        previousBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
////        previousBtn.imageEdgeInsets = UIEdgeInsetsMake(13.25, 17.25, 13.25, 17.25)
////        previousBtn.setImage(previousImage, forState: .Normal)
////        previousBtn.addTarget(self, action: #selector(self.gotoPreviousPage), forControlEvents: .TouchUpInside)
////        previousBtn.contentMode = .Center
////        toolPreviousButton = UIBarButtonItem(customView: previousBtn)
//        
//        // arrows:next
////        let nextBtn = UIButton(type: .Custom)
////        let nextImage = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_forward_wh", inBundle: bundle, compatibleWithTraitCollection: nil) ?? UIImage()
////        nextBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
////        nextBtn.imageEdgeInsets = UIEdgeInsetsMake(13.25, 17.25, 13.25, 17.25)
////        nextBtn.setImage(nextImage, forState: .Normal)
////        nextBtn.addTarget(self, action: #selector(self.gotoNextPage), forControlEvents: .TouchUpInside)
////        nextBtn.contentMode = .Center
////        toolNextButton = UIBarButtonItem(customView: nextBtn)
//        
//        toolCountPageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 95, height: 40))
//        toolCountPageControl.hidesForSinglePage = true
//        toolCountPageControl.numberOfPages = numberOfPhotos
//        toolCountPageControl.addTarget(self, action: #selector(self.pageControlChangeValue(_:)), forControlEvents: .ValueChanged)
//        
////        toolCounterLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 95, height: 40))
////        toolCounterLabel.textAlignment = .Center
////        toolCounterLabel.backgroundColor = .clearColor()
////        toolCounterLabel.font  = UIFont(name: "Helvetica", size: 16.0)
////        toolCounterLabel.textColor = .whiteColor()
////        toolCounterLabel.shadowColor = .darkTextColor()
////        toolCounterLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        
//        
//        toolCounterButton = UIBarButtonItem(customView: toolCountPageControl)
//        
//        // starting setting
//        setCustomSetting()
//        setSettingCloseButton()
//        setSettingDeleteButton()
//        setSettingCustomCloseButton()
//        setSettingCustomDeleteButton()
//        
//        // action button
//        toolActionButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(SKPhotoBrowser.actionButtonPressed))
//        toolActionButton.tintColor = .whiteColor()
//        
//        // gesture
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SKPhotoBrowser.panGestureRecognized(_:)))
//        panGesture.minimumNumberOfTouches = 1
//        panGesture.maximumNumberOfTouches = 1
//        
//        // transition (this must be last call of view did load.)
//        performPresentAnimation()
//=======
        configureAppearance()
        configureCloseButton()
        configureDeleteButton()
        configureToolbar()
        
        animator.willPresent(self)
//>>>>>>> swift3
    }

    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadData()
        
        var i = 0
        for photo: SKPhotoProtocol in photos {
            photo.index = i
            i = i + 1
        }
    }
    
//<<<<<<< HEAD
//    public override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//    
//    override public func viewWillLayoutSubviews() {
//=======
    override open func viewWillLayoutSubviews() {
//>>>>>>> swift3
        super.viewWillLayoutSubviews()
        isPerformingLayout = true
        
        closeButton.updateFrame()
        deleteButton.updateFrame()
        pagingScrollView.updateFrame(view.bounds, currentPageIndex: currentPageIndex)
        
        toolbar.frame = frameForToolbarAtOrientation()
        
        // where did start
        delegate?.didShowPhotoAtIndex?(currentPageIndex)
        
        isPerformingLayout = false
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        isViewActive = true
    }
    
//<<<<<<< HEAD
//    override public func prefersStatusBarHidden() -> Bool {
//        if statusBarStyle == nil {
//            return true
//        }
//        
//        if isDraggingPhoto && !areControlsHidden() {
//            return isStatusBarOriginallyHidden
//        }
//        
//        return areControlsHidden()
//    }
//    
//    override public func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        recycledPages.removeAll()
//    }
//    
//    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return statusBarStyle ?? super.preferredStatusBarStyle()
//    }
//    
//    // MARK: - setting of buttons
//    // This function should be at the beginning of the other functions
//    private func setCustomSetting() {
//        if displayCustomCloseButton == true {
//            displayCloseButton = false
//        }
//        if displayCustomDeleteButton == true {
//            displayDeleteButton = false
//        }
//    }
//    
//    // MARK: - Buttons' setting
//    // MARK: Close button
//    private func setSettingCloseButton() {
//        if displayCloseButton == true {
//            let doneImage = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_close_wh", inBundle: bundle, compatibleWithTraitCollection: nil) ?? UIImage()
//            closeButton = UIButton(type: UIButtonType.Custom)
//            closeButton.setImage(doneImage, forState: UIControlState.Normal)
//            if UI_USER_INTERFACE_IDIOM() == .Phone {
//                closeButton.imageEdgeInsets = UIEdgeInsets(top: 15.25, left: 15.25, bottom: 15.25, right: 15.25)
//            } else {
//                closeButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//            }
//            closeButton.backgroundColor = .clearColor()
//            closeButton.addTarget(self, action: #selector(self.closeButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            closeButtonHideFrame = CGRect(x: 5, y: -20, width: 44, height: 44)
//            closeButtonShowFrame = CGRect(x: 5, y: buttonTopOffset, width: 44, height: 44)
//            view.addSubview(closeButton)
//            closeButton.translatesAutoresizingMaskIntoConstraints = true
//            closeButton.autoresizingMask = [.FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
//        }
//    }
//    
//    // MARK: Delete button
//    
//    private func setSettingDeleteButton() {
//        if displayDeleteButton == true {
//            deleteButton = UIButton(type: .Custom)
//            deleteButtonShowFrame = CGRect(x: view.frame.width - 44, y: buttonTopOffset, width: 44, height: 44)
//            deleteButtonHideFrame = CGRect(x: view.frame.width - 44, y: -20, width: 44, height: 44)
//            let image = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_delete_wh", inBundle: bundle, compatibleWithTraitCollection: nil) ?? UIImage()
//            if UI_USER_INTERFACE_IDIOM() == .Phone {
//                deleteButton.imageEdgeInsets = UIEdgeInsets(top: 15.25, left: 15.25, bottom: 15.25, right: 15.25)
//            } else {
//                deleteButton.imageEdgeInsets = UIEdgeInsets(top: 12.3, left: 12.3, bottom: 12.3, right: 12.3)
//            }
//            deleteButton.setImage(image, forState: .Normal)
//            deleteButton.addTarget(self, action: #selector(self.deleteButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            deleteButton.alpha = 0.0
//            view.addSubview(deleteButton)
//            deleteButton.translatesAutoresizingMaskIntoConstraints = true
//            deleteButton.autoresizingMask = [.FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
//        }
//    }
//    
//    // MARK: - Custom buttons' setting
//    // MARK: Custom Close Button
//    
//    private func setSettingCustomCloseButton() {
//        if displayCustomCloseButton == true {
//            let closeImage = UIImage(named: "SKPhotoBrowser.bundle/images/btn_common_close_wh", inBundle: bundle, compatibleWithTraitCollection: nil) ?? UIImage()
//            customCloseButton = UIButton(type: .Custom)
//            customCloseButton.addTarget(self, action: #selector(self.closeButtonPressed(_:)), forControlEvents: .TouchUpInside)
//            customCloseButton.backgroundColor = .clearColor()
//            // If another developer has not set their values
//            if customCloseButtonImage != nil {
//                customCloseButton.setImage(customCloseButtonImage, forState: .Normal)
//            } else {
//                customCloseButton.setImage(closeImage, forState: .Normal)
//            }
//            if customCloseButtonShowFrame == nil && customCloseButtonHideFrame == nil {
//                customCloseButtonShowFrame = CGRect(x: 5, y: buttonTopOffset, width: 44, height: 44)
//                customCloseButtonHideFrame = CGRect(x: 5, y: -20, width: 44, height: 44)
//            }
//            if customCloseButtonEdgeInsets != nil {
//                customCloseButton.imageEdgeInsets = customCloseButtonEdgeInsets
//            }
//            
//            customCloseButton.translatesAutoresizingMaskIntoConstraints = true
//            view.addSubview(customCloseButton)
//            customCloseButton.autoresizingMask = [.FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
//        }
//    }
//    
//    // MARK: Custom Delete Button
//    private func setSettingCustomDeleteButton() {
//        if displayCustomDeleteButton == true {
//            customDeleteButton = UIButton(type: .Custom)
//            customDeleteButton.backgroundColor = .clearColor()
//            customDeleteButton.addTarget(self, action: #selector(self.deleteButtonPressed(_:)), forControlEvents: .TouchUpInside)
//            // If another developer has not set their values
//            if customDeleteButtonShowFrame == nil && customDeleteButtonHideFrame == nil {
//                customDeleteButtonShowFrame = CGRect(x: view.frame.width - 44, y: buttonTopOffset, width: 44, height: 44)
//                customDeleteButtonHideFrame = CGRect(x: view.frame.width - 44, y: -20, width: 44, height: 44)
//            }
//            if let _customDeleteButtonImage = customDeleteButtonImage {
//                customDeleteButton.setImage(_customDeleteButtonImage, forState: .Normal)
//            }
//            if let _customDeleteButtonEdgeInsets = customDeleteButtonEdgeInsets {
//                customDeleteButton.imageEdgeInsets = _customDeleteButtonEdgeInsets
//            }
//            view.addSubview(customDeleteButton)
//            customDeleteButton.translatesAutoresizingMaskIntoConstraints = true
//            customDeleteButton.autoresizingMask = [.FlexibleBottomMargin, .FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
//        }
//    }
//    
//    // MARK: - notification
//    public func handleSKPhotoLoadingDidEndNotification(notification: NSNotification) {
//=======
    // MARK: - Notification
    open func handleSKPhotoLoadingDidEndNotification(_ notification: Notification) {
//>>>>>>> swift3
        guard let photo = notification.object as? SKPhotoProtocol else {
            return
        }
        
        DispatchQueue.main.async(execute: {
            guard let page = self.pagingScrollView.pageDisplayingAtPhoto(photo), let photo = page.photo else {
                return
            }
            
            if photo.underlyingImage != nil {
                page.displayImage(complete: true)
                self.loadAdjacentPhotosIfNecessary(photo)
            } else {
                page.displayImageFailure()
            }
        })
    }
    
    open func loadAdjacentPhotosIfNecessary(_ photo: SKPhotoProtocol) {
        pagingScrollView.loadAdjacentPhotosIfNecessary(photo, currentPageIndex: currentPageIndex)
    }
    
    // MARK: - initialize / setup
    open func reloadData() {
        performLayout()
        view.setNeedsLayout()
    }
    
    open func performLayout() {
        isPerformingLayout = true
        
//<<<<<<< HEAD
//        // for tool bar
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
//        var items = [UIBarButtonItem]()
//        items.append(flexSpace)
//        
////        if numberOfPhotos > 1 && displayBackAndForwardButton {
////            items.append(toolPreviousButton)
////        }
//        
//        if displayCounterPageControl {
//            items.append(flexSpace)
//            items.append(toolCounterButton)
//            items.append(flexSpace)
//        } else {
//            items.append(flexSpace)
//        }
//        
////        if numberOfPhotos > 1 && displayBackAndForwardButton {
////            items.append(toolNextButton)
////        }
//        
//        items.append(flexSpace)
//        if displayAction {
//            items.append(toolActionButton)
//        }
//        
//        toolBar.setItems(items, animated: false)
//        updateToolbar()
//=======
        toolbar.updateToolbar(currentPageIndex)
//>>>>>>> swift3
        
        // reset local cache
        pagingScrollView.reload()
        
        // reframe
        pagingScrollView.updateContentOffset(currentPageIndex)
        pagingScrollView.tilePages()
        
        delegate?.didShowPhotoAtIndex?(currentPageIndex)
        
        isPerformingLayout = false
    }
    
    open func prepareForClosePhotoBrowser() {
        cancelControlHiding()
        applicationWindow.removeGestureRecognizer(panGesture)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    open func dismissPhotoBrowser(animated: Bool, completion: ((Void) -> Void)? = nil) {
        prepareForClosePhotoBrowser()

        if !animated {
            modalTransitionStyle = .crossDissolve
        }
        
        dismiss(animated: !animated) {
            completion?()
            self.delegate?.didDismissAtPageIndex?(self.currentPageIndex)
        }
    }

    open func determineAndClose() {
        delegate?.willDismissAtPageIndex?(currentPageIndex)
        animator.willDismiss(self)
    }
}

// MARK: - Public Function For Customizing Buttons

public extension SKPhotoBrowser {
  func updateCloseButton(_ image: UIImage, size: CGSize? = nil) {
        if closeButton == nil {
            configureCloseButton()
        }
        closeButton.setImage(image, for: UIControlState())
    
        if let size = size {
            closeButton.setFrameSize(size)
        }
    }
//<<<<<<< HEAD
//    
//    // MARK: - Toolbar
//    public func updateToolbar() {
//        toolCountPageControl.currentPage = currentPageIndex
////        if numberOfPhotos > 1 {
////            toolCounterLabel.text = "\(currentPageIndex + 1) / \(numberOfPhotos)"
////        } else {
////            toolCounterLabel.text = nil
////        }
//        
////        toolPreviousButton.enabled = (currentPageIndex > 0)
////        toolNextButton.enabled = (currentPageIndex < numberOfPhotos - 1)
//    }
//=======
  
  func updateDeleteButton(_ image: UIImage, size: CGSize? = nil) {
        if deleteButton == nil {
            configureDeleteButton()
        }
        deleteButton.setImage(image, for: UIControlState())
//>>>>>>> swift3
    
        if let size = size {
            deleteButton.setFrameSize(size)
        }
    }
}

//<<<<<<< HEAD
//            resizableImageView = UIImageView(image: imageFromView)
//            resizableImageView.frame = senderViewOriginalFrame
//            resizableImageView.clipsToBounds = true
//            resizableImageView.contentMode = .ScaleAspectFill
//            applicationWindow.addSubview(resizableImageView)
//            
//            if screenRatio < imageRatio {
//                let width = applicationWindow.frame.width
//                let height = width / imageRatio
//                let yOffset = (applicationWindow.frame.height - height) / 2
//                finalImageViewFrame = CGRect(x: 0, y: yOffset, width: width, height: height)
//            } else {
//                let height = applicationWindow.frame.height
//                let width = height * imageRatio
//                let xOffset = (applicationWindow.frame.width - width) / 2
//                finalImageViewFrame = CGRect(x: xOffset, y: 0, width: width, height: height)
//            }
//            
//            if sender.layer.cornerRadius != 0 {
//                let duration = (animationDuration * Double(animationDamping))
//                self.resizableImageView.layer.masksToBounds = true
//                self.resizableImageView.addCornerRadiusAnimation(sender.layer.cornerRadius, to: 0, duration: duration)
//            }
//            
//            UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping:animationDamping, initialSpringVelocity:0, options:.CurveEaseInOut, animations: { () -> Void in
//                
//                    self.backgroundView.alpha = 1.0
//                    self.resizableImageView.frame = finalImageViewFrame
//                
//                    if self.displayCloseButton {
//                        self.closeButton.alpha = 1.0
//                        self.closeButton.frame = self.closeButtonShowFrame
//                    }
//                    if self.displayDeleteButton {
//                        self.deleteButton.alpha = 1.0
//                        self.deleteButton.frame = self.deleteButtonShowFrame
//                    }
//                    if self.displayCustomCloseButton {
//                        self.customCloseButton.alpha = 1.0
//                        self.customCloseButton.frame = self.customCloseButtonShowFrame
//                    }
//                    if self.displayCustomDeleteButton {
//                        self.customDeleteButton.alpha = 1.0
//                        self.customDeleteButton.frame = self.customDeleteButtonShowFrame
//                    }
//                },
//                completion: { (Bool) -> Void in
//                    self.view.hidden = false
//                    self.backgroundView.hidden = true
//                    self.pagingScrollView.alpha = 1.0
//                    self.resizableImageView.alpha = 0.0
//            })
//        } else {
//            UIView.animateWithDuration(animationDuration, delay:0, usingSpringWithDamping:animationDamping, initialSpringVelocity:0, options:.CurveEaseInOut, animations: { () -> Void in
//                    self.backgroundView.alpha = 1.0
//                    if self.displayCloseButton {
//                        self.closeButton.alpha = 1.0
//                        self.closeButton.frame = self.closeButtonShowFrame
//                    }
//                    if self.displayDeleteButton {
//                        self.deleteButton.alpha = 1.0
//                        self.deleteButton.frame = self.deleteButtonShowFrame
//                    }
//                    if self.displayCustomCloseButton {
//                        self.customCloseButton.alpha = 1.0
//                        self.customCloseButton.frame = self.customCloseButtonShowFrame
//                    }
//                    if self.displayCustomDeleteButton {
//                        self.customDeleteButton.alpha = 1.0
//                        self.customDeleteButton.frame = self.customDeleteButtonShowFrame
//                    }
//                },
//                completion: { (Bool) -> Void in
//                    self.view.hidden = false
//                    self.pagingScrollView.alpha = 1.0
//                    self.backgroundView.hidden = true
//            })
//        }
//    }
//    
//    public func performCloseAnimationWithScrollView(scrollView: SKZoomingScrollView) {
//        view.hidden = true
//        backgroundView.hidden = false
//        backgroundView.alpha = 1
//        
//        statusBarStyle = isStatusBarOriginallyHidden ? nil : originalStatusBarStyle
//        setNeedsStatusBarAppearanceUpdate()
//        
//        if let sender = senderViewForAnimation {
//            if let senderViewOriginalFrameTemp = sender.superview?.convertRect(sender.frame, toView:nil) {
//                senderViewOriginalFrame = senderViewOriginalFrameTemp
//            } else if let senderViewOriginalFrameTemp = sender.layer.superlayer?.convertRect(sender.frame, toLayer: nil) {
//                senderViewOriginalFrame = senderViewOriginalFrameTemp
//            }
//        }
//        
//        let contentOffset = scrollView.contentOffset
//        let scrollFrame = scrollView.photoImageView.frame
//        let offsetY = scrollView.center.y - (scrollView.bounds.height/2)
//        
//        let frame = CGRect(
//            x: scrollFrame.origin.x - contentOffset.x,
//            y: scrollFrame.origin.y + contentOffset.y + offsetY,
//            width: scrollFrame.width,
//            height: scrollFrame.height)
//        
//        resizableImageView.image = scrollView.photo?.underlyingImage?.rotateImageByOrientation() ?? resizableImageView.image
//        resizableImageView.frame = frame
//        resizableImageView.alpha = 1.0
//        resizableImageView.clipsToBounds = true
//        resizableImageView.contentMode = .ScaleAspectFill
//        applicationWindow.addSubview(resizableImageView)
//        
//        if let view = senderViewForAnimation where view.layer.cornerRadius != 0 {
//            let duration = (animationDuration * Double(animationDamping))
//            self.resizableImageView.layer.masksToBounds = true
//            self.resizableImageView.addCornerRadiusAnimation(0, to: view.layer.cornerRadius, duration: duration)
//        }
//        
//        UIView.animateWithDuration(animationDuration, delay:0, usingSpringWithDamping:animationDamping, initialSpringVelocity:0, options:.CurveEaseInOut, animations: { () -> () in
//                self.backgroundView.alpha = 0.0
//                self.resizableImageView.layer.frame = self.senderViewOriginalFrame
//            },
//            completion: { (Bool) -> () in
//                self.resizableImageView.removeFromSuperview()
//                self.backgroundView.removeFromSuperview()
//                self.dismissPhotoBrowser()
//        })
//    }
//    
//    public func dismissPhotoBrowser() {
//        modalTransitionStyle = .CrossDissolve
//        senderViewForAnimation?.hidden = false
//        prepareForClosePhotoBrowser()
//        dismissViewControllerAnimated(true) {
//            self.delegate?.didDismissAtPageIndex?(self.currentPageIndex)
//        }
//    }
//
//    public func determineAndClose() {
//        delegate?.willDismissAtPageIndex?(currentPageIndex)
//        
//        if let sender = delegate?.viewForPhoto?(self, index: currentPageIndex), image = photoAtIndex(currentPageIndex).underlyingImage {
//            senderViewForAnimation = sender
//            resizableImageView.image = image
//            
//            let scrollView = pageDisplayedAtIndex(currentPageIndex)
//            performCloseAnimationWithScrollView(scrollView)
//            
//        } else {
//            dismissPhotoBrowser()
//        }
//    }
//    
//    //MARK: - image
//    private func getImageFromView(sender: UIView) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(sender.frame.size, true, 0.0)
//        sender.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let result = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return result ?? UIImage()
//    }
//    
//    // MARK: - paging
//    public func initializePageIndex(index: Int) {
//=======
// MARK: - Public Function For Browser Control

public extension SKPhotoBrowser {
    func initializePageIndex(_ index: Int) {
//>>>>>>> swift3
        var i = index
        if index >= numberOfPhotos {
            i = numberOfPhotos - 1
        }
        
        initialPageIndex = i
        currentPageIndex = i
        
        if isViewLoaded {
            jumpToPageAtIndex(index)
            if !isViewActive {
                pagingScrollView.tilePages()
            }
        }
    }
    
    func jumpToPageAtIndex(_ index: Int) {
        if index < numberOfPhotos {
            if !isEndAnimationByToolBar {
                return
            }
            isEndAnimationByToolBar = false
            toolbar.updateToolbar(currentPageIndex)
            
            let pageFrame = frameForPageAtIndex(index)
            pagingScrollView.animate(pageFrame)
        }
        hideControlsAfterDelay()
    }
    
    func photoAtIndex(_ index: Int) -> SKPhotoProtocol {
        return photos[index]
    }
    
//<<<<<<< HEAD
//    public func pageControlChangeValue(sender: UIPageControl) {
////        self.currentPageIndex = sender.currentPage
//        self.jumpToPageAtIndex(sender.currentPage)
//    }
//    
//    public func gotoPreviousPage() {
//=======
    func gotoPreviousPage() {
//>>>>>>> swift3
        jumpToPageAtIndex(currentPageIndex - 1)
    }
    
    func gotoNextPage() {
        jumpToPageAtIndex(currentPageIndex + 1)
    }
    
//<<<<<<< HEAD
//    public func tilePages() {
//        let visibleBounds = pagingScrollView.bounds
//        
//        var firstIndex = Int(floor((visibleBounds.minX + 10 * 2) / visibleBounds.width))
//        var lastIndex  = Int(floor((visibleBounds.maxX - 10 * 2 - 1) / visibleBounds.width))
//        if firstIndex < 0 {
//            firstIndex = 0
//        }
//        if firstIndex > numberOfPhotos - 1 {
//            firstIndex = numberOfPhotos - 1
//        }
//        if lastIndex < 0 {
//            lastIndex = 0
//=======
    func cancelControlHiding() {
        if controlVisibilityTimer != nil {
            controlVisibilityTimer.invalidate()
            controlVisibilityTimer = nil
//>>>>>>> swift3
        }
    }
    
    func hideControlsAfterDelay() {
        // reset
        cancelControlHiding()
        // start
        controlVisibilityTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(SKPhotoBrowser.hideControls(_:)), userInfo: nil, repeats: false)
    }
    
    func hideControls() {
        setControlsHidden(true, animated: true, permanent: false)
    }
    
    func hideControls(_ timer: Timer) {
        hideControls()
    }
    
    func toggleControls() {
        setControlsHidden(!areControlsHidden(), animated: true, permanent: false)
    }
    
    func areControlsHidden() -> Bool {
        return toolbar.alpha == 0.0
    }
    
    func popupShare(includeCaption: Bool = true) {
        let photo = photos[currentPageIndex]
        guard let underlyingImage = photo.underlyingImage else {
            return
        }
        
        var activityItems: [AnyObject] = [underlyingImage]
        if photo.caption != nil && includeCaption {
            if let shareExtraCaption = SKPhotoBrowserOptions.shareExtraCaption {
                let caption = photo.caption + shareExtraCaption
                activityItems.append(caption as AnyObject)
            } else {
                activityItems.append(photo.caption as AnyObject)
            }
        }
        
        if let activityItemProvider = activityItemProvider {
            activityItems.append(activityItemProvider)
        }
        
        activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            self.hideControlsAfterDelay()
            self.activityViewController = nil
        }
        if UI_USER_INTERFACE_IDIOM() == .phone {
            present(activityViewController, animated: true, completion: nil)
        } else {
            activityViewController.modalPresentationStyle = .popover
            let popover: UIPopoverPresentationController! = activityViewController.popoverPresentationController
            popover.barButtonItem = toolbar.toolActionButton
            present(activityViewController, animated: true, completion: nil)
        }
    }
}


// MARK: - Internal Function

internal extension SKPhotoBrowser {
    func showButtons() {
        if SKPhotoBrowserOptions.displayCloseButton {
            closeButton.alpha = 1
            closeButton.frame = closeButton.showFrame
        }
        if SKPhotoBrowserOptions.displayDeleteButton {
            deleteButton.alpha = 1
            deleteButton.frame = deleteButton.showFrame
        }
    }
    
    func pageDisplayedAtIndex(_ index: Int) -> SKZoomingScrollView? {
        return pagingScrollView.pageDisplayedAtIndex(index)
    }
    
    func getImageFromView(_ sender: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(sender.frame.size, true, 0.0)
        sender.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

// MARK: - Internal Function For Frame Calc

internal extension SKPhotoBrowser {
    func frameForToolbarAtOrientation() -> CGRect {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        var height: CGFloat = navigationController?.navigationBar.frame.size.height ?? 44
        if UIInterfaceOrientationIsLandscape(currentOrientation) {
            height = 32
        }
        return CGRect(x: 0, y: view.bounds.size.height - height, width: view.bounds.size.width, height: height)
    }
    
    func frameForToolbarHideAtOrientation() -> CGRect {
        let currentOrientation = UIApplication.shared.statusBarOrientation
        var height: CGFloat = navigationController?.navigationBar.frame.size.height ?? 44
        if UIInterfaceOrientationIsLandscape(currentOrientation) {
            height = 32
        }
        return CGRect(x: 0, y: view.bounds.size.height + height, width: view.bounds.size.width, height: height)
    }
    
    func frameForPageAtIndex(_ index: Int) -> CGRect {
        let bounds = pagingScrollView.bounds
        var pageFrame = bounds
        pageFrame.size.width -= (2 * 10)
        pageFrame.origin.x = (bounds.size.width * CGFloat(index)) + 10
        return pageFrame
    }
}

// MARK: - Internal Function For Button Pressed, UIGesture Control

internal extension SKPhotoBrowser {
    func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        guard let zoomingScrollView: SKZoomingScrollView = pagingScrollView.pageDisplayedAtIndex(currentPageIndex) else {
            return
        }
        
        backgroundView.isHidden = true
        
        let viewHeight: CGFloat = zoomingScrollView.frame.size.height
        let viewHalfHeight: CGFloat = viewHeight/2
        var translatedPoint: CGPoint = sender.translation(in: self.view)
        
        // gesture began
        if sender.state == .began {
            firstX = zoomingScrollView.center.x
            firstY = zoomingScrollView.center.y
            
            hideControls()
            setNeedsStatusBarAppearanceUpdate()
        }
        
        translatedPoint = CGPoint(x: firstX, y: firstY + translatedPoint.y)
        zoomingScrollView.center = translatedPoint
        
        let minOffset: CGFloat = viewHalfHeight / 4
        let offset: CGFloat = 1 - (zoomingScrollView.center.y > viewHalfHeight
            ? zoomingScrollView.center.y - viewHalfHeight
            : -(zoomingScrollView.center.y - viewHalfHeight)) / viewHalfHeight
        
        view.backgroundColor = UIColor.black.withAlphaComponent(max(0.7, offset))
        
        // gesture end
        if sender.state == .ended {
            
            if zoomingScrollView.center.y > viewHalfHeight + minOffset
                || zoomingScrollView.center.y < viewHalfHeight - minOffset {
                
                backgroundView.backgroundColor = view.backgroundColor
                determineAndClose()
                
            } else {
                // Continue Showing View
                setNeedsStatusBarAppearanceUpdate()
                
                let velocityY: CGFloat = CGFloat(0.35) * sender.velocity(in: self.view).y
                let finalX: CGFloat = firstX
                let finalY: CGFloat = viewHalfHeight
                
                let animationDuration: Double = Double(abs(velocityY) * 0.0002 + 0.2)
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(animationDuration)
                UIView.setAnimationCurve(UIViewAnimationCurve.easeIn)
                view.backgroundColor = UIColor.black
                zoomingScrollView.center = CGPoint(x: finalX, y: finalY)
                UIView.commitAnimations()
            }
        }
    }
    
    func deleteButtonPressed(_ sender: UIButton) {
        delegate?.removePhoto?(self, index: currentPageIndex) { [weak self] in
            self?.deleteImage()
        }
    }
    
    func closeButtonPressed(_ sender: UIButton) {
        determineAndClose()
    }
    
    func actionButtonPressed(ignoreAndShare: Bool) {
        delegate?.willShowActionSheet?(currentPageIndex)
        
        guard numberOfPhotos > 0 else {
            return
        }
        
        if let titles = SKPhotoBrowserOptions.actionButtonTitles {
            let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheetController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            }))
            for idx in titles.indices {
                actionSheetController.addAction(UIAlertAction(title: titles[idx], style: .default, handler: { (action) -> Void in
                    self.delegate?.didDismissActionSheetWithButtonIndex?(idx, photoIndex: self.currentPageIndex)
                }))
            }
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                present(actionSheetController, animated: true, completion: nil)
            } else {
                actionSheetController.modalPresentationStyle = .popover
                
                if let popoverController = actionSheetController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.barButtonItem = toolbar.toolActionButton
                }
                
                present(actionSheetController, animated: true, completion: { () -> Void in
                })
            }
            
        } else {
            popupShare()
        }
    }
}

// MARK: - Private Function 
private extension SKPhotoBrowser {
    func configureAppearance() {
        view.backgroundColor = UIColor.black
        view.clipsToBounds = true
        view.isOpaque = false
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: SKMesurement.screenWidth, height: SKMesurement.screenHeight))
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.0
        applicationWindow.addSubview(backgroundView)
        
        pagingScrollView.delegate = self
        view.addSubview(pagingScrollView)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(SKPhotoBrowser.panGestureRecognized(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        if !SKPhotoBrowserOptions.disableVerticalSwipe {
            view.addGestureRecognizer(panGesture)
        }
    }
    
    func configureCloseButton() {
        closeButton = SKCloseButton(frame: .zero)
        closeButton.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
        closeButton.isHidden = !SKPhotoBrowserOptions.displayCloseButton
        view.addSubview(closeButton)
    }
    
//<<<<<<< HEAD
//    public func hideControls(timer: NSTimer) {
//        setControlsHidden(!enableSingleTapDismiss, animated: true, permanent: false)
//=======
    func configureDeleteButton() {
        deleteButton = SKDeleteButton(frame: .zero)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        deleteButton.isHidden = !SKPhotoBrowserOptions.displayDeleteButton
        view.addSubview(deleteButton)
//>>>>>>> swift3
    }
    
    func configureToolbar() {
        toolbar = SKToolbar(frame: frameForToolbarAtOrientation(), browser: self)
        view.addSubview(toolbar)
    }
    
    func setControlsHidden(_ hidden: Bool, animated: Bool, permanent: Bool) {
        cancelControlHiding()
        
        let captionViews = pagingScrollView.getCaptionViews()
        
        UIView.animate(withDuration: 0.35,
            animations: { () -> Void in
                let alpha: CGFloat = hidden ? 0.0 : 1.0
                self.toolbar.alpha = alpha
                self.toolbar.frame = hidden ? self.frameForToolbarHideAtOrientation() : self.frameForToolbarAtOrientation()
                
                if SKPhotoBrowserOptions.displayCloseButton {
                    self.closeButton.alpha = alpha
                    self.closeButton.frame = hidden ? self.closeButton.hideFrame : self.closeButton.showFrame
                }
                if SKPhotoBrowserOptions.displayDeleteButton {
                    self.deleteButton.alpha = alpha
                    self.deleteButton.frame = hidden ? self.deleteButton.hideFrame : self.deleteButton.showFrame
                }
                captionViews.forEach { $0.alpha = alpha }
            },
            completion: nil)
        
        if !permanent {
            hideControlsAfterDelay()
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func deleteImage() {
        defer {
            reloadData()
        }
        
        if photos.count > 1 {
            pagingScrollView.deleteImage()
            
            photos.remove(at: currentPageIndex)
            if currentPageIndex != 0 {
                gotoPreviousPage()
            }
            toolbar.updateToolbar(currentPageIndex)
            
        } else if photos.count == 1 {
            dismissPhotoBrowser(animated: true)
        }
    }
}

// MARK: -  UIScrollView Delegate

extension SKPhotoBrowser: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isViewActive else {
            return
        }
        guard !isPerformingLayout else {
            return
        }
        
        // tile page
        pagingScrollView.tilePages()
        
        // Calculate current page
        let previousCurrentPage = currentPageIndex
        let visibleBounds = pagingScrollView.bounds
//<<<<<<< HEAD
//        var index = Int(floor(visibleBounds.midX / visibleBounds.width))
//=======
        currentPageIndex = min(max(Int(floor(visibleBounds.midX / visibleBounds.width)), 0), numberOfPhotos - 1)
//>>>>>>> swift3
        
        if currentPageIndex != previousCurrentPage {
            delegate?.didShowPhotoAtIndex?(currentPageIndex)
            toolbar.updateToolbar(currentPageIndex)
        }
    }
    
//<<<<<<< HEAD
//    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        setControlsHidden(!enableSingleTapDismiss, animated: true, permanent: false)
//    }
//    
//    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//=======
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//>>>>>>> swift3
        hideControlsAfterDelay()
        
        let currentIndex = pagingScrollView.contentOffset.x / pagingScrollView.frame.size.width
        delegate?.didScrollToIndex?(Int(currentIndex))
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isEndAnimationByToolBar = true
    }
}
