---
name: clean-architecture-mobile-bounded-contexts
description: Implements Clean Architecture with Bounded Contexts for complex mobile apps with multiple features. Use when building multi-module apps where features are self-contained contexts with clear domain boundaries, shared kernels, and cross-context integration.
---

# Clean Architecture with Bounded Contexts

Implements Domain-Driven Design (DDD) Bounded Contexts pattern for complex mobile applications with multiple distinct features.

## When to Use This

- App has 3+ features with different domain languages (Auth, Payments, Analytics)
- Multiple sub-teams working on different features
- Features may become separate modules or apps later
- Need clear domain boundaries to reduce cognitive load

## Core Concepts

### Bounded Context

A self-contained module with its own:
- Domain language (entities, value objects, events)
- Application logic (use cases)
- Infrastructure (repositories, services)

**Analogy:** Think of contexts as separate microservices that happen to live in the same codebase. They don't reach into each other's databases.

### Shared Kernel

Common elements used by multiple contexts:
- Value objects (Money, Email, DateRange)
- Domain event base protocols
- Cross-cutting interfaces (Logger, EventBus)

**Rule:** Keep it minimal. If it's feature-specific, it doesn't belong here.

### Integration Layer

Explicit contracts for cross-context communication:
- Integration interfaces define what one context exposes to others
- Implementations live in Integration/, not in the contexts themselves
- Keeps contexts isolated while enabling cooperation

---

## Complete Example: E-Commerce App

Let's build an app with three contexts: **Auth**, **Catalog**, and **Orders**.

### 1. Shared Kernel (Cross-Cutting)

```swift
// SharedKernel/Domain/ValueObjects/Money.swift
struct Money: Codable, Sendable, Equatable {
    let amount: Decimal
    let currency: Currency
    
    enum Currency: String, Codable, Sendable {
        case usd, eur, gbp
    }
    
    func add(_ other: Money) -> Money {
        guard currency == other.currency else { fatalError("Currency mismatch") }
        return Money(amount: amount + other.amount, currency: currency)
    }
}

// SharedKernel/Domain/Events/DomainEvent.swift
protocol DomainEvent: Sendable {
    var eventId: UUID { get }
    var occurredAt: Date { get }
    var eventType: String { get }
}

extension DomainEvent {
    var eventId: UUID { UUID() }
    var occurredAt: Date { Date() }
}

// SharedKernel/Application/Interfaces/EventBus.swift
protocol EventBus: Sendable {
    func publish<T: DomainEvent>(_ event: T)
    func subscribe<T: DomainEvent>(
        _ eventType: T.Type,
        handler: @escaping (T) async -> Void
    ) -> Subscription
}
```

### 2. Auth Context (Bounded Context)

