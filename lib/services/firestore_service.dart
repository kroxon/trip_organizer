import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/models/checklist_item.dart';
import 'package:trip_organizer/models/trip_point.dart';

class FirestoreService {
  final CollectionReference tripsCollection =
      FirebaseFirestore.instance.collection('trips');
  final BuildContext context;

  FirestoreService(this.context);

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<String?> addTrip(Trip trip) async {
    try {
      final docRef = await tripsCollection.add({
        'title': trip.title,
        'checklist': trip.checklist.map((item) => _checklistItemToMap(item)).toList(),
        'tripPoints': trip.tripPoints.map((point) => _tripPointToMap(point)).toList(),
        'archived': trip.archived,
      });
      return docRef.id;
    } catch (e) {
      _showError('Failed to add trip: $e');
      return null;
    }
  }

  Future<bool> deleteTrip(String tripId) async {
    try {
      await tripsCollection.doc(tripId).delete();
      return true;
    } catch (e) {
      _showError('Failed to delete trip: $e');
      return false;
    }
  }

  Future<bool> updateTrip(String tripId, Trip updatedTrip) async {
    try {
      await tripsCollection.doc(tripId).update({
        'title': updatedTrip.title,
        'checklist': updatedTrip.checklist.map((item) => _checklistItemToMap(item)).toList(),
        'tripPoints': updatedTrip.tripPoints.map((point) => _tripPointToMap(point)).toList(),
        'archived': updatedTrip.archived,
      });
      return true;
    } catch (e) {
      _showError('Failed to update trip: $e');
      return false;
    }
  }

  Future<Trip?> getTrip(String tripId) async {
    try {
      final DocumentSnapshot doc = await tripsCollection.doc(tripId).get();
      if (!doc.exists) {
        _showError('Trip not found: $tripId');
        return null;
      }
      return _tripFromDocument(doc);
    } catch (e) {
      _showError('Failed to get trip: $e');
      return null;
    }
  }

  Stream<List<Trip>> getAllTrips() {
    return tripsCollection.snapshots().map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) => _tripFromDocument(doc))
            .where((trip) => trip != null)
            .cast<Trip>()
            .toList();
      } catch (e) {
        _showError('Error getting all trips: $e');
        return <Trip>[];
      }
    });
  }

  Map<String, dynamic> _checklistItemToMap(ChecklistItem item) {
    return {
      'name': item.name,
      'isChecked': item.isChecked,
    };
  }

  Map<String, dynamic>? _tripPointToMap(TripPoint point) {
    try {
      return {
        'name': point.tripPointLocation.place,
        'latitude': point.tripPointLocation.latitude,
        'longitude': point.tripPointLocation.longitude,
        'startDate': Timestamp.fromDate(point.startDate),
        'endDate': point.endDate != null ? Timestamp.fromDate(point.endDate!) : null,
      };
    } catch (e) {
      _showError('Error converting trip point to map: $e');
      return null;
    }
  }

  Trip? _tripFromDocument(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) {
        _showError('Document data is null for id: ${doc.id}');
        return null;
      }

      return Trip(
        title: data['title'] as String? ?? '',
        checklist: (data['checklist'] as List<dynamic>?)
                ?.map((item) => ChecklistItem(
                      name: (item['name'] as String?) ?? '',
                      isChecked: item['isChecked'] as bool? ?? false,
                    ))
                .toList() ??
            [],
        tripPoints: (data['tripPoints'] as List<dynamic>?)
                ?.map((point) => TripPoint(
                      tripPointLocation: TripPointLocation(
                        latitude: (point['latitude'] as num?)?.toDouble() ?? 0.0,
                        longitude: (point['longitude'] as num?)?.toDouble() ?? 0.0,
                        place: (point['name'] as String?) ?? '',
                      ),
                      startDate: ((point['startDate'] as Timestamp?)?.toDate()) ?? DateTime.now(),
                      endDate: (point['endDate'] as Timestamp?)?.toDate(),
                    ))
                .toList() ??
            [],
        archived: data['archived'] as bool? ?? false,
      );
    } catch (e) {
      _showError('Failed to parse trip document ${doc.id}: $e');
      return null;
    }
  }
}