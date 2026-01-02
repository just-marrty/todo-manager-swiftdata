# TodoManager

A SwiftUI application for managing tasks with full CRUD operations, utilizing SwiftData for local persistence.

**Note:** This application uses SwiftData framework for local data persistence, providing seamless task management without requiring a backend server.

## Features

- Browse a list of tasks with detailed information (title, priority, category, due date, completion status)
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

## Architecture

The project demonstrates modern SwiftUI patterns with SwiftData for persistence:

### Model

**TodoPriority** - Enum representing task priority levels
- Three priority levels: Low, Medium, High
- Conforms to `Codable` and `CaseIterable`
- Computed property `color` returns visual indicators:
  - Low: Blue with 0.7 opacity
  - Medium: Orange with 0.7 opacity
  - High: Red with 0.7 opacity
- Raw values for display purposes

**TodoCategory** - Enum representing task categories
- Four categories: General, Work, Personal, Shopping
- Conforms to `Codable` and `CaseIterable`
- Uses raw values for display

**Todo** - Main model representing a task
- Decorated with `@Model` macro for SwiftData persistence
- Properties:
  - `title`: String - Task description
  - `isDone`: Bool? - Completion status (optional)
  - `category`: TodoCategory - Task categorization
  - `priority`: TodoPriority - Task priority level
  - `dueDate`: Date? - Optional deadline
  - `createdAt`: Date - Timestamp of task creation
- Conforms to SwiftData's requirements
- Automatically persists to local database

### Screens

**TodoListScreen** - Main entry point and navigation hub
- Uses `NavigationStack` for hierarchical navigation
- Displays tasks via `TodoQueryListView`
- Navigation title: "My Tasks"
- Toolbar items:
  - Leading: Settings button (gear icon)
  - Trailing: Add task button (plus icon)
- Searchable interface with prompt "Search your tasks..."
- Animated search results
- Navigation destination configured for `Todo` model
- Accesses `modelContext` via `@Environment`

**AddTodoScreen** - Form for creating new tasks
- Form-based layout with multiple sections
- Text editor for task title (130pt height)
- Autocorrection disabled for better UX
- Inline pickers for:
  - Priority selection (automatic picker style)
  - Category selection (automatic picker style)
- Due date section with:
  - Toggle for optional due date
  - Date picker with minimum date validation (Date()...)
- Form validation:
  - Title cannot be empty or whitespace-only
  - Save button disabled when form is invalid
- Visual styling:
  - Brown-tinted section backgrounds (0.2 opacity)
  - Blue-tinted screen background (0.1 opacity)
  - Scrollable content with hidden default background
- Navigation bar:
  - Title: "Add Task" (inline display mode)
  - Trailing button: "Save" (disabled when invalid)
- Automatic keyboard dismissal on scroll
- Inserts new Todo into context and saves
- Dismisses view on successful save
- Uses `@Environment(\.dismiss)` for navigation dismissal
- Uses `@Environment(\.modelContext)` for data persistence

**TodoDetailScreen** - Form for updating existing tasks
- Nearly identical layout to AddTodoScreen
- Pre-populates form with existing task data via `onAppear`
- Additional "Is done" section:
  - Toggle for marking task completion
  - Footer message when task is marked done
  - Green-tinted toggle (0.5 opacity)
- Navigation bar:
  - Title: "Update Task" (inline display mode)
  - Trailing button: "Update" (disabled when invalid)
- Updates Todo properties in-place
- Saves changes to context
- Dismisses view on successful update
- Receives `todo` parameter for context

### Views

**TodoQueryListView** - Dynamic list view with filtering and sorting
- Uses `@Query` macro for reactive data fetching
- Custom initializer with search functionality:
  - Filters todos by title using `localizedStandardContains`
  - Sorts by `dueDate` in forward order
  - Uses `#Predicate` macro for type-safe filtering
- List row display:
  - Title (limited to 1 line)
  - Priority label with color-coded value
  - Due date (formatted, or "No due date")
  - Status indicators:
    - Done: Green checkmark circle
    - Expired: Red exclamation circle
    - In progress: Running figure icon
- Swipe actions:
  - Delete button (trailing edge)
  - Red-tinted with trash icon
  - Full swipe disabled for safety
  - Immediately deletes from context
- Row styling:
  - Brown-tinted backgrounds (0.2 opacity)
  - Custom insets (8pt vertical, 15pt horizontal)
  - Configurable row spacing via @AppStorage
- Navigation integration:
  - Rows wrapped in NavigationLink
  - Disabled for expired tasks