```swift
// Features/Auth/Domain/Entities/User.swift
struct User: Identifiable, Sendable {
    let id: UUID
    let email: Email
    let hashedPassword: String
    let createdAt: Date
    var lastLoginAt: Date?
    
    func recordLogin() -> User {
        var copy = self
        copy.lastLoginAt = Date()
        return copy
    }
}

// Features/Auth/Domain/ValueObjects/Email.swift
struct Email: Codable, Sendable, Equatable {
    let rawValue: String
    
    init?(_ value: String) {
        let trimmed = value.trimmingCharacters(in: .whitespaces).lowercased()
        guard trimmed.contains("@"), trimmed.contains(".") else { return nil }
        self.rawValue = trimmed
    }
}

// Features/Auth/Domain/Interfaces/AuthRepositoryProtocol.swift
protocol AuthRepositoryProtocol: Sendable {
    func findByEmail(_ email: Email) async throws -> User?
    func save(_ user: User) async throws
    func getCurrentSession() async throws -> Session?
}

// Features/Auth/Domain/Events/UserLoggedIn.swift
struct UserLoggedIn: DomainEvent {
    let userId: UUID
    let email: Email
    let eventType: String = "auth.user_logged_in"
}

// Features/Auth/Application/UseCases/LoginUseCase.swift
final class LoginUseCase: Sendable {
    private let repository: AuthRepositoryProtocol
    private let passwordHasher: PasswordHasher
    private let eventBus: EventBus
    
    init(
        repository: AuthRepositoryProtocol,
        passwordHasher: PasswordHasher,
        eventBus: EventBus
    ) {
        self.repository = repository
        self.passwordHasher = passwordHasher
        self.eventBus = eventBus
    }
    
    func execute(email: String, password: String) async throws -> UserDTO {
        guard let emailVO = Email(email) else {
            throw AuthError.invalidEmail
        }
        
        guard let user = try await repository.findByEmail(emailVO) else {
            throw AuthError.invalidCredentials
        }
        
        guard passwordHasher.verify(password, against: user.hashedPassword) else {
            throw AuthError.invalidCredentials
        }
        
        // Record login
        let updatedUser = user.recordLogin()
        try await repository.save(updatedUser)
        
        // Publish domain event
        await eventBus.publish(UserLoggedIn(
            userId: user.id,
            email: emailVO
        ))
        
        return UserDTO(id: user.id, email: emailVO.rawValue)
    }
}

// Features/Auth/Application/DTOs/UserDTO.swift
struct UserDTO: Identifiable, Sendable {
    let id: UUID
    let email: String
}

// Features/Auth/Infrastructure/Repositories/KeychainAuthRepository.swift
final actor KeychainAuthRepository: AuthRepositoryProtocol {
    private let keychain: KeychainWrapper
    
    func findByEmail(_ email: Email) async throws -> User? {
        let data = try await keychain.data(forKey: email.rawValue)
        guard let data else { return nil }
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func save(_ user: User) async throws {
        let data = try JSONEncoder().encode(user)
        try await keychain.set(data, forKey: user.email.rawValue)
    }
    
    func getCurrentSession() async throws -> Session? {
        // Implementation...
        return nil
    }
}

// Features/Auth/Presentation/ViewModels/LoginViewModel.swift
@MainActor
@Observable
final class LoginViewModel {
    private let loginUseCase: LoginUseCase
    
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?
    var loggedInUser: UserDTO?
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        do {
            loggedInUser = try await loginUseCase.execute(
                email: email,
                password: password
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
```

### 3. Catalog Context (Bounded Context)

```swift
// Features/Catalog/Domain/Entities/Product.swift
struct Product: Identifiable, Sendable {
    let id: UUID
    let name: String
    let description: String
    let price: Money  // From SharedKernel
    let sku: SKU
    let category: Category
}

// Features/Catalog/Domain/ValueObjects/SKU.swift
struct SKU: Codable, Sendable, Equatable {
    let rawValue: String
    
    init?(_ value: String) {
        let pattern = /^[A-Z]{3}-\d{6}$/
        guard value.wholeMatch(of: pattern) != nil else { return nil }
        self.rawValue = value
    }
}

// Features/Catalog/Domain/Interfaces/ProductRepositoryProtocol.swift
protocol ProductRepositoryProtocol: Sendable {
    func getById(_ id: UUID) async throws -> Product?
    func search(query: String) async throws -> [Product]
    func getByCategory(_ category: Category) async throws -> [Product]
}

// Features/Catalog/Application/UseCases/GetProductDetailsUseCase.swift
final class GetProductDetailsUseCase: Sendable {
    private let repository: ProductRepositoryProtocol
    
    func execute(productId: UUID) async throws -> ProductDTO {
        guard let product = try await repository.getById(productId) else {
            throw CatalogError.productNotFound
        }
        return ProductDTO(
            id: product.id,
            name: product.name,
            price: product.price
        )
    }
}

// Features/Catalog/Application/DTOs/ProductDTO.swift
struct ProductDTO: Identifiable, Sendable {
    let id: UUID
    let name: String
    let price: Money  // SharedKernel value object
}
```

### 4. Orders Context (Bounded Context)

