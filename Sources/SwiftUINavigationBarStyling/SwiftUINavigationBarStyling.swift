import SwiftUI
import UIKit

public struct NavigationBarColorModifier: ViewModifier {
  var backgroundColor: UIColor
  var textColor: UIColor

  public init(backgroundColor: UIColor, textColor: UIColor, titleFont: UIFont? = nil, largeTitleFont: UIFont? = nil) {
    self.backgroundColor = backgroundColor
    self.textColor = textColor
    let coloredAppearance = UINavigationBarAppearance()
    coloredAppearance.configureWithTransparentBackground()
    coloredAppearance.backgroundColor = .clear
    var titleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: textColor]
    if let titleFont = titleFont {
        titleTextAttributes[.font] = titleFont
    }
    coloredAppearance.titleTextAttributes = titleTextAttributes
    var largeTitleTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: textColor]
    if let largeTitleFont = largeTitleFont {
        largeTitleTextAttributes[.font] = largeTitleFont
    }
    coloredAppearance.largeTitleTextAttributes = largeTitleTextAttributes

    UINavigationBar.appearance().standardAppearance = coloredAppearance
    UINavigationBar.appearance().compactAppearance = coloredAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    UINavigationBar.appearance().tintColor = textColor
  }

  public func body(content: Content) -> some View {
    ZStack {
       content
        VStack {
          GeometryReader { geometry in
             Color(self.backgroundColor)
                .frame(height: geometry.safeAreaInsets.top)
                .edgesIgnoringSafeArea(.top)
              Spacer()
          }
        }
     }
  }
}

public extension View {
  func navigationBarColor(_ backgroundColor: UIColor, textColor: UIColor, titleFont: UIFont? = nil, largeTitleFont: UIFont? = nil) -> some View {
    self.modifier(NavigationBarColorModifier(backgroundColor: backgroundColor, textColor: textColor, titleFont: titleFont, largeTitleFont: largeTitleFont))
  }
}

public class StyledHostingController<Content> : UIHostingController<Content> where Content : View {
    private var statusBarStyle: UIStatusBarStyle?
    
    public init(statusBarStyle: UIStatusBarStyle, rootView: Content) {
        self.statusBarStyle = statusBarStyle
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
  @objc override dynamic open var preferredStatusBarStyle: UIStatusBarStyle {
    return statusBarStyle ?? .default
  }
}