- Background styling:
  - Hidden scroll content background
  - Blue-tinted background (0.1 opacity)

**SettingsView** - Application settings and preferences
- Form-based layout with two sections
- Design - Rows section:
  - Toggle for list row spacing
  - Blue-tinted toggle (0.5 opacity)
- Design - Appearance section:
  - Toggle for dark/light mode
  - Dynamic label based on current mode
  - Blue-tinted toggle (0.5 opacity)
- Uses `@AppStorage` for persistent settings:
  - `isListRowSpacing`: Bool (default: false)
  - `isDarkOn`: Bool (default: false)
- Navigation title: "Settings"
- Visual styling:
  - Brown-tinted section backgrounds (0.2 opacity)
  - Blue-tinted screen background (0.1 opacity)
  - Hidden scroll content background
- Applies `preferredColorScheme` based on isDarkOn setting

### SwiftData Integration

**Persistence Layer**
- Model container configured in `TodoManagerApp`
- `.modelContainer(for: Todo.self)` creates persistent store
- Automatic schema migration
- Local SQLite database storage
- `@Environment(\.modelContext)` provides context to views
- CRUD operations via ModelContext:
  - Create: `context.insert(newTodo)`
  - Read: `@Query` macro with predicates
  - Update: Direct property modification
  - Delete: `context.delete(todo)`
- Manual save with error handling: `try context.save()`

**Query System**
- `@Query` macro for reactive data fetching
- Dynamic predicates for filtering
- Sort descriptors for ordering
- Automatic UI updates on data changes
- Type-safe predicates using `#Predicate` macro

### State Management

- `@State` for local view state (form inputs, toggles)
- `@Environment(\.modelContext)` for SwiftData context
- `@Environment(\.dismiss)` for programmatic view dismissal
- `@Query` for reactive data binding
- `@AppStorage` for persistent user preferences
- `@Model` macro for SwiftData models
- State-based form validation with computed properties
- Automatic UI updates via SwiftData observation

## Technologies

- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Apple's native persistence framework
- **NavigationStack** - Type-safe hierarchical navigation
- **@Query** - Reactive data fetching with predicates
- **@Model** - SwiftData model declaration
- **ModelContext** - SwiftData context for CRUD operations
- **@AppStorage** - Persistent user preferences via UserDefaults
- **@Predicate** - Type-safe query filtering
- **Form** - SwiftUI form components for data entry
- **SearchableModifier** - Built-in search functionality
- **Swipe Actions** - Gesture-based interactions
- **DatePicker** - Native date selection with validation
- **TextEditor** - Multi-line text input

## Data Persistence

This application uses **SwiftData** for local data persistence:

- All tasks are stored in a local SQLite database
- No backend server or network connection required
- Data persists across app launches
- Automatic schema migration
- Type-safe queries with `@Query` and predicates
- Reactive UI updates when data changes


## Key Features Explained

### Priority System
Tasks can be assigned three priority levels, each with distinct visual indicators:
- **Low Priority**: Blue color (0.7 opacity)
- **Medium Priority**: Orange color (0.7 opacity)
- **High Priority**: Red color (0.7 opacity)

### Category System
Organize tasks into four categories:
- **General**: Default category for miscellaneous tasks
- **Work**: Professional and work-related tasks
- **Personal**: Personal errands and activities
- **Shopping**: Shopping lists and purchase reminders

### Due Date Management
- Optional due dates for flexible task management
- Date picker prevents selection of past dates for new tasks
- Automatic expired task detection
- Visual indicators for expired tasks (red exclamation)
- Expired tasks are disabled in the list to prevent editing

### Task Completion
- Optional "isDone" status for task completion
- Visual confirmation with green checkmark
- Footer message when marking task as done
- Completed tasks remain visible for reference

### Search Functionality
- Real-time search across task titles
- Case-insensitive, locale-aware matching
- Animated search results
- Maintains sort order during search

### Settings & Customization
- Toggle dark/light mode preference
- Adjust list row spacing for density preference
- Settings persist across app launches via @AppStorage

## Form Validation

Both add and edit screens include validation:
- Title cannot be empty
- Title is trimmed of whitespace before saving
- Save/Update button disabled when form is invalid
- Visual feedback for required fields

## Requirements

- **iOS 26.0+**
- **Xcode 26.0+**
- **Swift 6.0+**
- No internet connection required (fully offline)

## Getting Started

1. Open the project in Xcode 26
2. Select your target device or simulator
3. Build and run (⌘R)
4. Start adding your tasks!