```swift
// Features/Orders/Domain/Entities/Order.swift
struct Order: Identifiable, Sendable {
    let id: UUID
    let customerId: UUID  // Reference to Auth context user
    let items: [OrderItem]
    let status: OrderStatus
    let createdAt: Date
    var total: Money { items.map { $0.subtotal }.reduce(Money.zero, +) }
    
    enum OrderStatus: String, Sendable {
        case pending, confirmed, shipped, delivered, cancelled
    }
}

// Features/Orders/Domain/Entities/OrderItem.swift
struct OrderItem: Sendable {
    let productId: UUID  // Reference to Catalog context product
    let quantity: Int
    let unitPrice: Money
    var subtotal: Money { unitPrice.multiplied(by: quantity) }
}

// Features/Orders/Domain/Events/OrderPlaced.swift
struct OrderPlaced: DomainEvent {
    let orderId: UUID
    let customerId: UUID
    let total: Money
    let itemCount: Int
    let eventType: String = "orders.order_placed"
}

// Features/Orders/Application/UseCases/PlaceOrderUseCase.swift
final class PlaceOrderUseCase: Sendable {
    private let orderRepository: OrderRepositoryProtocol
    private let productIntegration: CatalogIntegration  // Cross-context
    private let authIntegration: AuthIntegration        // Cross-context
    private let eventBus: EventBus
    
    init(
        orderRepository: OrderRepositoryProtocol,
        productIntegration: CatalogIntegration,
        authIntegration: AuthIntegration,
        eventBus: EventBus
    ) {
        self.orderRepository = orderRepository
        self.productIntegration = productIntegration
        self.authIntegration = authIntegration
        self.eventBus = eventBus
    }
    
    func execute(items: [OrderItemRequest]) async throws -> OrderDTO {
        // Get current customer (cross-context)
        let customerId = try await authIntegration.requireCurrentUserId()
        
        // Validate products exist and get prices (cross-context)
        var orderItems: [OrderItem] = []
        for item in items {
            let product = try await productIntegration.getProduct(item.productId)
            orderItems.append(OrderItem(
                productId: item.productId,
                quantity: item.quantity,
                unitPrice: product.price
            ))
        }
        
        // Create order
        let order = Order(
            id: UUID(),
            customerId: customerId,
            items: orderItems,
            status: .pending,
            createdAt: Date()
        )
        
        try await orderRepository.save(order)
        
        // Publish event
        await eventBus.publish(OrderPlaced(
            orderId: order.id,
            customerId: customerId,
            total: order.total,
            itemCount: items.count
        ))
        
        return OrderDTO(id: order.id, status: order.status, total: order.total)
    }
}

// Features/Orders/Application/DTOs/OrderDTO.swift
struct OrderDTO: Identifiable, Sendable {
    let id: UUID
    let status: Order.Status
    let total: Money
}
```

### 5. Integration Layer (Cross-Context Contracts)

```swift
// Integration/Interfaces/CatalogIntegration.swift
protocol CatalogIntegration: Sendable {
    func getProduct(_ id: UUID) async throws -> ProductSummary
    func validateProductsExist(_ ids: [UUID]) async throws -> Bool
}

struct ProductSummary: Sendable {
    let id: UUID
    let name: String
    let price: Money
    let isAvailable: Bool
}

// Integration/Interfaces/AuthIntegration.swift
protocol AuthIntegration: Sendable {
    func getCurrentUserId() async throws -> UUID?
    func requireCurrentUserId() async throws -> UUID
    func isAuthenticated() async -> Bool
}

// Integration/Implementations/CatalogIntegrationImpl.swift
final class CatalogIntegrationImpl: CatalogIntegration {
    private let productRepository: ProductRepositoryProtocol
    
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
    }
    
    func getProduct(_ id: UUID) async throws -> ProductSummary {
        guard let product = try await productRepository.getById(id) else {
            throw IntegrationError.productNotFound
        }
        return ProductSummary(
            id: product.id,
            name: product.name,
            price: product.price,
            isAvailable: true
        )
    }
    
    func validateProductsExist(_ ids: [UUID]) async throws -> Bool {
        for id in ids {
            guard try await productRepository.getById(id) != nil {
                return false
            }
        }
        return true
    }
}

// Integration/Implementations/AuthIntegrationImpl.swift
final class AuthIntegrationImpl: AuthIntegration {
    private let authRepository: AuthRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }
    
    func getCurrentUserId() async throws -> UUID? {
        let session = try await authRepository.getCurrentSession()
        return session?.userId
    }
    
    func requireCurrentUserId() async throws -> UUID {
        guard let userId = try await getCurrentUserId() else {
            throw IntegrationError.notAuthenticated
        }
        return userId
    }
    
    func isAuthenticated() async -> Bool {
        (try? await getCurrentUserId()) != nil
    }
}

// Integration/Errors/IntegrationError.swift
enum IntegrationError: Error, Sendable {
    case productNotFound
    case notAuthenticated
    case currencyMismatch
}
```

### 6. Event Handlers (Cross-Context Reactions)

