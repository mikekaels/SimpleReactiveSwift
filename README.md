# Simple Reactive Swift

![This is an image](https://ik.imagekit.io/m1ke1magek1t/Group%202_uWzon_8q4.png?updatedAt=1709488218399)

### Features
- Profile
- Simulation
- Dark Mode

### Clean Architecture
![Clean Architechture](https://ik.imagekit.io/m1ke1magek1t/CleanArch.png?updatedAt=1705685276939)

I've implemented a clean architecture, which is great for building highly testable projects and decoupling modules to minimize complexity.
```
├─ ...
├─ Modules
    ├─ Profile
        ├─ Data (Handles data-related operations, including repositories, requests, and responses)
            ├─ Repositories
            ├─ Requests
            ├─ Responses
        ├─ Domain (Contains business logic and entities representing the core functionality)
            ├─ UseCases
            ├─ Entities
        ├─ Presentation (Manages the UI and logic of the view)
            ├─ ProfileVC
            ├─ ProfileVM
            ├─ Views
                ├─ ProfileMenuCell
├─ Appplication
```

### Design Pattern MVVM-FRP (✅ Unidirectional data flow)
#### ViewModel
```
internal final class ProfileVM {
  struct Action {
  ... // All actions
  }

  class State {
  ... // All state/datasources
  }

  func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
  ... // Observes actions and applies side effects to the state
  }
}
```

#### ViewController (✅ Reactive with Combine)
```
private func bindViewModel() {

  let input = ProfileVM.Input(...)
  let output = viewModel.transform(input, cancellables: &cancellables)

  output.$...
  .sink { [weak self] _ in
  .... // Perform view updates when the state changes
  }
  .store(in: &cancellables)

}
```

### Programmatically Built UI
I prefer programmatic UI to avoid errors or conflicts with XIB or Storyboard files.
```
private let imageView: UIImageView = {
  let image = UIImageView()
  image.contentMode = .scaleAspectFill
  image.layer.masksToBounds = true
  return image
}()
        
view.addSubview(imageView)
```

### Auto Layout
For configuring auto layout I use [SnapKit](https://github.com/SnapKit/SnapKit) for faster development .

Without SnapKit
```
  imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
  imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
  imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
```

With Snapkit
```
imageView.snp.makeConstraints { make in
    make.width.equalTo(200)
    make.height.equalTo(280)
    make.top.equalTo(contentView).offset(20)
    make.centerX.equalTo(contentView)
}
```

### XCTest
Unit testing is implemented for View Models, Use Cases, and Repositories.
![Unit testing](https://ik.imagekit.io/m1ke1magek1t/Group%203_aCrbsvoOd.png?updatedAt=1709488218128)


## Getting Started
### 1. Clone this project
Clone this project via HTTP or SSH in your terminal:
- HTTPS ``` git clone https://github.com/mikekaels/SimpleReactiveSwift.git ```
- SSH ``` git clone git@github.com:mikekaels/SimpleReactiveSwift.git ```
- Or [Download](https://github.com/mikekaels/SimpleReactiveSwift/archive/refs/heads/main.zip) this project


### 2. Instalation

Ensure you have installed [cocoapods](https://cocoapods.org/) on your machine, If not, run this command in your terminal: 
```bash
$ sudo gem install cocoapods
```
If you already have CocoaPods installed, navigate to the root directory of this project in your terminal and run this command:
```bash
pod install
```
### 3. Open the .xcworkspace file
```bash
open SimpleReactiveSwift.xcworkspace
```

### 4. Run
Select the simulator or device, and run the project!

### 5. Done

## Dependency
- **Snapkit**: For handling auto layout
- **CombineCocoa**: Extensions for UIKit publisher (used for textfield's text value change)
- **IQKeyboardManagerSwift**: For handling keyboard (used for tapping outside)
