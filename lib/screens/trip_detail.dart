import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key, this.trip, required this.isEditing});

  final Trip? trip;
  final bool isEditing;

  @override
  State<TripDetailScreen> createState() {
    return _TripDetailScreenState();
  }
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late bool _isEditing;
  final _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip?.title ?? 'New Trip'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing == true) Navigator.of(context).pop();
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: GooglePlacesAutoCompleteTextFormField(
                textEditingController: _textController,
                googleAPIKey: dotenv.env['YOUR_GOOGLE_API_KEY']!,
                decoration: const InputDecoration(
                  hintText: 'Enter your destination',
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.purple),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                maxLines: 1,
                overlayContainerBuilder: (child) => Material(
                  elevation: 1.0,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: child,
                ),
                onPlaceDetailsWithCoordinatesReceived: (prediction) {
                  print('placeDetails${prediction.lng}');
                },
                onSuggestionClicked: (Prediction prediction) =>
                    _textController.text = prediction.description!,
                minInputLength: 3,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: _onSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }

    print(_textController.text);
  }
}
