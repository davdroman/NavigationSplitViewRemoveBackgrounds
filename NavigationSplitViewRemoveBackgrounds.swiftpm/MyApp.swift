import NavigationTransitions
import SwiftUI
import SwiftUIIntrospect

@main
struct App: SwiftUI.App {
	var body: some Scene {
		WindowGroup {
			AppView()
		}
	}
}

struct Item: Hashable, Identifiable {
	let id = UUID()
	let name: String
}

struct AppView: View {
	@State var menuItems: [Item] = [.init(name: "hello"), .init(name: "world")]
	@State var selectedItem: Item?

	var body: some View {
		ZStack {
			Rectangle().fill(.blue.gradient).ignoresSafeArea() // this is a placeholder for your background night sky image
			NavigationSplitView {
				List(menuItems, selection: $selectedItem) { item in
					NavigationLink(value: item) {
						Text(item.name)
					}
					.listRowBackground(Color.clear)
				}
				.scrollContentBackground(.hidden)
				.navigationTransition(.slide)
			} detail: {
				if let selectedItem {
					Text(selectedItem.name)
				} else {
					Text("No item selected")
				}
			}
			.tint(.white)
			.introspect(.navigationSplitView, on: .iOS(.v17)) { split in
				let removeBackgrounds = {
					split.viewControllers.forEach { controller in
						controller.parent?.view.backgroundColor = .clear
						controller.view.clearBackgrounds()
					}
				}
				removeBackgrounds() // run now...
				DispatchQueue.main.async(execute: removeBackgrounds) // ... and on the next run loop pass
			}
		}
	}
}

extension UIView {
	fileprivate func clearBackgrounds() {
		backgroundColor = .clear
		for subview in subviews {
			subview.clearBackgrounds()
		}
	}
}
