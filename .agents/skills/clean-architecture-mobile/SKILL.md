---
name: clean-architecture-mobile
description: Enforce Clean Architecture principles for mobile apps across iOS (Swift), Android (Kotlin), and Flutter. Use when creating or reviewing mobile app code that should follow layered architecture with proper dependency direction, use cases, and separation of concerns.
---

# Clean Architecture for Mobile

Enforces layered architecture with strict dependency rules for iOS, Android, and Flutter projects.

## Core Principle: The Dependency Rule

**Dependencies point inward only.**

```
Infrastructure -> Presentation -> Application -> Domain
```

Outer layers depend on inner layers. Inner layers know nothing of the outside world.

---

## Layer Structure

### Domain Layer (Innermost - Pure Business Logic)

| Platform | Structure | Rules |
|----------|-----------|-------|
| **iOS/Swift** | `Domain/Entities/`, `Domain/ValueObjects/`, `Domain/Interfaces/`, `Domain/Errors/` | No UIKit, no Foundation imports beyond basic types. `Sendable` conformance required. |
| **Android/Kotlin** | `domain/entity/`, `domain/valueobject/`, `domain/repository/` | No Android SDK imports. Pure Kotlin. |
| **Flutter/Dart** | `lib/domain/entities/`, `lib/domain/value_objects/`, `lib/domain/repositories/` | No flutter/material imports. Pure Dart. |

**Domain Rules:**
- Entities contain data + behavior (validation, business rules)
- Value Objects are immutable (equality based on values, not identity)
- Repository protocols/interfaces defined here, implemented elsewhere
- Domain errors are typed, not strings
- NO external dependencies (frameworks, DB, HTTP)

**Example - Entity (Multi-platform):**

```swift
// iOS/Swift
struct BlockedApp: Identifiable, Codable, Sendable {
    let id: UUID
    var name: String
    var isBlocked: Bool
    
    func shouldBeBlocked(at date: Date = .now) -> Bool {
        // Pure business logic
        guard isBlocked else { return false }
        return true
    }
    
    static func validate(name: String) -> Result<String, ValidationError> {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return .failure(.emptyName) }
        return .success(trimmed)
    }
}

// Android/Kotlin
data class BlockedApp(
    val id: UUID,
    val name: String,
    val isBlocked: Boolean
) {
    fun shouldBeBlocked(at: Instant = Instant.now()): Boolean {
        return isBlocked
    }
    
    companion object {
        fun validate(name: String): Result<String, ValidationError> {
            val trimmed = name.trim()
            return if (trimmed.isEmpty()) 
                Result.failure(ValidationError.EmptyName)
            else 
                Result.success(trimmed)
        }
    }
}

// Flutter/Dart
class BlockedApp {
  final String id;
  final String name;
  final bool isBlocked;
  
  BlockedApp({required this.id, required this.name, this.isBlocked = false});
  
  bool shouldBeBlocked({DateTime? at}) {
    if (!isBlocked) return false;
    return true;
  }
  
  static Result<String, ValidationError> validateName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return Result.error(ValidationError.emptyName);
    }
    return Result.ok(trimmed);
  }
}
```

---

### Application Layer (Orchestration)

| Platform | Structure | Rules |
|----------|-----------|-------|
| **iOS/Swift** | `Application/UseCases/`, `Application/DTOs/`, `Application/Mappers/` | Use cases are classes with `execute()` method. `Sendable` conformance. |
| **Android/Kotlin** | `domain/usecase/`, `domain/model/` (DTOs) | Use cases are classes with `operator fun invoke()`. |
| **Flutter/Dart** | `lib/application/usecases/`, `lib/application/dtos/` | Use cases are classes with `call()` or `execute()` method. |

**Use Case Rules:**
- One use case = one business operation
- Naming: `[Verb][Subject]UseCase` (e.g., `GetBlockedAppsUseCase`)
- Single public method: `execute()` (Swift), `invoke()` (Kotlin), `call()` (Dart)
- Orchestration only: fetch -> process -> save
- Input/Output: DTOs, never raw entities to presentation
- Dependencies injected via constructor

