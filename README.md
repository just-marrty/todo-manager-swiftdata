# TodoManager

A SwiftUI application for managing tasks with full CRUD operations, utilizing SwiftData for local persistence and MVVM architecture with priority-based organization through tab navigation.

**Note:** This application uses SwiftData framework for local data persistence, providing seamless task management without requiring a backend server.

## Features

- Priority-based tab navigation (All, Low, Medium, High)
- Browse tasks with detailed information (title, priority, category, due date, completion status)
- Add new tasks with priority, category, and optional due date
- Edit existing tasks with pre-populated data
- Delete tasks via swipe gesture
- Mark tasks as done with visual indicators
- Automatic expired task detection and visual feedback
- Priority-based color coding (Low: Blue, Medium: Orange, High: Red)
- Category organization (General, Work, Personal, Shopping)
- Real-time search functionality across task titles
- Settings view with customizable appearance (dark mode, list spacing)
- Form validation for task creation and editing
- Clean and modern UI with SwiftUI
- Persistent settings using @AppStorage
- Due date validation (prevents selecting past dates for new tasks)
- MVVM architecture with separated business logic

## Architecture

The project follows MVVM (Model-View-ViewModel) pattern with SwiftData for persistence:

### Models

#### TodoPriority

Enum representing task priority levels:
- Three priority levels: Low, Medium, High
- Conforms to `Codable` and `CaseIterable`
- Computed property `color` returns visual indicators:
  - Low: Blue with 0.7 opacity
  - Medium: Orange with 0.7 opacity
  - High: Red with 0.7 opacity
- Raw string values for display purposes

#### TodoCategory

Enum representing task categories:
- Four categories: General, Work, Personal, Shopping
- Conforms to `Codable` and `CaseIterable`
- Uses raw string values for display

#### Todo

Main model representing a task:
- Decorated with `@Model` macro for SwiftData persistence
- Properties:
  - `title: String` - Task description
  - `isDone: Bool?` - Completion status (optional)
  - `category: TodoCategory` - Task categorization
  - `priority: TodoPriority` - Task priority level
  - `dueDate: Date?` - Optional deadline
  - `createdAt: Date` - Timestamp of task creation
- Automatically persists to local database
- Conforms to SwiftData's requirements

### ViewModels

#### QueryListViewModel

ViewModel for TodoQueryListView handling filtering logic:
- Decorated with `@Observable` macro for SwiftUI observation
- Marked with `@MainActor` for main thread execution
- Properties:
  - `priority: TodoPriority?` - Optional priority filter
- Computed property `priorityTitle` returns display title ("All" or priority name)
- Method `filteredTodos(from:searchText:)` filters todos by priority and search text
- Uses Constructor Dependency Injection (accepts `priority` parameter)
- Business logic separated from UI for testability

### Screens & Views

#### TodoManagerApp

Application entry point:
- Configures SwiftData model container for `Todo` model
- Sets up `WindowGroup` with `TodoMainScreen` as root view
- Provides model context to entire app hierarchy

#### TodoMainScreen

Main navigation hub with priority-based tabs:
- Uses `TabView` with four tabs:
  - **All**: Shows all tasks regardless of priority
  - **Low**: Filters tasks with low priority
  - **Medium**: Filters tasks with medium priority
  - **High**: Filters tasks with high priority
- Each tab contains a `NavigationStack` with `TodoQueryListView`
- Passes priority filter to each view via dependency injection
- Manages dark mode preference via `@AppStorage`
- Applies `preferredColorScheme` based on user settings
- SF Symbols icons for tab identification

#### TodoQueryListView

Dynamic list view with filtering, sorting, and search (MVVM pattern):
- Uses `@Query` macro for reactive data fetching from SwiftData
- Uses `@State` for `queryVM: QueryListViewModel` instance
- Uses `@State` for `searchText: String` (bound to `.searchable`)
- Custom initializer with dependency injection:
  - Accepts optional `priority` for priority-based filtering
  - Injects priority into `QueryListViewModel`
- Computed property `filteredTodos`:
  - Calls `queryVM.filteredTodos(from: todos, searchText: searchText)`
  - Filters by priority if specified
  - Filters by search text using `localizedStandardContains`
  - Returns final filtered array
- List row display shows:
  - Task title (limited to 1 line)
  - Priority label with color-coded value
  - Due date (formatted, or "No due date")
  - Status indicators:
    - Done: Green checkmark circle
    - Expired: Red exclamation circle
    - In progress: Running figure icon
