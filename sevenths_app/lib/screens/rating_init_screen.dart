// lib/screens/rating_init_screen.dart

import 'package:flutter/material.dart';
import '../services/rating_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingInitScreen extends StatefulWidget {
  @override
  _RatingInitScreenState createState() => _RatingInitScreenState();
}

class _RatingInitScreenState extends State<RatingInitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ratingController = TextEditingController();
  bool _isDoubles = true;

  void _submitRating() async {
    if (_formKey.currentState!.validate()) {
      final rating = double.parse(_ratingController.text);
      final ratingService = RatingService();

      await ratingService.initializeRating(
        userId: FirebaseAuth.instance.currentUser!.uid,
        initialRating: rating,
        isDoubles: _isDoubles,
        source: 'DUPR Import',
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Import DUPR Rating')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ratingController,
                decoration: InputDecoration(
                  labelText: 'Current DUPR Rating',
                  helperText: 'Enter your rating from 1.0 to 7.0',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your rating';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 1.0 || rating > 7.0) {
                    return 'Rating must be between 1.0 and 7.0';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Rating Type'),
                subtitle: Text(_isDoubles ? 'Doubles' : 'Singles'),
                value: _isDoubles,
                onChanged: (value) => setState(() => _isDoubles = value),
              ),
              ElevatedButton(
                onPressed: _submitRating,
                child: Text('Import Rating'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