**Example - Use Case (Multi-platform):**

```swift
// iOS/Swift
final class GetBlockedAppsUseCase: Sendable {
    private let repository: BlockedAppRepositoryProtocol
    private let mapper: BlockedAppMapper
    
    init(repository: BlockedAppRepositoryProtocol, mapper: BlockedAppMapper) {
        self.repository = repository
        self.mapper = mapper
    }
    
    func execute() async throws -> [BlockedAppDTO] {
        let apps = try await repository.getAll()
        return mapper.toDTOs(apps)
    }
}

// Android/Kotlin
class GetBlockedAppsUseCase(
    private val repository: BlockedAppRepository,
    private val mapper: BlockedAppMapper
) {
    suspend operator fun invoke(): List<BlockedAppDTO> {
        return repository.getAll().map { mapper.toDTO(it) }
    }
}

// Flutter/Dart
class GetBlockedAppsUseCase {
  final BlockedAppRepository _repository;
  final BlockedAppMapper _mapper;
  
  GetBlockedAppsUseCase(this._repository, this._mapper);
  
  Future<List<BlockedAppDTO>> call() async {
    final apps = await _repository.getAll();
    return apps.map(_mapper.toDTO).toList();
  }
}
```

---

### Infrastructure Layer (External Concerns)

| Platform | Structure | Rules |
|----------|-----------|-------|
| **iOS/Swift** | `Infrastructure/Repositories/`, `Infrastructure/API/`, `Infrastructure/Persistence/` | Implements domain protocols. Handles platform-specific APIs. |
| **Android/Kotlin** | `data/repository/`, `data/remote/`, `data/local/` | Implements domain repository interfaces. |
| **Flutter/Dart** | `lib/infrastructure/repositories/`, `lib/infrastructure/services/` | Implements domain repository abstract classes. |

**Repository Rules:**
- Implements interface defined in Domain
- Maps between persistence models and domain entities
- Throws domain errors, not platform errors
- Handles external API failures and converts to domain errors

**Example - Repository Implementation:**

```swift
// iOS/Swift
final class UserDefaultsBlockedAppRepository: BlockedAppRepositoryProtocol, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let mapper: BlockedAppPersistenceMapper
    
    func getAll() async throws -> [BlockedApp] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        do {
            let persistenceModels = try decoder.decode([BlockedAppPersistenceModel].self, from: data)
            return mapper.toDomain(persistenceModels)
        } catch {
            throw DomainError.persistenceError("Failed to decode: \(error)")
        }
    }
}

// Android/Kotlin
class BlockedAppRepositoryImpl(
    private val prefs: SharedPreferences,
    private val mapper: BlockedAppPersistenceMapper
) : BlockedAppRepository {
    override suspend fun getAll(): List<BlockedApp> {
        val json = prefs.getString(KEY, null) ?: return emptyList()
        return try {
            val persistenceModels = gson.fromJson(json, Array<BlockedAppPersistenceModel>::class.java)
            persistenceModels.map { mapper.toDomain(it) }
        } catch (e: Exception) {
            throw DomainError.PersistenceError("Failed to decode: ${e.message}")
        }
    }
}

// Flutter/Dart
class BlockedAppRepositoryImpl implements BlockedAppRepository {
  final SharedPreferences _prefs;
  final BlockedAppPersistenceMapper _mapper;
  
  BlockedAppRepositoryImpl(this._prefs, this._mapper);
  
  @override
  Future<List<BlockedApp>> getAll() async {
    final json = _prefs.getString(_key);
    if (json == null) return [];
    try {
      final persistenceModels = jsonDecode(json) as List;
      return persistenceModels.map((m) => _mapper.toDomain(m)).toList();
    } catch (e) {
      throw DomainError.persistenceError('Failed to decode: $e');
    }
  }
}
```

---

### Presentation Layer (UI Logic)

