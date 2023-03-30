//
// Copyright (c) 2020 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public extension ProgressHUD {

	class func dismiss() {
		DispatchQueue.main.async {
			shared.hudHide()
		}
	}

	class func show() {
		DispatchQueue.main.async {
			shared.setup()
		}
	}

}

public class ProgressHUD: UIView {

	private var viewBackground: UIView?
	private var viewProgress: UIView?
    
    private var imgView: UIImageView?
    
    

	static let shared: ProgressHUD = {
		let instance = ProgressHUD()
		return instance
	} ()

	convenience private init() {

		self.init(frame: UIScreen.main.bounds)
		self.alpha = 0
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	required internal init?(coder: NSCoder) {

		super.init(coder: coder)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override private init(frame: CGRect) {

		super.init(frame: frame)
	}

	private func setup() {
		setupBackground()
		setupSize()
		setupPosition()
		hudShow()
	}

	private func setupBackground() {

		if (viewBackground == nil) {
			let mainWindow = UIApplication.shared.windows.first ?? UIWindow()
			viewBackground = UIView(frame: self.bounds)
			mainWindow.addSubview(viewBackground!)
		}

        viewBackground?.backgroundColor = UIColor(ciColor: .black).withAlphaComponent(0.5)
		viewBackground?.isUserInteractionEnabled = false
        
        

        
	}

	
	
	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func setupSize() {

        if (viewProgress == nil) {
            viewProgress = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        }
        
        viewProgress?.backgroundColor = .white
        
        if (imgView == nil) {
            imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        }

     
        imgView?.animationImages = loaderImages as? [UIImage];
        imgView?.contentMode = .scaleAspectFit
        
        imgView?.animationDuration = 1.5;
        imgView?.startAnimating()
        
		viewProgress?.center = CGPoint(x: 40, y: 40)
        
        viewProgress?.addSubview(imgView!)
        viewProgress?.backgroundColor = .white
        
        viewProgress?.center = CGPoint(x: 40, y: 40)
        viewBackground?.addSubview(viewProgress!)
	}

	@objc private func setupPosition() {
		let screen = UIScreen.main.bounds
        UIView.animate(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
			self.viewBackground?.frame = screen
		}, completion: nil)
	}

	private func hudShow() {
		if (self.alpha != 1) {
			self.alpha = 1

			UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
			}, completion: nil)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func hudHide() {

		if (self.alpha == 1) {
			UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
			}, completion: { isFinished in
				self.hudDestroy()
				self.alpha = 0
			})
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	private func hudDestroy() {
		viewBackground?.removeFromSuperview();		viewBackground = nil

	}
}
