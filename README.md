# 🚀 Socketing 

### ⚙️ System Requirements
- Xcode Version: 15.0
- macOS Version: Ventura 13.5 (M2)

### 🔧 Project Requirements
- Swift Version: 5.9
- iOS Deployment Target: 15.0 or later
- Dependencies: RxSwift, SocketIO, SnapKit, Starscream, Toast (via SPM)

---
### ⚙️ Installation

1️⃣ Clone the repository
```
git clone https://github.com/yeonupark/socketing-iOS
cd Socketing
```
2️⃣ Install dependencies
```
# Swift Package Manager (SPM) will automatically resolve dependencies when opening the project in Xcode.
# If needed, you can manually resolve dependencies using:

swift package resolve
```
3️⃣ Open the project
```
xed .
``` 


▶️ Running the App

1. Open the project in Xcode

2. Select a simulator or physical device

3. Press Cmd + R to run the app

---
### 📌 Project Structure
```

📂 Socketing
 ├── 📂 Utils          # Utility functions and helpers
 ├── 📂 Components     # Reusable UI components
 ├── 📂 Extensions     # Swift extensions for enhanced functionality
 ├── 📂 Base           # Base classes and protocols
 ├── 📂 Network        # Networking layer
 ├── 📂 Views          # UI screens
 ├── 📂 Controllers    # View controllers for handling UI logic
 ├── 📂 ViewModels     # Business logic and data binding (MVVM)

```
---


### 🔗 Key Features

✔ Socket-based communication

✔ Reactive programming with RxSwift

✔ MVVM architecture for better scalability

✔ User authentication & token validation  

