import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trip_organizer/models/trip.dart';
import 'package:trip_organizer/models/checklist_item.dart';
import 'package:trip_organizer/models/trip_point.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final BuildContext context;

  FirestoreService(this.context);

  CollectionReference get _tripsCollection {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('No authenticated user');
    }
    return _firestore.collection('users').doc(userId).collection('trips');
  }

  Future<String?> addTrip(Trip trip) async {
    try {
      String? tripId;

      await _firestore.runTransaction((transaction) async {
        final tripDoc = _tripsCollection.doc();
        tripId = tripDoc.id;

        transaction.set(tripDoc, {
          'title': trip.title,
          'archived': trip.archived,
        });

        for (var item in trip.checklist) {
          final checklistDoc = tripDoc.collection('checklist').doc();
          transaction.set(checklistDoc, _checklistItemToMap(item));
        }

        for (var point in trip.tripPoints) {
          final tripPointDoc = tripDoc.collection('tripPoints').doc();
          transaction.set(tripPointDoc, _tripPointToMap(point));
        }
      });

      return tripId;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateTrip(String tripId, Trip updatedTrip) async {
    try {
      final tripDoc = _tripsCollection.doc(tripId);

      await tripDoc.update({
        'title': updatedTrip.title,
        'archived': updatedTrip.archived,
      });

      final checklistCollection = tripDoc.collection('checklist');
      final checklistSnapshot = await checklistCollection.get();
      for (var doc in checklistSnapshot.docs) {
        await doc.reference.delete();
      }
      for (var item in updatedTrip.checklist) {
        await checklistCollection.add(_checklistItemToMap(item));
      }

      final tripPointsCollection = tripDoc.collection('tripPoints');
      final tripPointsSnapshot = await tripPointsCollection.get();
      for (var doc in tripPointsSnapshot.docs) {
        await doc.reference.delete();
      }
      for (var point in updatedTrip.tripPoints) {
        await tripPointsCollection.add(_tripPointToMap(point));
      }
    } catch (e) {
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      final tripDoc = _tripsCollection.doc(tripId);

      final checklistSnapshot = await tripDoc.collection('checklist').get();
      for (var doc in checklistSnapshot.docs) {
        await doc.reference.delete();
      }

      final tripPointsSnapshot = await tripDoc.collection('tripPoints').get();
      for (var doc in tripPointsSnapshot.docs) {
        await doc.reference.delete();
      }

      await tripDoc.delete();
    } catch (e) {
    }
  }

  Future<Trip?> getTrip(String tripId) async {
    try {
      final tripDoc = _tripsCollection.doc(tripId);
      final tripSnapshot = await tripDoc.get();

      if (!tripSnapshot.exists) {
        return null;
      }

      final checklistSnapshot = await tripDoc.collection('checklist').get();
      final checklist = checklistSnapshot.docs.map((doc) {
        final data = doc.data();
        return ChecklistItem(
          name: data['name'] as String,
          isChecked: data['isChecked'] as bool? ?? false,
        );
      }).toList();

      final tripPointsSnapshot = await tripDoc.collection('tripPoints').get();

      final tripPoints = tripPointsSnapshot.docs.map((doc) {
        final data = doc.data();

        return TripPoint(
          id: doc.id, 
          tripPointLocation: TripPointLocation(
            latitude: data['latitude'] as double,
            longitude: data['longitude'] as double,
            place: data['name'] as String,
          ),
          startDate: (data['startDate'] as Timestamp).toDate(),
          endDate: (data['endDate'] as Timestamp?)?.toDate(),
          notes: data['notes'] as String?, 
        );
      }).toList();

      final data = tripSnapshot.data() as Map<String, dynamic>;

      return Trip(
        id: tripId,
        title: data['title'] as String,
        checklist: checklist,
        tripPoints: tripPoints,
        archived: data['archived'] as bool? ?? false,
      );
    } catch (e) {
      return null;
    }
  }

  Stream<List<Trip>> getAllTrips() {
    return _tripsCollection.snapshots().asyncMap((snapshot) async {
      try {
        final trips = <Trip>[];
        for (var doc in snapshot.docs) {
          final trip = await getTrip(doc.id);
          if (trip != null) {
            trips.add(trip);
          }
        }
        trips.sort((a, b) {
          if (a.tripPoints.isEmpty && b.tripPoints.isEmpty) {
            return 0;
          } else if (a.tripPoints.isEmpty) {
            return 1;
          } else if (b.tripPoints.isEmpty) {
            return -1;
          } else {
            return a.tripPoints.first.startDate
                .compareTo(b.tripPoints.first.startDate);
          }
        });
        return trips;
      } catch (e) {
        return <Trip>[];
      }
    });
  }

  Future<String?> addTripPoint(String tripId, TripPoint tripPoint) async {
    try {
      if (tripId.isEmpty) {
        return null;
      }
      final tripPointsCollection =
          _tripsCollection.doc(tripId).collection('tripPoints');
      final docRef = await tripPointsCollection.add(_tripPointToMap(tripPoint));
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateTripPoint(
      String tripId, String pointId, TripPoint updatedPoint) async {
    try {
      final pointRef =
          _tripsCollection.doc(tripId).collection('tripPoints').doc(pointId);

      await pointRef.update(_tripPointToMap(updatedPoint));
    } catch (e) {
    }
  }

  Future<void> deleteTripPoint(String tripId, String pointId) async {
    try {
      await _tripsCollection
          .doc(tripId)
          .collection('tripPoints')
          .doc(pointId)
          .delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting trip point: $e'),
        ),
      );
    }
  }

  Stream<List<TripPoint>> getTripPoints(String tripId) {
    final tripPointsCollection =
        _tripsCollection.doc(tripId).collection('tripPoints');
    return tripPointsCollection.snapshots().map((snapshot) {
      final tripPoints = snapshot.docs.map((doc) {
        final data = doc.data();
        return TripPoint(
          id: doc.id,
          tripPointLocation: TripPointLocation(
            latitude: data['latitude'] as double,
            longitude: data['longitude'] as double,
            place: data['name'] as String,
          ),
          startDate: (data['startDate'] as Timestamp).toDate(),
          endDate: (data['endDate'] as Timestamp?)?.toDate(),
        );
      }).toList();

      tripPoints.sort((a, b) => a.startDate.compareTo(b.startDate));
      return tripPoints;
    });
  }

  Map<String, dynamic> _checklistItemToMap(ChecklistItem item) {
    return {
      'name': item.name,
      'isChecked': item.isChecked,
    };
  }

  Map<String, dynamic> _tripPointToMap(TripPoint point) {
    return {
      'name': point.tripPointLocation.place,
      'latitude': point.tripPointLocation.latitude,
      'longitude': point.tripPointLocation.longitude,
      'startDate': Timestamp.fromDate(point.startDate),
      'endDate':
          point.endDate != null ? Timestamp.fromDate(point.endDate!) : null,
    };
  }
}