- Swipe actions:
  - Delete button on trailing edge
  - Red-tinted with trash icon
  - Full swipe disabled for safety
  - Deletes from context and saves immediately
- Navigation features:
  - Rows wrapped in `NavigationLink` with `Todo` value
  - Disabled for expired tasks (past due date)
  - Navigation destination configured for `TodoUpdateView`
- Toolbar items:
  - Leading: Settings gear icon (navigates to `TodoSettingsView`)
  - Trailing: Plus icon (navigates to `AddTodoView`)
- Row styling:
  - Brown-tinted backgrounds (0.2 opacity)
  - Custom insets (8pt vertical, 15pt horizontal)
  - Configurable row spacing via `@AppStorage("isListRowSpacing")`
- Background styling:
  - Hidden scroll content background
  - Blue-tinted background (0.1 opacity)
- Search integration:
  - Searchable with prompt "Search your tasks..."
  - Animated search results
- Navigation title: "My Tasks - [Priority]" (uses `queryVM.priorityTitle`)
- Sorts todos by `dueDate` by default

#### AddTodoView

Form for creating new tasks:
- Form-based layout with multiple sections:
  - **New task section**: `TextEditor` for task description (130pt height, autocorrection disabled)
  - **Priority section**: Picker for selecting priority level (automatic style)
  - **Category section**: Picker for selecting category (automatic style)
  - **Due date section**: 
    - Toggle for enabling optional due date
    - `DatePicker` appears when enabled (minimum date: current date)
- Form validation:
  - Computed property `isFormValid` checks for non-empty title
  - Title trimmed of whitespace before saving
  - Save button disabled when form is invalid
- Visual styling:
  - Brown-tinted section backgrounds (0.2 opacity)
  - Blue-tinted screen background (0.1 opacity)
  - Hidden scroll content background
- Navigation bar:
  - Title: "Add Task" (inline display mode)
  - Trailing button: "Save" (disabled when invalid)
- On save:
  - Creates new `Todo` instance with trimmed title
  - Sets `isDone` to `false` by default
  - Inserts into `modelContext`
  - Saves context with error handling
  - Dismisses view automatically
- Uses `@Environment(\.dismiss)` for navigation dismissal
- Uses `@Environment(\.modelContext)` for data persistence
- Keyboard dismissal on scroll

#### TodoUpdateView

Form for editing existing tasks:
- Similar layout to `AddTodoView` with additional features
- Receives `todo: Todo` parameter via dependency injection
- Pre-populates form fields on appear:
  - Title from existing todo
  - Category from existing todo
  - Priority from existing todo
  - Due date toggle and value if present
  - Is done toggle and value if present
- Additional **Is done section**:
  - Toggle for marking task completion
  - Green-tinted toggle (0.5 opacity)
  - Footer message "Your task is done!" when marked complete
- Form sections:
  - Your task (instead of "New task")
  - Category
  - Priority
  - Due date with optional toggle
  - Is done with optional toggle
- Navigation bar:
  - Title: "Update Task" (inline display mode)
  - Trailing button: "Update" (disabled when invalid)
- On update:
  - Updates existing `Todo` properties in-place
  - Saves context with error handling
  - Dismisses view automatically
- Same visual styling as `AddTodoView`
- Uses `@Environment(\.dismiss)` and `@Environment(\.modelContext)`

#### TodoSettingsView

Application settings and preferences:
- Form-based layout with two sections:
  - **Design - Rows**: Toggle for list row spacing preference
  - **Design - Appearance**: Toggle for dark/light mode
- Dynamic label: Shows "Light mode" when dark, "Dark mode" when light
- Uses `@AppStorage` for persistent settings:
  - `isListRowSpacing: Bool` (default: false)
  - `isDarkOn: Bool` (default: false)
- Visual styling:
  - Brown-tinted section backgrounds (0.2 opacity)
  - Blue-tinted screen background (0.1 opacity)
  - Blue-tinted toggles (0.5 opacity)
  - Hidden scroll content background
- Navigation title: "Settings"
- Applies `preferredColorScheme` based on `isDarkOn` setting
- Settings automatically sync across all views via `@AppStorage`

## SwiftData Integration

### Persistence Layer