```swift
// Features/Analytics/Application/EventHandlers/AuthEventHandler.swift
final class AuthEventHandler: Sendable {
    private let analytics: AnalyticsTracker
    
    init(analytics: AnalyticsTracker) {
        self.analytics = analytics
    }
    
    func handle(_ event: UserLoggedIn) async {
        await analytics.track("login", parameters: [
            "user_id": event.userId.uuidString,
            "method": "email"
        ])
    }
}

// Features/Analytics/Application/EventHandlers/OrdersEventHandler.swift
final class OrdersEventHandler: Sendable {
    private let analytics: AnalyticsTracker
    private let revenueTracker: RevenueTracker
    
    func handle(_ event: OrderPlaced) async {
        await analytics.track("purchase", parameters: [
            "order_id": event.orderId.uuidString,
            "value": event.total.amount,
            "currency": event.total.currency.rawValue,
            "items": event.itemCount
        ])
        
        await revenueTracker.record(event.total)
    }
}

// Setup in App/DIContainer.swift
final class DIContainer {
    let eventBus: EventBus
    let authEventHandler: AuthEventHandler
    let ordersEventHandler: OrdersEventHandler
    
    func setupEventSubscriptions() {
        eventBus.subscribe(UserLoggedIn.self) { [authEventHandler] event in
            await authEventHandler.handle(event)
        }
        
        eventBus.subscribe(OrderPlaced.self) { [ordersEventHandler] event in
            await ordersEventHandler.handle(event)
        }
    }
}
```

---

## Module Dependency Graph

```
App (DI Container, Navigation)
    ├── Features/Auth
    │       ├── Domain (pure)
    │       ├── Application (uses Domain, SharedKernel)
    │       ├── Infrastructure (implements Domain interfaces)
    │       └── Presentation (uses Application)
    │
    ├── Features/Catalog
    │       ├── Domain (pure)
    │       ├── Application (uses Domain, SharedKernel)
    │       ├── Infrastructure (implements Domain interfaces)
    │       └── Presentation (uses Application)
    │
    ├── Features/Orders
    │       ├── Domain (pure)
    │       ├── Application (uses Domain, SharedKernel, Integration)
    │       ├── Infrastructure (implements Domain interfaces)
    │       └── Presentation (uses Application)
    │
    ├── Integration
    │       ├── Interfaces (public contracts)
    │       └── Implementations (uses multiple Features)
    │
    └── SharedKernel
            └── Domain (cross-cutting value objects, events)
```

