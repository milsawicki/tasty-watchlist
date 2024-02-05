
## MVVM+C (Model-View-ViewModel-Coordinator)

### Architecture
**MVVM** 
 **Separation of concerns:** MVVM is particularly advantageous for projects that require a clean separation between the user interface and the business logic, demand high testability and maintainability. It's also helpful for bigger teams, enhancing parallel development and reducing bottlenecks. Teams can work on the View, ViewModel, and Model independently.
 **Testability:** Since the ViewModel is decoupled from the View (user interface), it can be tested independently of UI components. This separation allows for more straightforward unit testing of business and presentation logic.
 **Support for Reactive Programming**: MVVM supports data binding between the View and ViewModel, allowing automatic UI updates when data changes and vice versa. This is particularly powerfull in use with reactive framework like Combine. It aligns well with reactive programming concepts, which are increasingly popular for handling dynamic data and asynchronous operations.

## UI Layer
**Views are created programatically.**
Please, do not use xib and storyboards! In large teams or projects, merge conflicts with storyboard files can be a significant issue. Since storyboard changes are often represented as XML changes, resolving these conflicts can be difficult and error-prone. Code, on the other hand, is generally easier to merge and manage in version control systems. Snapkit for setting constraints is highly encouraged. 

