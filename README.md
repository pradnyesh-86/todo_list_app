# Flutter ToDo List App

A simple and user-friendly ToDo List app built with **Flutter**. This app allows users to create, manage, and prioritize tasks. You can set task reminders and due dates, sort tasks by priority or creation date, and receive notifications for upcoming tasks. 

## Features

- **Create Tasks**: Add tasks with a title, description, priority level, and due date.
- **Task Management**: Edit and delete tasks as needed.
- **Priority Levels**: Set task priority (Low, Medium, High) to organize important tasks.
- **Due Dates**: Assign due dates to tasks and sort them based on deadlines.
- **Reminders**: Set reminders for tasks that are approaching their due date.
- **Search Functionality**: Search tasks by title or keyword.
- **Push Notifications**: Receive notifications for tasks that are due soon.
- **Task Sorting**: Sort tasks based on priority, due date, or creation date.
- **Data Persistence**: All tasks are saved locally so that data is maintained even after closing or restarting the app.


## Technologies Used

- **Flutter**: The framework for building the mobile UI.
- **Dart**: The programming language for the app.
- **GetX**: For state management and routing.
- **flutter_local_notifications**: For scheduling local notifications and reminders.
- **Intl**: For date formatting.

## Installation

### Prerequisites

- Install [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Install [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) with Flutter extension.
- An emulator or a physical Android/iOS device for testing.

### Steps to Run Locally

1. **Clone the Repository**
   ```bash
   git clone https://github.com/pradnyesh-86/todo_list_app.git
   ```
   
2. **Navigate to the Project Directory**
   ```bash
   cd todo_list_app
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the App**
   - Open an emulator or connect your device.
   - Run the following command:
   ```bash
   flutter run
   ```

## App Structure

The project follows **MVVM (Model-View-ViewModel)** architecture, using **GetX** for state management and routing. 

```
lib/
|-- models/                  # Data models (e.g., Task)
|-- views/                   # UI screens (Home, Add Task)
|-- viewmodels/              # Controllers for handling state (e.g., TaskController)
|-- services/                # Notification services
|-- main.dart                # Entry point for the app
```

### Key Files

- `lib/views/home_screen.dart`: The main screen showing the task list.
- `lib/views/add_task_screen.dart`: Form for adding/editing tasks.
- `lib/viewmodels/task_controller.dart`: Controller for managing tasks.
- `lib/models/task.dart`: Task data model.
- `lib/services/notification_service.dart`: Manages scheduling of notifications.

## How to Use

1. **Adding a Task**: Tap the "+" button to add a new task. Fill in the task title, description, priority level, due date, and optionally set a reminder.
2. **Editing/Deleting Tasks**: Long press on a task to edit or delete it.
3. **Set Reminders**: You can toggle the "Set Reminder" option to receive a notification when the task is due.
4. **Search Tasks**: Use the search bar to find tasks by title or keyword.

## State Management

The app uses **GetX** for state management. All the tasks are managed centrally by a `TaskController` which:
- Adds new tasks.
- Edits and deletes tasks.
- Sorts and searches tasks.
- Notifies the view when tasks are updated.

## Notifications

The app uses **flutter_local_notifications** to schedule task reminders based on the task's due date. Notifications are triggered when a task is close to its due date, allowing users to stay on top of upcoming tasks.

### To Set Notifications

1. Make sure you have the notification icon (`app_icon.png`) set up under `android/app/src/main/res/drawable/`.
2. The `NotificationService` in `services/notification_service.dart` is responsible for scheduling and displaying local notifications when tasks are due.

## Known Issues

- Notifications might not work on some devices due to Android's aggressive battery management policies. To fix this, users may need to allow background activity for the app in their device settings.

## Future Improvements

- **Cloud Sync**: Enable task syncing across devices using Firebase.
- **Recurring Tasks**: Add support for recurring tasks (daily, weekly, etc.).
- **Dark Mode**: Add a dark mode theme.
- **UI Enhancements**: Improve task sorting and filtering options.

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new feature branch (`git checkout -b feature/your-feature-name`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature-name`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

.