| Platform | Structure | Rules |
|----------|-----------|-------|
| **iOS/Swift** | `UI/ViewModels/`, `Views/`, `Components/` | ViewModels use `@Observable` (Swift 6), `@MainActor`. Call use cases, no business logic. |
| **Android/Kotlin** | `presentation/viewmodel/`, `presentation/ui/` | ViewModels extend `ViewModel`, use `StateFlow`/`LiveData`. Call use cases. |
| **Flutter/Dart** | `lib/presentation/viewmodels/`, `lib/presentation/widgets/` | Use `ChangeNotifier`, `ValueNotifier`, or `flutter_bloc`. Call use cases. |

**ViewModel Rules:**
- Exposes UI state (loading, error, data)
- Calls use cases for actions
- NO business logic (no `if (order.total > 100)`)
- NO direct repository access
- Handles UI-specific concerns (navigation, dialogs)

**Example - ViewModel:**

```swift
// iOS/Swift
@MainActor
@Observable
final class HomeViewModel {
    private(set) var apps: [BlockedAppDTO] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    private let getBlockedAppsUseCase: GetBlockedAppsUseCase
    private let toggleBlockUseCase: ToggleBlockUseCase
    
    func loadApps() async {
        isLoading = true
        errorMessage = nil
        do {
            apps = try await getBlockedAppsUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func toggleBlock(appId: UUID) async {
        do {
            try await toggleBlockUseCase.execute(appId: appId)
            await loadApps()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

// Android/Kotlin
class HomeViewModel(
    private val getBlockedAppsUseCase: GetBlockedAppsUseCase,
    private val toggleBlockUseCase: ToggleBlockUseCase
) : ViewModel() {
    private val _apps = MutableStateFlow<List<BlockedAppDTO>>(emptyList())
    val apps: StateFlow<List<BlockedAppDTO>> = _apps.asStateFlow()
    
    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()
    
    fun loadApps() {
        viewModelScope.launch {
            _isLoading.value = true
            _apps.value = getBlockedAppsUseCase()
            _isLoading.value = false
        }
    }
    
    fun toggleBlock(appId: UUID) {
        viewModelScope.launch {
            toggleBlockUseCase(appId)
            loadApps()
        }
    }
}

// Flutter/Dart
class HomeViewModel extends ChangeNotifier {
  final GetBlockedAppsUseCase _getBlockedAppsUseCase;
  final ToggleBlockUseCase _toggleBlockUseCase;
  
  List<BlockedAppDTO> apps = [];
  bool isLoading = false;
  String? errorMessage;
  
  HomeViewModel(this._getBlockedAppsUseCase, this._toggleBlockUseCase);
  
  Future<void> loadApps() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      apps = await _getBlockedAppsUseCase();
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
  
  Future<void> toggleBlock(String appId) async {
    try {
      await _toggleBlockUseCase(appId);
      await loadApps();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
```

---

## DTOs and Mappers

**Rules:**
- DTOs bridge Application and Presentation layers
- DTOs contain UI-friendly data (formatted strings, icon names, colors)
- Mappers convert: Entity <-> DTO, Entity <-> Persistence Model
- Mappers are pure functions, no side effects
- One mapper class per entity type

**Example:**

```swift
// iOS/Swift
struct BlockedAppDTO: Identifiable, Sendable {
    let id: UUID
    let name: String
    let iconName: String  // SF Symbol
    let colorHex: String
    let isBlocked: Bool
    let formattedScreenTime: String
}

struct BlockedAppMapper: Sendable {
    func toDTO(_ entity: BlockedApp) -> BlockedAppDTO {
        BlockedAppDTO(
            id: entity.id,
            name: entity.name,
            iconName: mapIcon(entity.name),
            colorHex: mapColor(entity.name),
            isBlocked: entity.isBlocked,
            formattedScreenTime: formatTime(entity.todayScreenTime)
        )
    }
    
    func toDTOs(_ entities: [BlockedApp]) -> [BlockedAppDTO] {
        entities.map { toDTO($0) }
    }
}
```

---

## Error Handling

**Layer Responsibilities:**

