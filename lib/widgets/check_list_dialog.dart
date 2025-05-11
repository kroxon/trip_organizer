import 'package:flutter/material.dart';
import 'package:trip_organizer/models/checklist_item.dart';

class ChecklistAlertDialog extends StatefulWidget {
  const ChecklistAlertDialog({
    super.key,
    required this.checklistItems,
    required this.onChecklistChanged,
  });

  final List<ChecklistItem> checklistItems;
  final Function(List<ChecklistItem>) onChecklistChanged;

  @override
  State<ChecklistAlertDialog> createState() => _ChecklistAlertDialogState();
}

class _ChecklistAlertDialogState extends State<ChecklistAlertDialog> {
  late List<ChecklistItem> _items;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = List<ChecklistItem>.from(widget.checklistItems);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _items.add(ChecklistItem(name: _textController.text));
        _textController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'List of things to take:',
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
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
                    key: Key(_items[index].name),
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
                      title: Text(_items[index].name),
                      value: _items[index].isChecked,
                      activeColor: theme.colorScheme.onSurface,
                      checkColor: theme.colorScheme.surface,
                      onChanged: (bool? value) {
                        if (value != null) {
                          setState(() {
                            _items[index].isChecked = value;
                          });
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
                  ),
                  ),
                  style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: theme.colorScheme.onSurface,
                ),
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
            widget.onChecklistChanged(_items);
            Navigator.of(context).pop(_items);
          },
        ),
      ],
    );
  }
}
