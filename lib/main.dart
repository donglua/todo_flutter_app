import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:todo_flutter_app/model/model.dart';
import 'package:todo_flutter_app/redux/reducers.dart';

import 'package:todo_flutter_app/viewmodel/viewmodel.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Store<AppState> store = Store<AppState>(
      appStateReducer,
      initialState: AppState.initialState(),
    );

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Todo App',
        theme: ThemeData.dark(),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter ToDo App"),
      ),
      body: StoreConnector<AppState, ItemViewModel>(
        converter: (Store<AppState> store) => ItemViewModel.create(store),
        builder: (BuildContext context, ItemViewModel viewModel) => Column(
          children: <Widget>[
            AddItemWidget(viewModel),
            Expanded(child: ItemListWidget(viewModel)),
            RemoveItemsButton(viewModel),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final ItemViewModel model;

  ItemListWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: model.items.map((Item item) => ListTile(
          title: Text(item.body),
          leading: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => model.onRemoveItem(item),
          ),
      )).toList(),
    );
  }

}

class RemoveItemsButton extends StatelessWidget {
  final ItemViewModel model;

  RemoveItemsButton(this.model);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Delete all Items"),
      onPressed: () => model.onRemoveItems(),
    );
  }
}

class AddItemWidget extends StatefulWidget {
  final ItemViewModel model;

  AddItemWidget(this.model);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: "Add an Item"),
      onSubmitted: (String s) {
        widget.model.onAddItem(s);
        controller.text = '';
      },
    );
  }
}