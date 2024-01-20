# iOS MVVM-C Template Chat Project
## Overview
This project serves as a template for building iOS applications with a chat style feature, using Swift with the Model-View-ViewModel-Coordinator (MVVM-C) architecture. The focus of this template is to strike a balance between simplicity and a clean separation of concerns, facilitating the rapid development of features with a structure that is straightforward to understand and test.

The app implements chat with a "dummy" or ChatGPT. The first screen allows the user to select between these two chats with an API key required to be entered for the GPT chat (note that there is not currently any validation of whether the API key is correct or not). 

Key Features:
* MVVM-C Architecture: Demonstrates the use of MVVM-C, enhancing the scalability and maintainability of the app.
* Testability: With separated concerns, the project is structured to simplify unit testing and UI testing (though no real UI tests are currently implemented).

Considerations:
* This project uses UIKit, while SwiftUI is certainly an option, UIKit changes less frequently and will allow for reduced maintenance of this project.
* Dependency management is not used as there are currently no need for third party libraries, however Swift Package Manager or Cocoapods could easily be used.
