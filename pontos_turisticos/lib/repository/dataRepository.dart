import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pontos_turisticos/models/pontos_turisticos.dart';

class DataRepository {
  final CollectionReference collection =
      Firestore.instance.collection('pontos');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addPontoTuristico(PontosTuristicos pts) {
    return collection.add(pts.toJson());
  }

  updatePontoTuristico(PontosTuristicos pts) async {
    await collection
        .document(pts.reference.documentID)
        .updateData(pts.toJson());
  }
}
