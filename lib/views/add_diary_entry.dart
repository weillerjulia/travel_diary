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

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    title = widget.entry?.title ?? '';
    location = widget.entry?.location ?? '';
    description = widget.entry?.description ?? '';
    rating = widget.entry?.rating ?? 0; // Se houver uma avaliação anterior
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Card(
        color: Color(0xFF999B85), // Cor do card (verde)
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            message,
            style: TextStyle(color: Colors.white), // Cor do texto
          ),
        ),
      ),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.fixed, // Mantém o card fixo
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Compartilhe as suas memórias' : 'Editar informações'),
        backgroundColor: Color(0xFFDDB7AC), // Cor de fundo do AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Permite rolagem se o teclado aparecer
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: title,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: TextStyle(color: Color(0xFF999B85)), // Cor do label
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDDB7AC)),
                    ),
                  ),
                  onSaved: (val) => title = val!,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Título é obrigatório';
                    }
                    return null; // Retorna null se a validação passar
                  },
                ),
                SizedBox(height: 16), // Espaçamento entre os campos
                TextFormField(
                  initialValue: location,
                  decoration: InputDecoration(
                    labelText: 'Local visitado',
                    labelStyle: TextStyle(color: Color(0xFF999B85)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDDB7AC)),
                    ),
                  ),
                  onSaved: (val) => location = val!,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Local é obrigatório';
                    }
                    return null; // Retorna null se a validação passar
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(
                    labelText: 'Descrição da experiência',
                    labelStyle: TextStyle(color: Color(0xFF999B85)),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDDB7AC)),
                    ),
                  ),
                  onSaved: (val) => description = val!,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Descrição é obrigatória';
                    }
                    return null; // Retorna null se a validação passar
                  },
                ),
                SizedBox(height: 20),
                Text('Avaliação:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < rating ? Icons.star : Icons.star_border,
                          color: Color(0xFF999B85),
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
                Center( // Centraliza o botão
                  child: ElevatedButton(
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
                          _showMessage("Salvo com sucesso!"); // Mensagem de sucesso
                        } else {
                          await firestoreService.updateDiaryEntry(entry);
                          _showMessage("Atualizado com sucesso!"); // Mensagem de sucesso
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.entry == null ? 'Adicionar' : 'Atualizar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDDB7AC), // Cor do botão
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
