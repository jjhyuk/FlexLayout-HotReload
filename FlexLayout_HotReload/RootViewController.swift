//
//  RootViewController.swift
//  FlexLayout_HotReload
//
//  Created by Denver on 2022/04/08.
//

import FlexLayout
import PinLayout
import RxGesture
import RxSwift
import Then

class RootViewController: UIViewController {
  
  let MAX_SUBVIEW_COUNT = 20
  
  enum UI {
    case ButtonTitle
    case IndexLabel(Int)
    case AlertTitle
    case AlertMessage
    case AlertConfirmButton
    
    func toString() -> String {
      switch self {
        case .AlertTitle: return "Hot Reload!"
        case .AlertMessage: return "Change Message"
        case .AlertConfirmButton: return "OK"
        case .ButtonTitle: return "Button Name aaaaasssss"
        case .IndexLabel(let i): return "Indeasdfljsadfjlksajklx\(i) Text"
      }
    }
  }
  
  let container: UIView = UIView()
  let scrollView: UIScrollView = UIScrollView()
  let button = UIButton(type: .custom)
    .then {
      $0.setTitle(UI.ButtonTitle.toString(), for: .normal)
      $0.setTitleColor(.black, for: .normal)
      $0.layer.borderWidth = 2
      $0.layer.borderColor = UIColor.black.cgColor
    }
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    self.view.addSubview(container)
    
    configureUI()
    bindButton()
  }
  
  func configureUI() {
    self.container.flex.define { flex in
      flex.addItem(scrollView).define { flex in
        for i in 0 ..< MAX_SUBVIEW_COUNT {
          let color = getRandomColor()
          flex.addItem()
            .size(CGFloat(10 * (i + 1)))
            .backgroundColor(color)
            .marginVertical(10)
          
          let label = UILabel()
          label.text = UI.IndexLabel(i + 1).toString()
          label.textColor = color
          flex.addItem(label)
        }
      }
      .alignItems(.center)
      .position(.absolute)
      .top(0).left(0).right(0).bottom(80)
      .backgroundColor(.lightGray.withAlphaComponent(0.3))
      .layout()
      
      flex.addItem().define { flex in
        flex.addItem(button)
          .width(80%)
          .height(50)
      }
      .alignItems(.center)
      .justifyContent(.center)
      .width(100%)
      .height(80)
      .backgroundColor(.white)
    }
    .justifyContent(.end)
    .alignItems(.center)
    .backgroundColor(.white)
  }
  
  func bindButton() {
    button.rx.tapGesture()
      .when(.ended)
      .withUnretained(self)
      .bind { (this, _) in this.showAlertView() }
      .disposed(by: disposeBag)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    self.container.pin.vertically(self.view.pin.safeArea)
    self.container.pin.horizontally()
    
    self.container.pin.layout()
    self.container.flex.layout(mode: .fitContainer)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.scrollView.resizeContentView()
  }
  
  
  func getRandomColor() -> UIColor{
    let randomRed:CGFloat = CGFloat(drand48())
    let randomGreen:CGFloat = CGFloat(drand48())
    let randomBlue:CGFloat = CGFloat(drand48())
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
  }
  
  func showAlertView() {
    let alert = UIAlertController(title: UI.AlertTitle.toString(),
                                  message: UI.AlertMessage.toString(),
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: UI.AlertConfirmButton.toString(),
                               style: .default,
                               handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}

extension UIScrollView {
  func resizeContentView() {
    self.contentSize = self.subviews.reduce(into: CGRect.zero) { partialResult, view in
      partialResult = partialResult.union(view.frame)
    }.size
  }
}
