import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:trip_organizer/models/trip_point.dart';
import 'package:trip_organizer/widgets/map_image.dart';

class PointOfTripScreen extends StatefulWidget {
  const PointOfTripScreen({super.key, this.tripPoint, required this.isEditing});

  final TripPoint? tripPoint;
  final bool isEditing;

  @override
  State<PointOfTripScreen> createState() {
    return _PointOfTripScreenState();
  }
}

class _PointOfTripScreenState extends State<PointOfTripScreen> {
  late bool _isEditing;
  final _destinationTextController = TextEditingController();
  final _notesTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  Key _autoCompleteKey = UniqueKey();
  TripPoint? _tripPoint;
  TripPointLocation? _tripPointLocation;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  void _presentDatePicker(String start) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2, now.month, now.day);
    final lastDate = DateTime(now.year + 5, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    setState(() {
      if (start == 'start') {
        _selectedStartDate = pickedDate;
      } else {
        _selectedEndDate = pickedDate;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _isEditing = widget.isEditing;

    if (widget.tripPoint != null) {
      _tripPoint = widget.tripPoint;
      _destinationTextController.text = _tripPoint!.tripPointLocation.place;
      _selectedStartDate = _tripPoint!.startDate;
      _selectedEndDate = _tripPoint!.endDate;
      _notesTextController.text = _tripPoint!.notes ?? '';
      _tripPointLocation = _tripPoint!.tripPointLocation;
    }
  }

  @override
  void dispose() {
    _destinationTextController.dispose();
    _notesTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');

    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (!_isEditing && widget.tripPoint != null) {
      _tripPoint = widget.tripPoint;
      content = Column(
        children: [
          const SizedBox(height: 20),
          Text(_tripPoint!.tripPointLocation.place,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
          const SizedBox(height: 20),
          MapImage(location: _tripPoint!.tripPointLocation),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start date',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color:
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                            )),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          formatter.format(_tripPoint!.startDate),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('End date',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          )),
                  SizedBox(height: 5),
                  if (_tripPoint!.endDate != null)
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          formatter.format(_tripPoint!.endDate!),
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (_tripPoint!.notes != null)
            Text(
              _tripPoint!.notes!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      );
    } else if (_isEditing) {
      content = Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            GooglePlacesAutoCompleteTextFormField(
              key: _autoCompleteKey,
              textEditingController: _destinationTextController,
              googleAPIKey: dotenv.env['YOUR_GOOGLE_API_KEY']!,
              decoration: InputDecoration(
                hintText: 'Enter your destination',
                labelText: 'Destination',
                prefixIcon: Icon(
                  Icons.search,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _destinationTextController.clear();
                    setState(() {
                      _autoCompleteKey = UniqueKey();
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
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
                setState(() {
                  _tripPointLocation = TripPointLocation(
                    place: prediction.description!,
                    latitude: double.parse(prediction.lat!),
                    longitude: double.parse(prediction.lng!),
                  );
                });
              },
              onSuggestionClicked: (Prediction prediction) =>
                  _destinationTextController.text = prediction.description!,
              minInputLength: 3,
            ),

            const SizedBox(height: 20),
            if (_tripPointLocation != null)
              MapImage(location: _tripPointLocation!),

            const SizedBox(height: 20),
            // button do usunięcia po testach
            // TextButton(
            //   onPressed: _onSubmit,
            //   child: const Text('Submit'),
            // ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start date',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                )),
                    Row(
                      children: [
                        Text(
                          _selectedStartDate == null
                              ? 'Select start date'
                              : formatter.format(_selectedStartDate!),
                        ),
                        IconButton(
                          onPressed: () => _presentDatePicker('start'),
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('End date',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                )),
                    Row(
                      children: [
                        Text(
                          _selectedEndDate == null
                              ? 'Select end date'
                              : formatter.format(_selectedEndDate!),
                        ),
                        IconButton(
                          onPressed: () => _presentDatePicker('end'),
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _notesTextController,
              maxLines: 5,
              minLines: 5,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Notes',
                labelText: 'Notes',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
          ]),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.tripPoint?.tripPointLocation.place ?? 'New Point of Trip'),
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
        body: content);
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.always);
      return;
    }
  }
}
