import Foundation
import Combine

@MainActor
public final class MonetizationViewModel: ObservableObject {
    @Published public var plans: [SubscriptionPlanDTO] = []
    @Published public var selectedPlanId: String?
    @Published public var isLoading: Bool = false
    @Published public var isSubscribed: Bool = false
    
    private let getPlansUseCase: GetSubscriptionPlansUseCase
    private let subscribeUseCase: SubscribeUseCase
    
    public init(getPlansUseCase: GetSubscriptionPlansUseCase, subscribeUseCase: SubscribeUseCase) {
        self.getPlansUseCase = getPlansUseCase
        self.subscribeUseCase = subscribeUseCase
    }
    
    public func loadPlans() async {
        isLoading = true
        do {
            self.plans = try await getPlansUseCase.execute()
            self.selectedPlanId = plans.first(where: { $0.isPopular })?.id ?? plans.first?.id
        } catch {
            print("Error loading plans: \(error)")
        }
        isLoading = false
    }
    
    public func subscribe() async {
        guard let planId = selectedPlanId else { return }
        isLoading = true
        do {
            try await subscribeUseCase.execute(planId: planId)
            isSubscribed = true
        } catch {
            print("Error subscribing: \(error)")
        }
        isLoading = false
    }
}
