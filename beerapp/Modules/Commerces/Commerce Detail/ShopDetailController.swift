//
//  ShopDetailController.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 2/20/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import HexColors
import TBEmptyDataSet
import Presentr

class ShopDetailController: UITableViewController {
    
    var isLoading = true
    var commerce: Commerce?
    var commerceId: String?
    var showPopup = MakeCheckInController()
    var selectedReward: Reward?
    var promotions: Promotion?
    
    var fromFavouritesDelegate: FavouriteCommercesToDetail?
    
    let alertController = UIAlertController(title: "Elige una opción:", message: nil, preferredStyle: .actionSheet)
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    // MARK: - IBOUTLET
    
    @IBOutlet weak var noPromoslabel: UILabel!
    @IBOutlet weak var promotionsActivity: UIActivityIndicatorView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openHoursLabel: UILabel!
  
    @IBOutlet weak var favouriteButton: LoadingUIButton!
    
    @IBOutlet weak var pointsTitleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    @IBOutlet weak var promotionsCollectionView: UICollectionView!
    
    @IBOutlet weak var placeRateControl: CosmosView!
    @IBOutlet weak var commentTextView: UITextView!
    
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.delegate = self
        
        promotionsCollectionView.delegate = self
        promotionsCollectionView.dataSource = self
        
        commentTextView.delegate = self
        
        App.core.registerHeaderFooter(at: tableView, named: "ProductsHeaderView")
        
        setupActions()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let commerce = commerce, let id = commerce.id {
            
            print("JO: Commerce ID: \(id)")
            setupCommerceData()
            loadCommerceData(id: id, forRewards: true)
            
            
        }
        else if let commerceId = commerceId { loadCommerceData(id: commerceId) }
        
        if let id = self.commerceId{
             self.setFavourite(id: id)
        }
       
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShopDetailToReservationSegue" {
            
