// services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/travel_diary_model.dart';

class FirestoreService {
  final CollectionReference diaryCollection =
  FirebaseFirestore.instance.collection('diaryEntries');

  // Criar uma nova entrada
  Future<void> addDiaryEntry(TravelDiary diary) async {
    await diaryCollection.add(diary.toMap());
  }

  // Ler todas as entradas
  Stream<List<TravelDiary>> getDiaryEntries() {
    return diaryCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => TravelDiary.fromDocumentSnapshot(doc))
        .toList());
  }

  // Atualizar uma entrada existente
  Future<void> updateDiaryEntry(TravelDiary diary) async {
    await diaryCollection.doc(diary.id).update(diary.toMap());
  }

  // Excluir uma entrada
  Future<void> deleteDiaryEntry(String id) async {
    await diaryCollection.doc(id).delete();
  }
}
