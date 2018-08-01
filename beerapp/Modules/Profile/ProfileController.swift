//
//  ProfileController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/16/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import HexColors
import FirebaseStorage
import Firebase
import SDWebImage

enum ProfileTab: Int {
    case coins = 0
    case rewards = 1
    case promotions = 2
}


class ProfileController: UIViewController,  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var user: User?
    var selectedTab: ProfileTab = .coins
    
    let totalCoins = Int()
    var coins = [CoinsPerCommerce]()
    var selectedCommerce: CoinsPerCommerce?
    
    var rewardsHistory = [RewardHistory]()
    
    var promotionsHistory = [Promotion]()
    var selectedPromotion:Promotion?
    
    var reservations = [Reservations]()
    var selectReservation: Reservations?
    
    var groups = [Groups]()
    var selectedgroup:Groups?
    
    var isLoading = false
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var section0RowsGroups = 0
    var section0RowsCoins = 0
    var section0Rows: (coins: Int, rewards: Int, promotions: Int) = (0, 0, 0)
    var isLoadingData: (coins: Bool, rewards: Bool, promotions: Bool) = (true, true, true)
    
    let storage = Storage.storage().reference()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coinsTabButton: UIButton!
    @IBOutlet weak var booksTabButton: UIButton!
    @IBOutlet weak var groupsTabButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var settingsItemBarButtonRight: UIBarButtonItem!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderImageView: UIImageView!
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Mi Perfil"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self
        
        Core.shared.registerCell(at: tableView, named: "AddCell")
        Core.shared.registerCell(at: tableView, named: "BookCell")
        Core.shared.registerCell(at: tableView, named: "CoinsCell")
        Core.shared.registerCell(at: tableView, named: "GroupCell")
        Core.shared.registerCell(at: tableView, named: "CoinsCell")
        Core.shared.registerCell(at: tableView, named: "ShopCell")
        Core.shared.registerCell(at: tableView, named: "HistoryHeaderCell")
        Core.shared.registerCell(at: tableView, named: "HistoryCell")
        
        self.getCoinsAtCommerce()
        
        activityIndicator.center = genderImageView.center
        genderImageView.addSubview(activityIndicator)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        genderImageView.clipsToBounds = true
        genderImageView.layer.cornerRadius = genderImageView.layer.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getUserInfo()
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ProfileToAddMembersegue" {
            
            let addmembersController = segue.destination as! AddUsersToGroupSController
            addmembersController.groups = selectedgroup
        }
        
        if segue.identifier == "ProfileToBookingsSegue" {
            
            let detailBooking = segue.destination as! ReservationsDetailController
            detailBooking.reservations = selectReservation
        }
        
        if segue.identifier == "ProfileToCommerceDetailSegue" {
            
            let commerceDetail = segue.destination as! ShopDetailController
            commerceDetail.commerceId = selectedCommerce?.id
        }
        
        if segue.identifier == "ProfileToPromotionsPopupSegue"{
            let commerceDetail = segue.destination as! SuccesPromoController
            commerceDetail.promotion = selectedPromotion
        }
    }
    
    // MARK: - Actions
    
    @IBAction func selectTab(_ sender: UIButton) {
        
        selectedTab = ProfileTab(rawValue: sender.tag)!
        
        isLoadingData = (true, true, true)
        section0Rows = (0, 0, 0)
        coins.removeAll()
        rewardsHistory.removeAll()
        promotionsHistory.removeAll()
        
        tableView.reloadData()
        
        switch selectedTab {
        case .coins: setCoinsBackground()
        case .rewards: setRewardsBackground()
        case .promotions: setPromotionsBackground()
        }
    }
    
    @IBAction func goToSettings(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ProfileToSettingsSegue", sender: nil)
    }
    
    @IBAction func goToFavourites(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueProfileToFavourites", sender: nil)
    }
    
    fileprivate func setCoinsBackground() {
        self.getCoinsAtCommerce()
        coinsTabButton.backgroundColor = UIColor("bcc5de")
        booksTabButton.backgroundColor = .white
        groupsTabButton.backgroundColor = .white
    }
    
    fileprivate func setRewardsBackground() {
        self.getRewardsHistory()
        coinsTabButton.backgroundColor = .white
        booksTabButton.backgroundColor = UIColor("bcc5de")
        groupsTabButton.backgroundColor = .white
    }
    
    fileprivate func setPromotionsBackground() {
        self.getPromotionsHistory()
        coinsTabButton.backgroundColor = .white
        booksTabButton.backgroundColor = .white
        self.tableView.backgroundColor = UIColor("F8F8F8")
        groupsTabButton.backgroundColor = UIColor("bcc5de")
    }
    
    fileprivate func gotoCreateGroup() {
        performSegue(withIdentifier: "ProfileToCreateGroupSegue", sender: self)
    }
    
    @objc fileprivate func buttonAction(sender: UIButton!) {
        gotoCreateGroup()
    }
    
    
    fileprivate func getBookings(){
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        
        UserManager().getReservations(uid: uid) { (reservations) in
            
            self.isLoading = false
            
            if let reservationsRes = reservations?.result, reservations?.status == "true" {
                
                self.reservations = reservationsRes
            }
            
            self.tableView.reloadData()
        }
    }
    
    
    fileprivate func getGroups(){
        let getUserID = UserDefaults.standard.string(forKey: "user_id")
        UserManager().getGroups(uid: getUserID!) {
            groups in
            
            self.section0RowsGroups = 1
            self.isLoading = false
            
            if let groupsRes = groups?.result, groups?.status == "true" {
                self.groups = groupsRes
            }
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func getCoinsAtCommerce(){
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        UserManager().getUserCoinsAt(commerce: uid) {
            response in
            
            self.section0Rows.coins = 1
            self.isLoadingData.coins = false
            
            if let coinsRes = response?.result, response?.status == "true" {
                self.coins = coinsRes
            }
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func getRewardsHistory(){
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        UserManager().getRewardsHisory(uid: uid) {
            response in
            
            self.isLoadingData.rewards = false
            
            if let rewards = response?.result, rewards.count > 0 {
                self.section0Rows.rewards = 1
                self.rewardsHistory = rewards
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    fileprivate func getPromotionsHistory(){
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        PromotionManager().history(uid: uid) {
            response in
            
            self.isLoadingData.promotions = false
            
            if let promotions = response?.result, promotions.count > 0 {
                self.section0Rows.promotions = 1
                self.promotionsHistory = promotions
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    
    fileprivate func getUserInfo(){
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        print(uid)
        activityIndicator.startAnimating()
        UserManager().getUserDetail(uid: uid) {
            response in
            
            guard let user = response?.result, response?.status == "true" else {
                print("JO: No user")
                return
            }
            
            
            guard let photo = user.photo, user.photo?.description != "" else{
                print("no photo available yet")
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.genderImageView.image = user.gender == "m" ? #imageLiteral(resourceName: "man_avatar") : #imageLiteral(resourceName: "woman_avatar")
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            
            self.genderImageView.sd_setImage(with: photo, placeholderImage:#imageLiteral(resourceName: "man_avatar"))
            
            if let username = user.username {
                self.usernameLabel.text = "@\(username)"
            }
            
            if let name = user.name {
                self.nameLabel.text = name
            }
            
        }
    }
    
    @objc func showMessage(){
        Core.alert(message: "Estas monedas te sirven para poder canjear premios según el comercio al cual vayas a asistir", title: Titles().info, at: self )
    }
    
    @IBAction func updatePhoto(_ sender: UIButton) {
        
        
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            action in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            genderImageView.image = selectedImage
            changeImage()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeImage(){
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        let imageName = "profile\(uid).png"
        
        let storedImage = storage.child("profile_images").child(imageName)
        if let uploadData = UIImagePNGRepresentation(self.genderImageView.image!)
        {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        //                        Core.alert(message: "No se ha podido completar el cambio de fotografia, por favor intentelo de nuevo", title: Titles().somethingWrong, at: self)
                        return
                    }else{
                        self.activityIndicator.startAnimating()
                        
                        if let photo = metadata?.downloadURL(){
                            let params: [String:Any] = ["photo": photo.description]
                            print(photo.description)
                            
                            UserManager().updatePhoto(params: params, uid: uid, completionHandler: {
                                photo in
                                
                                guard let status = photo?.status, photo?.status == "User photo updated succesfull" else{
                                    print("Error")
                                    
                                    return
                                }
                                
                                self.activityIndicator.stopAnimating()
                                self.getUserInfo()
                                
                            })
                            
                        }
                        
                        
                        
                    }
                })
                
            })
        }
    }
    
    
    
}





// MARK: - Table view data source
extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch selectedTab {
        case .coins: return section == 0 ? section0Rows.coins : coins.count
        case .rewards: return section == 0 ? section0Rows.rewards : rewardsHistory.count
        case .promotions: return section == 0 ? section0Rows.promotions : promotionsHistory.count
        }
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = indexPath.section
        
        switch selectedTab {
        case .coins: return section == 0 ? 100 : 65
        case .rewards, .promotions: return section == 0 ? 50 : 50
        }
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch selectedTab {
        case .coins:
            
            if indexPath.section != 0 {
                selectedCommerce = coins[indexPath.row]
                performSegue(withIdentifier: "ProfileToCommerceDetailSegue", sender: self)
            }
        case.rewards:
            if indexPath.section != 0 {
                
                performSegue(withIdentifier: "ProfileToRewardsPopupSegue", sender: self)
            }
        case.promotions:
            if indexPath.section != 0 {
                selectedPromotion = promotionsHistory[indexPath.row]
                performSegue(withIdentifier: "ProfileToPromotionsPopupSegue", sender: self)
            }
            
        default: break
        }
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        switch selectedTab {
        case .coins: return section == 0 ? coinsCell(at: indexPath) : shopCell(at: indexPath)
        case .rewards: return section == 0 ? historyHeaderCell(at: indexPath, forPromo: false) : historyCell(at: indexPath, forPromo: false)
        case .promotions: return section == 0 ? historyHeaderCell(at: indexPath, forPromo: true) : historyCell(at: indexPath, forPromo: true)
        }
    }
    
    // coinsCell
    fileprivate func coinsCell(at indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinsCell", for: indexPath) as? CoinsCell else { return UITableViewCell() }
        cell.totalCoinsLabel.text = user?.totalcoins
        cell.buttonInfo.addTarget(self, action: #selector(showMessage), for: .touchUpInside)
        // TODO: Setup Cell
        return cell
    }
    
    // shopCell
    fileprivate func shopCell(at indexPath: IndexPath)  -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as? ShopCell else { return UITableViewCell() }
        
        cell.coins = coins[indexPath.row]
        
        return cell
    }
    
    // historyHeaderCell
    fileprivate func historyHeaderCell(at indexPath: IndexPath, forPromo: Bool)  -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderCell", for: indexPath) as? HistoryHeaderCell else { return UITableViewCell() }
        
        cell.forPromo = forPromo
        
        return cell
    }
    
    // historyCell
    fileprivate func historyCell(at indexPath: IndexPath, forPromo: Bool)  -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
        
        let row = indexPath.row
        
        if forPromo { cell.promotion = promotionsHistory[row] }
        else { cell.rewardHistory = rewardsHistory[row] }
        
        return cell
    }
    
    fileprivate func bookCell(at indexPath: IndexPath)  -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookCell else { return UITableViewCell() }
        cell.books = reservations[indexPath.row]
        
        return cell
    }
    
    fileprivate func addCell(at indexPath: IndexPath)  -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as? AddCell else { return UITableViewCell() }
        cell.addgroupButton.addTarget(self, action: #selector(buttonAction),for: .touchUpInside)
        
        
        // TODO: Setup Cell
        return cell
    }
    
    fileprivate func groupCell(at indexPath: IndexPath)  -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupCell else { return UITableViewCell() }
        cell.groups = groups[indexPath.row]
        // TODO: Setup Cell
        return cell
    }
    
}