**Dependency Rules:**
1. Features can depend on SharedKernel
2. Features can depend on Integration interfaces
3. Features CANNOT depend on other Features directly
4. Integration can depend on multiple Features (it's the glue)
5. App shell wires everything together

---

## Common Patterns

### Pattern 1: Context Map (Documentation)

Document how contexts relate:

```markdown
## Context Map: E-Commerce App

### Auth Context
- **Language**: User, Session, Credentials, Login, Logout
- **Publishes**: UserLoggedIn, UserLoggedOut, SessionExpired
- **Subscribes**: (none)
- **Integrations Exposed**: AuthIntegration (user info, auth state)

### Catalog Context
- **Language**: Product, SKU, Category, Price, Inventory
- **Publishes**: ProductAdded, PriceChanged, OutOfStock
- **Subscribes**: (none)
- **Integrations Exposed**: CatalogIntegration (product lookup, search)

### Orders Context
- **Language**: Order, OrderItem, Cart, Checkout, Payment
- **Publishes**: OrderPlaced, OrderCancelled, PaymentFailed
- **Subscribes**: UserLoggedIn (clear guest cart), ProductPriceChanged
- **Integrations Consumed**: AuthIntegration, CatalogIntegration
```

### Pattern 2: Anti-Corruption Layer

When integrating with legacy/external systems:

```swift
// Integration/ExternalPaymentGateway/ExternalPaymentACL.swift
protocol PaymentGatewayACL: Sendable {
    func charge(amount: Money, token: PaymentToken) async throws -> PaymentResult
}

// Translates our domain language to external API language
final class StripeACL: PaymentGatewayACL {
    private let stripeClient: StripeClient
    
    func charge(amount: Money, token: PaymentToken) async throws -> PaymentResult {
        // Translate domain Money to Stripe's smallest currency unit
        let amountInCents = Int(amount.amount * 100)
        
        let stripeCharge = try await stripeClient.charges.create([
            "amount": amountInCents,
            "currency": amount.currency.rawValue,
            "source": token.rawValue
        ])
        
        // Translate Stripe result back to our domain
        return PaymentResult(
            success: stripeCharge.status == "succeeded",
            transactionId: stripeCharge.id,
            failureReason: stripeCharge.failureMessage
        )
    }
}
```

### Pattern 3: Saga Pattern (Distributed Transactions)

For operations across multiple contexts:

```swift
// Integration/Sagas/OrderPlacementSaga.swift
final actor OrderPlacementSaga {
    private let orderUseCase: PlaceOrderUseCase
    private let paymentUseCase: ProcessPaymentUseCase
    private let inventoryUseCase: ReserveInventoryUseCase
    private let eventBus: EventBus
    
    func execute(orderRequest: OrderRequest) async throws -> OrderResult {
        // Step 1: Reserve inventory
        let reservation = try await inventoryUseCase.reserve(
            items: orderRequest.items
        )
        
        do {
            // Step 2: Place order
            let order = try await orderUseCase.execute(items: orderRequest.items)
            
            // Step 3: Process payment
            let payment = try await paymentUseCase.process(
                orderId: order.id,
                amount: order.total
            )
            
            // Success - publish composite event
            await eventBus.publish(OrderFullyProcessed(
                orderId: order.id,
                paymentId: payment.id
            ))
            
            return OrderResult.success(order)
            
        } catch {
            // Compensating action: release inventory reservation
            try? await inventoryUseCase.release(reservation.id)
            throw error
        }
    }
}
```

---

## Testing Strategy

### Within-Context Tests

```swift
// Features/Orders/Tests/Domain/OrderTests.swift
import Testing

struct OrderTests {
    @Test("calculates total correctly")
    func testTotalCalculation() {
        let order = Order.create(items: [
            OrderItem(productId: UUID(), quantity: 2, unitPrice: Money(amount: 10, currency: .usd)),
            OrderItem(productId: UUID(), quantity: 1, unitPrice: Money(amount: 25, currency: .usd))
        ])
        
        #expect(order.total == Money(amount: 45, currency: .usd))
    }
}
```

### Cross-Context Integration Tests

```swift
// Integration/Tests/PlaceOrderIntegrationTests.swift
import Testing

struct PlaceOrderIntegrationTests {
    let container = TestDIContainer()
    
    @Test("places order with authenticated user")
    func testPlaceOrder() async throws {
        // Setup: Create user in Auth context
        let user = try await container.authUseCase.register(
            email: "test@example.com",
            password: "password123"
        )
        
        // Setup: Create product in Catalog context
        let product = try await container.catalogUseCase.addProduct(
            name: "Test Product",
            price: Money(amount: 99.99, currency: .usd)
        )
        
        // Execute: Place order in Orders context
        let order = try await container.ordersUseCase.place(
            customerId: user.id,
            items: [OrderItemRequest(productId: product.id, quantity: 1)]
        )
        
        // Verify
        #expect(order.customerId == user.id)
        #expect(order.total == Money(amount: 99.99, currency: .usd))
        
        // Verify event was published
        let events = await container.eventBus.publishedEvents
        #expect(events.contains { $0 is OrderPlaced })
    }
}
```

---

## Migration from Simple to Bounded Contexts

### Phase 1: Identify Boundaries

Map which entities belong to which features:

```swift
// Before: All in one place
Domain/
    User.swift          # Auth
    Product.swift       # Catalog
    Order.swift         # Orders

// After: Group by context (same files, new locations)
Features/
    Auth/Domain/User.swift
    Catalog/Domain/Product.swift
    Orders/Domain/Order.swift
```

### Phase 2: Extract Duplication

Identify common value objects, move to SharedKernel:
- Money (used by Catalog + Orders)
- Email (used by Auth + Orders shipping)
- DateRange, Address, etc.

### Phase 3: Add Integration Layer

Replace direct cross-context calls:

```swift
// Before
let user = authRepository.getCurrentUser()  // Direct access

// After
let userId = authIntegration.getCurrentUserId()  // Via integration
```

### Phase 4: Event-Driven Communication

Replace synchronous calls with events:

```swift
// Before
analytics.trackPurchase(order)  // Direct call

// After
eventBus.publish(OrderPlaced(...))  // Async, decoupled
```

---

## Key Takeaways

1. **Bounded contexts are about language boundaries** — if two features use "User" to mean different things, they belong in different contexts

2. **Integration layer is the contract** — it defines what a context exposes to the outside world

3. **Domain events decouple contexts** — contexts react to events, don't call each other directly

4. **Shared kernel is minimal** — resist the urge to put everything shared there

5. **Test within context boundaries** — mock integrations, not internal context details
