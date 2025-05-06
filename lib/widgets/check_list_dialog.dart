import 'package:flutter/material.dart';

class ChecklistAlertDialog extends StatefulWidget {
  const ChecklistAlertDialog({
    super.key,
    required this.items,
    required this.initialCheckedItems,
    required this.onChecklistChanged,
  });

  final List<String> items;
  final List<bool> initialCheckedItems;
  final Function(List<bool>) onChecklistChanged;

  @override
  State<ChecklistAlertDialog> createState() => _ChecklistAlertDialogState();
}

class _ChecklistAlertDialogState extends State<ChecklistAlertDialog> {
  late List<bool> _checkedItems;
  late List<String> _items;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkedItems = List<bool>.from(widget.initialCheckedItems);
    _items = List<String>.from(widget.items);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _items.add(_textController.text);
        _checkedItems.add(false);
        _textController.clear();
      });
      widget.onChecklistChanged(_checkedItems);
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _checkedItems.removeAt(index);
    });
    widget.onChecklistChanged(_checkedItems);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('List of things to take:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(_items[index]),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: theme.colorScheme.error,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.delete,
                        color: theme.colorScheme.onError,
                      ),
                    ),
                    onDismissed: (direction) => _removeItem(index),
                    child: CheckboxListTile(
                      title: Text(_items[index]),
                      value: _checkedItems[index],
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            _checkedItems[index] = value;
                          });
                          widget.onChecklistChanged(_checkedItems);
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Add new item',
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addItem,
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
          ),
          child: Text(
            'Cancel',
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.surface,
          ),
          child: Text(
            'OK',
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(_checkedItems);
          },
        ),
      ],
    );
  }
}
