import 'package:event_manage_app/controller/controller.dart';
import 'package:event_manage_app/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventEditScreen extends StatelessWidget {
  final String index;


  const EventEditScreen({
    super.key,
    required this.index, 
  });

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.put(EventController());

    return AlertDialog(
      title: const Text('Edit Event'),
      content: SingleChildScrollView(
        child: Form(
          key: eventController.formKey,
          child: Column(
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                controller: eventController.eventDateController,
                
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Select Event date',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45)),
                ),
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      eventController.eventDateController.text =
                          DateFormat('dd/MM/yyyy').format(selectedDate);
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill the field';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (eventController.formKey.currentState!.validate()) {
              eventController.onEditEvent(
                  index, eventController.eventDateController.text);
              eventController.clearControllers();
              Navigator.of(context).pop();
            } else {
              Get.snackbar('fill all data', 'all fields are required',
                  colorText: Colors.white, backgroundColor: Colors.red);
            }
          },
          child: const Text(
            'edit event',
            style: TextStyle(fontSize: 17),
          ),
        ),
        TextButton(
          onPressed: () {
            eventController.clearControllers();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel',
              style: TextStyle(fontSize: 17, color: Colors.red)),
        ),
      ],
    );
  }
}
