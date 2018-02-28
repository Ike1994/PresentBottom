### 用UIPresentationController来写一个简洁漂亮的底部弹出控件

iOS App开发过程中，底部弹出框是一个非常常见的需求。如何写一个漂亮的底部弹出框呢？方式有很多，直接添加一个自定义的View让它动画展示和隐藏都是一种非常简单的操作，不过看起来似乎不那么优雅，我们可以使用`UIPresentationController`来方便快捷地创建一个高定制化的底部弹出框。

UIPresentationController: an object that manages the transition animations and the presentation of view controllers onscreen.

最终效果如下：

![](https://user-gold-cdn.xitu.io/2018/2/28/161daff5fec6a3dc?w=256&h=456&f=gif&s=441809)

![](https://user-gold-cdn.xitu.io/2018/2/28/161daffa284f53cb?w=256&h=456&f=gif&s=437642)

我们需要在iOS8及以上的系统中使用`UIPresentationController`，使用时需要新建一个类继承UIPresentationController并重写以下几个方法和属性：

```Swift
//决定了弹出框的frame
override var frameOfPresentedViewInContainerView

//重写此方法可以在弹框即将显示时执行所需要的操作
override func presentationTransitionWillBegin()

//重写此方法可以在弹框显示完毕时执行所需要的操作
override func presentationTransitionDidEnd(_ completed: Bool)

//重写此方法可以在弹框即将消失时执行所需要的操作
override func dismissalTransitionWillBegin()

//重写此方法可以在弹框消失之后执行所需要的操作
override func dismissalTransitionDidEnd(_ completed: Bool)
```
重写初始化方法：

```Swift
override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController:presentedViewController,presenting: presentingViewController)
}
```
在大多数时候，我们希望底部弹出框出现时，先前的显示区域能够灰暗一些，来强调弹出框的显示区域是用户当前操作的首要区域。因此，我们给这个自定义的类添加一个遮罩：

```Swift
lazy var blackView: UIView = {
    let view = UIView()
    if let frame = self.containerView?.bounds {
        view.frame = frame
    }
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    return view
}()
```

重写`presentationTransitionWillBegin`、`dismissalTransitionWillBegin`和`dismissalTransitionDidEnd(_ completed: Bool)`方法。在弹窗即将出现时把遮罩添加到containerView，并通过动画将遮罩的alpha设置为1；在弹窗即将消失时通过动画将遮罩的alpha设置为0；在弹框消失之后将遮罩从containerView上移除：

```Swift
override func presentationTransitionWillBegin() {
    blackView.alpha = 0
    containerView?.addSubview(blackLayerView)
    UIView.animate(withDuration: 0.5) {
        self.blackView.alpha = 1
  	}
}

override func dismissalTransitionWillBegin() {
    UIView.animate(withDuration: 0.5) {
        self.blackView.alpha = 0
    }
}

override func dismissalTransitionDidEnd(_ completed: Bool) {
    if completed {
        blackView.removeFromSuperview()
    }
}
```

接下来，我们重写`frameOfPresentedViewInContainerView`这个属性。它决定了弹出框在屏幕中的位置，由于我们是底部弹出框，我们设定一个弹出框的高度controllerHeight，即可得出弹出框的frame：

```Swift
override var frameOfPresentedViewInContainerView: CGRect {
    return CGRect(x: 0, y: UIScreen.main.bounds.height-controllerHeight, width: UIScreen.main.bounds.width, height: controllerHeight)
}
```

为了便于我们创建各种各样的底部弹出框，我们创建一个基类`PresentBottomVC`继承自`UIViewController`，并添加一个属性`controllerHeight`用于得到弹出框的高度：

```Swift
public class PresentBottomVC: UIViewController {
    public var controllerHeight: CGFloat? {
        get {
            return self.controllerHeight
        }
    }
}
```
之后，我们就可以新建继承自`PresentBottomVC`并重写`controllerHeight`属性的类来实现定制化底部弹出框。为了方便调用弹出方法，我们给`UIViewController`添加一个Extension，并实现`UIViewControllerTransitioningDelegate`协议：

```Swift
public func presentBottom(_ vc: PresentBottomVC.Type) {
    let controller = vc.init()
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate = self
    self.present(controller, animated: true, completion: nil)
}
public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let present = PresentBottom(presentedViewController: presented, presenting: presenting)
    return present
}
```

可以看到，所有继承自`PresentBottomVC`的ViewController都可以通过该方法来从另一个ViewController的底部弹出。例如，我们新建一个类`FirstBottomVC`，重写`controllerHeight`并设为200，在页面中添加一个关闭按钮：

```Swift
final class FirstBottomVC: PresentBottomVC {
    lazy var closeButton:UIButton = {
        let button = UIButton(frame: CGRect(x: 15, y: 30, width: 80, height: 30))
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        return button
    }()
    override var controllerHeight: CGFloat? {
        return 200
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(closeButton)
    }
    @objc func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
```
之后在需要弹出的时候调用`UIViewController`的`presentBottom(_ vc: PresentBottomVC.Type)`方法就可以一句代码搞定啦：

```Swift
self.presentBottom(FirstBottomVC.self)
```

效果如下图：

![](https://user-gold-cdn.xitu.io/2018/2/28/161dad30952266a8?w=256&h=456&f=gif&s=190665)