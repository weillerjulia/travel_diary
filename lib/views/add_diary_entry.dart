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
  int rating = 0; // Adiciona um campo para a avaliação

  // Crie uma instância do FirestoreService
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    title = widget.entry?.title ?? '';
    location = widget.entry?.location ?? '';
    description = widget.entry?.description ?? '';
    rating = widget.entry?.rating ?? 0; // Se houver uma avaliação anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Compartilhe as suas memórias' : 'Editar informações'),
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
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Título é obrigatório';
                  }
                  return null; // Retorna null se a validação passar
                },
              ),
              TextFormField(
                initialValue: location,
                decoration: InputDecoration(labelText: 'Local visitado'),
                onSaved: (val) => location = val!,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Local é obrigatório';
                  }
                  return null; // Retorna null se a validação passar
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Descrição da experiência'),
                onSaved: (val) => description = val!,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Descrição é obrigatória';
                  }
                  return null; // Retorna null se a validação passar
                },
              ),
              SizedBox(height: 20),
              Text('Avaliação:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1; // A avaliação vai de 1 a 5
                      });
                    },
                  );
                }),
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
                      rating: rating, // Adiciona a avaliação ao objeto TravelDiary
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