            let reservationController = segue.destination as! ReservationTableController
            reservationController.commerce = commerce
        }
        
        if segue.identifier == "CommerceDetailToPromotionDetailSegue"{
            let promotionDetailsController = segue.destination as! PromotionsDetailsController
            promotionDetailsController.promotion = promotions
        }
        
    
    }
    
    let presenter: Presentr = {
        let width = ModalSize.custom(size: 356)
        let height = ModalSize.fluid(percentage: 5)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.roundCorners = true
        customPresenter.backgroundColor = .black
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    
    lazy var coinsiewController: RewardPopup = {
        
        let popupViewController = UIStoryboard(name: "FIndPlaces", bundle: nil).instantiateViewController(withIdentifier: "RewardPopupID") as! RewardPopup
        
        return popupViewController
    }()
    
    func showCoinsPoup() {

        coinsiewController.reward = self.selectedReward
        coinsiewController.modalPresentationStyle = .overCurrentContext
        
        definesPresentationContext = true
        
        customPresentViewController(presenter, viewController: coinsiewController, animated: true, completion: nil)
        
    }
    
    // MARK: - SETUP/LOADER
    
    func setupActions() {

        self.alertController.addAction(UIAlertAction(title: "Abrir en Waze", style: .default, handler: {
            (action) in
            self.openWaze()
        }))
        
        self.alertController.addAction(UIAlertAction(title: "Abrir en Google Maps", style: .default, handler: {
            (action) in
            self.openMaps()
        }))
        
        self.alertController.addAction(self.cancelButton)
        
    }
    
    func openWaze() {
        
        if let lat = commerce?.lat,
            let lon = commerce?.lon,
            let addressUrl = URL(string: "waze://?ll=\(lat),\(lon)&navigate=yes"),
            UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            
            UIApplication.shared.open(addressUrl, options: [:], completionHandler: nil)
        }
        else {
            // Waze is not installed. Launch AppStore to install Waze app
            UIApplication.shared.open(URL(string: "http://itunes.apple.com/us/app/id323229106")!, options: [:], completionHandler: nil)
        }
    }
    
    func openMaps() {
        
        guard let lat = commerce?.lat,
            let lon = commerce?.lon else {
            return
        }
        
        if let addressUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lon)"), UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) && UIApplication.shared.canOpenURL(addressUrl)  {
            
            UIApplication.shared.open(addressUrl, options: [:], completionHandler: nil)
        }
        else if let webUrl = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(lon)") {
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        }
    }
    
    
    
    func loadCommerceData(id: String, forRewards: Bool = false) {
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: getUserInfo: No UID")
            return
        }
        
        let params: Params = ["user": uid]
        
        CommerceManager().commercePromotionsDetail(params: params, id: id) {
            response in
            
            self.isLoading = false
            self.promotionsActivity.stopAnimating()
            
            guard let commerce = response?.result else {
                print("JO: No commerce data available")
                self.tableView.reloadData()
                self.promotionsCollectionView.reloadData()
                
                return
            }
            
            if forRewards {
                self.commerce?.rewards = commerce.rewards
                
            }
            else {
                self.commerce = commerce
                self.setupCommerceData()
                
            }
            
            if self.commerce?.rewards?.count == 0 {
                self.noPromoslabel.isHidden = false
                
            }
            
            
            
            print("JO: Rewards Count: \(self.commerce?.rewards?.count ?? 0)")
            self.tableView.reloadData()
            self.promotionsCollectionView.reloadData()
        }
    }
    

    
    
    lazy var popupViewController: MakeCheckInController = {
        
        let popupViewController = UIStoryboard(name: "CheckIn", bundle: nil).instantiateViewController(withIdentifier: "MakeCheckInControllerID")
        
        return popupViewController as! MakeCheckInController
    }()
    
    
    
    func showmakeCheckInConntroller() {
        let checkinmade = UserDefaults.standard.string(forKey: "checkinmade")
        UserDefaults.standard.set(self.commerceId, forKey: "idcommerce")
        let commerceSaved = UserDefaults.standard.string(forKey: "idcommerce")
        
        
        
        if checkinmade != nil {
            
            
            Core.alert(message: "Ya posees un checkIn en uno de nuestros comercios", title: Titles().somethingWrong, at: self)
            
            
        }else if checkinmade != nil && (commerceSaved! != self.commerceId) {
            
            Core.alert(message: "Debes esperar al menos 15 minutos para hacer check-in en un comercio diferente", title: Titles().somethingWrong, at: self)
            
        }else{
        
        
        presenter.presentationType = .popup
            
        popupViewController.commerce = commerce
        
        let window = UIApplication.shared.keyWindow!
        
        window.addSubview(popupViewController.view)
        customPresentViewController(presenter, viewController: popupViewController, animated: true, completion: nil)
        }
    }
    
    
    
    func setupCommerceData(){
        
        nameLabel.text = commerce?.name
        
        if let logo = commerce?.logo, let logoUrl = URL(string: logo) {
            logoImage.sd_setImage(with: logoUrl, placeholderImage: nil)
        }
        
        if let bg = commerce?.photo, let bgUrl = URL(string: bg) {
            backgroundImage.sd_setImage(with: bgUrl, placeholderImage: nil)
        }
        else { darkTheme() }
        
        addressLabel.text = commerce?.address
        openHoursLabel.text = commerce?.schedule
        pointsLabel.text = commerce?.checkinCoins
        
        tableView.reloadData()
        promotionsCollectionView.reloadData()
    }
    
    func darkTheme() {
        
        let gray = UIColor("5d5d5d")
        
        nameLabel.textColor = gray
        addressLabel.textColor = gray
        openHoursLabel.textColor = gray
        pointsTitleLabel.textColor = UIColor("1c2643")
        pointsLabel.textColor = UIColor("91a4d9")
    }
    
    // MARK: - IBAction
    
    @IBAction func shareLocation(_ sender: UIButton) {
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func setFavourite(id: String){
        
        favouriteButton.showLoading()
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: getUserInfo: No UID")
            return
        }
        
        let params: Params = ["user": uid]
        
        CommerceManager().commercePromotionsDetail(params: params, id: id) {
            favourite in
            
            self.favouriteButton.isSelected = favourite?.result?.isfavorite == "true"
            self.favouriteButton.hideLoading()
        }
    }
    
    
    
    @IBAction func likeCommerce(_ sender: UIButton) {
        
        self.favouriteButton.showLoading()
        
        guard let commerceId = commerce?.id else {
            print("JO: No commerce id")
            return
        }
        
        guard let uid = App.core.currentUser?.id else {
            print("JO: No UID")
            return
        }
        
        let params: Params = ["user": uid, "commerce": commerceId]

        CommerceManager().addToFavourites(params: params) {
            favourite in
            
            sender.isSelected = favourite?.status == "Commerce added to favorites"
            self.fromFavouritesDelegate?.removeFromFavourites()
            self.favouriteButton.hideLoading()
        }
    }
    
    @IBAction func sendCommentRate(_ sender: UIButton) {
        
        if placeRateControl.rating == 0{
            Core.alert(message: "La valoracion no es valida", title: Titles().somethingWrong, at: self)
        }else{
            sender.isEnabled = false
            placeRateControl.isUserInteractionEnabled = false
            
            guard let commerceId = commerce?.id else {
                print("JO: No commerce ID")
                return
            }
            
            guard let uid = App.core.currentUser?.id else {
                print("JO: getUserInfo: No UID")
                return
            }
            
            let params: Params = [
                "user": uid,
                "rating": placeRateControl.rating,
                "comment": commentTextView.text
            ]
            
            CommerceManager().rate(commerce: commerceId, params: params) {
                response in
                
                Core.alert(message: "Tu calificacion y comentario han sido enviados.", title: "Gracias!", at: self)
            }
        }
        
        
    }
    
    
    func exchangeReward(){


        let okAction = UIAlertAction(title: "Canjear", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.showCoinsPoup()

        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        Core.shared.customAlert(message: "", title: "¿Deseas canjear este premio?", cancel: cancelAction, accept: okAction, at: self)
    }
    
    
    @IBAction func checkIn(_ sender: UIButton) {
        
        self.showmakeCheckInConntroller()
        
    }
    
    @IBAction func reserve(_ sender: UIButton) {
        performSegue(withIdentifier: "ShopDetailToReservationSegue", sender: self)
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - HELPER
    
    fileprivate func addReview(completion: @escaping () -> Void) {
        
        
    }
    
    

}

// MARK: - UITABLEVIEW DELEGATE & DATASOURCE

extension ShopDetailController {
    
    // numberOfSections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (commerce?.rewards?.count ?? 0) > 0 ? 2 : 1
    }
    
    // numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 2
        default: return commerce?.rewards?.count ?? 0
        }
    }
    
    // heightForHeaderInSection
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 10 : 65
    }
    
    // viewForHeaderInSection
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProductsHeaderView") as? ProductsHeaderView
            return header
        }
        return nil
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0: print("Section 0")
        default:
            
            print("Another one")
            
            self.selectedReward = self.commerce?.rewards?[indexPath.row]
            
            guard let uid = App.core.currentUser?.id else {
                print("JO: getUserInfo: No UID")
                return
            }
            
            let params: Params = [
                "user": uid,
                "reward": "1",
                "commerce": "1"
            ]
            
            UserManager().buyReward(params: params, completionHandler: {
                reward in
                if reward?.status == "Reward applied"{
                    
                    self.exchangeReward()
                   
                }
                
                if reward?.status == "Coins not enough"{
                    Core.alert(message: "Lo sentimos, no posee las monedas suficientes para canjear este premio", title: Titles().somethingWrong, at: self)
                }
                //
                if reward?.status == "No coins available"{
                    Core.alert(message: "Lo sentimos, no posee las monedas suficientes para canjear este premio", title: Titles().somethingWrong, at: self)
                }
                if reward?.status == "Reward not found"{
                    Core.alert(message: "Lo sentimos, no pusdimos encontrar esta promoción como disponible", title: Titles().somethingWrong, at: self)
                }
            })
            
            
        }
        
        
    }
    
    
    
    
    // cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        let cell: UITableViewCell
        let identifier: String
        var title: String? = ""
        var detail: String? = ""
        
        switch section {
        case 0:
            
            identifier = "MainCell"
            
            if row == 0 {
                title = "Hielerasos"
                
                if let hielerazo = commerce?.hielerazoPrice {
                    detail = "$\(hielerazo)"
                }
            }
            else if row == 1 {
                title = "Balde"
                if let balde = commerce?.baldePrice {
                    detail = "$\(balde)"
                }
            }
            
        default:
            
            identifier = "RewardCell"
            title = commerce?.rewards?[indexPath.row].name
            if let coins = commerce?.rewards?[indexPath.row].coinsValue?.description{
                detail = "coins: \(coins)"
            }
            
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = detail
        
        
        
        return cell
    }



}

// MARK: - TEXT VIEW DELEGATE

extension ShopDetailController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Agrega tu comentario a este restaurante" {
            textView.text = ""
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: tableView)
        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: pointInTable.y)
        return true
    }
}

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE

extension ShopDetailController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        noPromoslabel.isHidden = false
        guard let promos = commerce?.promotions else {
            print("error")
            
            return 0
        }
        
        if promos.count > 0 { noPromoslabel.isHidden = true }
        return commerce?.promotions?.count ?? 0
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PromotionCollectionCell", for: indexPath) as? PromotionCollectionCell else { return UICollectionViewCell() }
        
        if let image = commerce?.promotions?[indexPath.row].image, let imageURL = URL(string: image) {
            cell.photoImage.sd_setImage(with: imageURL, placeholderImage: nil)
        }
        
        return cell
    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        promotions = commerce?.promotions![indexPath.row]
        performSegue(withIdentifier: "CommerceDetailToPromotionDetailSegue", sender: self)
    }
    
}

