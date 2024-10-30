// views/add_diary_entry.dart
import 'package:flutter/material.dart';
import '../models/travel_diary_model.dart';
import '../services/firestore_service.dart';

class AddDiaryEntry extends StatefulWidget {
  final TravelDiary? entry;

  const AddDiaryEntry({Key? key, this.entry}) : super(key: key);

  @override
  _AddDiaryEntryState createState() => _AddDiaryEntryState();
}

class _AddDiaryEntryState extends State<AddDiaryEntry> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String location;
  late String description;

  // Crie uma instância do FirestoreService
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    title = widget.entry?.title ?? '';
    location = widget.entry?.location ?? '';
    description = widget.entry?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Adicionar Entrada' : 'Editar Entrada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Título'),
                onSaved: (val) => title = val!,
              ),
              TextFormField(
                initialValue: location,
                decoration: InputDecoration(labelText: 'Localização'),
                onSaved: (val) => location = val!,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Descrição'),
                onSaved: (val) => description = val!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final entry = TravelDiary(
                      id: widget.entry?.id,
                      title: title,
                      location: location,
                      description: description,
                    );
                    // Adiciona ou atualiza a entrada sem usar o provider
                    if (widget.entry == null) {
                      await firestoreService.addDiaryEntry(entry);
                    } else {
                      await firestoreService.updateDiaryEntry(entry);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.entry == null ? 'Adicionar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