| Layer | Responsibility |
|-------|----------------|
| Infrastructure | Catch platform errors, throw domain errors |
| Application | Catch domain errors, decide retry/fail logic |
| Presentation | Catch errors, display UI error state |

**Domain Errors (defined in Domain layer):**

```swift
// iOS/Swift
enum DomainError: Error, Equatable, Sendable {
    case appNotFound(UUID)
    case validationFailed(ValidationError)
    case persistenceError(String)
    case operationFailed(String)
}

enum ValidationError: Error, Equatable, Sendable {
    case emptyName
    case invalidSchedule(String)
    case invalidTimeLimit
}

// Android/Kotlin
sealed class DomainError : Exception() {
    data class AppNotFound(val id: UUID) : DomainError()
    data class ValidationFailed(val error: ValidationError) : DomainError()
    data class PersistenceError(val message: String) : DomainError()
}

sealed class ValidationError {
    object EmptyName : ValidationError()
    data class InvalidSchedule(val reason: String) : ValidationError()
    object InvalidTimeLimit : ValidationError()
}
```

---

## Testing Strategy

| Layer | Test Type | Mock Strategy |
|-------|-----------|---------------|
| Domain | Unit tests | No mocks needed (pure logic) |
| Application | Unit tests | Mock repository interfaces |
| Infrastructure | Integration tests | Real dependencies (DB, API) |
| Presentation | Unit tests | Mock use cases |

---

## Anti-Patterns (NEVER DO)

1. **Bypassing Use Cases**: Calling repository directly from ViewModel/View
2. **Leaking Platform Types**: Returning UIKit/Android types from domain
3. **Framework in Domain**: Importing UIKit, Android SDK, Flutter in domain layer
4. **Business Logic in UI**: `if (order.total > 100)` in ViewModel
5. **Circular Dependencies**: Domain importing from Infrastructure
6. **String Errors**: Throwing raw strings instead of typed errors

---

## Directory Structure Summary

### iOS/Swift Project

```
MyApp/
├── Domain/
│   ├── Entities/
│   ├── ValueObjects/
│   ├── Interfaces/          # Repository protocols
│   └── Errors/
├── Application/
│   ├── UseCases/
│   ├── DTOs/
│   └── Mappers/
├── Infrastructure/
│   ├── Repositories/      # Protocol implementations
│   ├── Persistence/
│   └── API/
└── UI/
    ├── ViewModels/
    └── Views/
```

### Android/Kotlin Project

```
app/src/main/java/com/example/myapp/
├── domain/
│   ├── entity/
│   ├── valueobject/
│   ├── repository/        # Interfaces
│   ├── usecase/
│   ├── model/             # DTOs
│   └── error/
├── data/
│   ├── repository/        # Implementations
│   ├── local/
│   └── remote/
└── presentation/
    ├── viewmodel/
    └── ui/
```

### Flutter Project

```
lib/
├── domain/
│   ├── entities/
│   ├── value_objects/
│   ├── repositories/      # Abstract classes
│   └── errors/
├── application/
│   ├── usecases/
│   ├── dtos/
│   └── mappers/
├── infrastructure/
│   ├── repositories/      # Implementations
│   └── services/
└── presentation/
    ├── viewmodels/
    └── widgets/
```

---

## Quick Reference

| Concept | Swift | Kotlin | Dart |
|---------|-------|--------|------|
| Entity | `struct` | `data class` | `class` |
| Value Object | `struct` (immutable) | `data class` (immutable) | `@immutable` class |
| Repository Interface | `protocol` | `interface` | `abstract class` |
| Use Case | `class` with `execute()` | `class` with `invoke()` | `class` with `call()` |
| DTO | `struct` | `data class` | `class` |
| Mapper | `struct` with methods | `class` with methods | `class` with methods |
| Error | `enum : Error` | `sealed class` | `class implements Exception` |
| Concurrency | `async/await` | `suspend` | `async/await` |
| ViewModel | `@Observable @MainActor` | `ViewModel` | `ChangeNotifier` |
