import 'package:event_manage_app/controller/controller.dart';
import 'package:event_manage_app/view/widgets/event_button.dart';
import 'package:event_manage_app/view/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventCreateDialog extends StatelessWidget {
  final VoidCallback onPressed;
 

  const EventCreateDialog({
    super.key,
    required this.onPressed,
    
  });

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.put(EventController());

    return AlertDialog(
      title: const Text('Create Event'),
      content: SingleChildScrollView(
        child: Form(
          key: eventController.formKey,
          child: Column(
            children: [
              InputTextFieldWidget(
                eventController.titleController,
                'Event Title',
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill the field';
                  }
                  return null;
                },
              ),
              InputTextFieldWidget(
                eventController.descriptionController,
                'Event Description',
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill the field';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
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
                    return 'Please select a date';
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
              onPressed();
              Get.snackbar('Event created', 'Event added successfully',
                  colorText: Colors.white, backgroundColor: Colors.green);
            } else {
              Get.snackbar('fill all data', 'all fields are required',
                  colorText: Colors.white, backgroundColor: Colors.red);
            }
          },
          child: const Text(
            'Create event',
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
