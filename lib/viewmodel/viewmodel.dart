import 'package:redux/redux.dart';

import 'package:todo_flutter_app/redux/actions.dart';
import 'package:todo_flutter_app/model/model.dart';

class ItemViewModel {
  final List<Item> items;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;

  ItemViewModel({
    this.items,
    this.onAddItem,
    this.onRemoveItem,
    this.onRemoveItems,
  });

  factory ItemViewModel.create(Store<AppState> store) {
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    return ItemViewModel(
      items: store.state.items,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: onRemoveItems,
    );
  }
}