- Model container configured in `TodoManagerApp`
- `.modelContainer(for: Todo.self)` creates persistent store
- Automatic schema migration
- Local SQLite database storage
- `@Environment(\.modelContext)` provides context to views
- CRUD operations via `ModelContext`:
  - **Create**: `context.insert(newTodo)`
  - **Read**: `@Query` macro with automatic updates
  - **Update**: Direct property modification
  - **Delete**: `context.delete(todo)`
- Manual save with error handling: `try context.save()`

### Query System

- `@Query` macro for reactive data fetching
- Automatic UI updates on data changes
- Sort descriptors: Sorted by `dueDate` in ascending order
- Custom filtering logic in ViewModel layer
- Type-safe queries without predicates

## State Management

- `@State` for local view state (form inputs, toggles, search text)
- `@Environment(\.modelContext)` for SwiftData context
- `@Environment(\.dismiss)` for programmatic view dismissal
- `@Query` for reactive data binding to SwiftData
- `@AppStorage` for persistent user preferences via UserDefaults
- `@Model` macro for SwiftData model declaration
- `@Observable` macro for ViewModel observation
- `@MainActor` for main thread execution
- State-based form validation with computed properties
- Automatic UI updates via SwiftData observation

## Key Features Explained

### Priority System

Tasks can be assigned three priority levels, each with distinct visual indicators and dedicated tabs:
- **Low Priority**: Blue color (0.7 opacity)
- **Medium Priority**: Orange color (0.7 opacity)
- **High Priority**: Red color (0.7 opacity)

Each priority has its own tab in the main interface for quick filtering.

### Category System

Organize tasks into four predefined categories:
- **General**: Default category for miscellaneous tasks
- **Work**: Professional and work-related tasks
- **Personal**: Personal errands and activities
- **Shopping**: Shopping lists and purchase reminders

### Tab-Based Navigation

The main screen features four tabs for efficient task organization:
- **All**: View all tasks regardless of priority
- **Low**: View only low-priority tasks
- **Medium**: View only medium-priority tasks
- **High**: View only high-priority tasks

### Due Date Management

- Optional due dates for flexible task management
- Date picker prevents selection of past dates for new tasks
- Automatic expired task detection based on current date
- Visual indicators for expired tasks (red exclamation icon)
- Expired tasks are disabled in the list to prevent editing

### Task Completion

- Optional `isDone` status for task completion tracking
- Visual confirmation with green checkmark
- Footer message when marking task as done in edit view
- Completed tasks remain visible for reference

### Search Functionality

- Real-time search across task titles
- Case-insensitive, locale-aware matching via `localizedStandardContains`
- Animated search results
- Maintains sort order during search
- Search works within each priority tab independently

### Settings & Customization

- Toggle dark/light mode preference with immediate preview
- Adjust list row spacing for preferred density
- Settings persist across app launches via `@AppStorage`
- Dynamic labels that reflect current state

### Form Validation

Both add and edit screens include robust validation:
- Title cannot be empty or contain only whitespace
- Title is automatically trimmed before saving
- Save/Update button disabled when form is invalid
- Visual feedback through button state

## Technologies

- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Apple's native persistence framework
- **MVVM Pattern** - Separation of concerns architecture
- **NavigationStack** - Type-safe hierarchical navigation
- **TabView** - Tab-based interface for priority filtering
- **@Query** - Reactive data fetching from SwiftData
- **@Model** - SwiftData model declaration
- **@Observable** - Swift's observation system for ViewModels
- **@MainActor** - Main thread execution for UI code
- **ModelContext** - SwiftData context for CRUD operations
- **@AppStorage** - Persistent user preferences via UserDefaults
- **Form** - SwiftUI form components for data entry
- **SearchableModifier** - Built-in search functionality
- **Swipe Actions** - Gesture-based interactions
- **DatePicker** - Native date selection with validation
- **TextEditor** - Multi-line text input
- **Picker** - Native selection controls

## Data Persistence

This application uses SwiftData for local data persistence:
- All tasks are stored in a local SQLite database
- No backend server or network connection required
- Data persists across app launches and device restarts
- Automatic schema migration for model updates
- Reactive UI updates when data changes
- Type-safe queries with `@Query` macro

## Requirements

- iOS 26+
- Xcode 26+
- Swift 6
- No internet connection required (fully offline)

## Getting Started

1. Open the project in Xcode
2. Select your target device or simulator
3. Build and run (⌘R)
4. Start adding your tasks!
