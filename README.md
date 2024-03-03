# SimpleReactiveSwift

![This is an image](https://ik.imagekit.io/m1ke1magek1t/Group%202_uWzon_8q4.png?updatedAt=1709488218399)

## Features
- Profile
- Simulation
- Dark Mode

### Clean Architecture
![Clean Architechture](https://ik.imagekit.io/m1ke1magek1t/CleanArch.png?updatedAt=1705685276939)

I use the clean architecture that might be worth looking to build highly testable projects and decoupling the modules so it can minimize the complexity.
```
├─ ...
├─ Modules
    ├─ Profile
        ├─ Data (Concerned with data-related operations, including repositories, requests, and responses)
            ├─ Repositories
            ├─ Requests
            ├─ Responses
        ├─ Domain (Contains business logic and entities that represent the core functionality of the module)
            ├─ UseCases
            ├─ Entities
        ├─ Presentation (Handles the UI and the logic of the view)
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
  ... all the actions from the view
  }

  class State {
  ... all the state/datasources
  }

  func transform(_ input: Input, cancellables: inout Set<AnyCancellable>) -> Output {
  ... where all the actions observed and giving the side effect to the state
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
  .... // do something to the view when there is changes on the state
  }
  .store(in: &cancellables)

}
```

### Programatically UI
I'm more confident to use programatically to avoid error or conflict on the XIB or Storyboard
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
To configure auto layout I use [SnapKit](https://github.com/SnapKit/SnapKit) for faster development .

without SnapKit
```
  imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
  imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
  imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
```

with Snapkit
```
imageView.snp.makeConstraints { make in
    make.width.equalTo(200)
    make.height.equalTo(280)
    make.top.equalTo(contentView).offset(20)
    make.centerX.equalTo(contentView)
}
```

### XCTest
Make unit testing for view models, use cases, and repositories
![Unit testing](https://ik.imagekit.io/m1ke1magek1t/Group%203_aCrbsvoOd.png?updatedAt=1709488218128)


## Getting Started
### 1. Clone this project
You can clone the project by Http or Ssh on your terminal
- HTTPS ``` git clone https://github.com/mikekaels/SimpleReactiveSwift.git ```
- SSH ``` git clone git@github.com:mikekaels/SimpleReactiveSwift.git ```
- Or [Download](https://github.com/mikekaels/SimpleReactiveSwift/archive/refs/heads/main.zip) the project


### 2. Instalation

Make sure you have installed [cocoapods](https://cocoapods.org/) on your machine, if not please do this command in your Terminal: 
```bash
$ sudo gem install cocoapods
```
If you already install cocoapods, in your terminal go to inside the project directory and do this command: 
```bash
pod install
```
### 3. Open the .xcworkspace file

### 4. Run
Select the simulator or device
and Run the project!

### 5. Done

## Dependency
- **Snapkit** to handle auto layout
- **CombineCocoa** extensions UIKit publisher (used for textfield's text value change)
- **IQKeyboardManagerSwift** to handle keyboard (used for handle tap outside)
