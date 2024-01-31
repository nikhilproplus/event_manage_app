import 'package:event_manage_app/database/database.dart';
import 'package:event_manage_app/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventController extends GetxController {
  //vaidate key
  final formKey = GlobalKey<FormState>();
  //eventlist
  RxList<EventModel> eventModel = <EventModel>[].obs;
  var isDataLoading = false.obs;
  DateTime? selectedDateTime;

   eventControllerToDate(String formattedDate) {
    selectedDateTime = reverseSelectedDate(formattedDate);
  }


  DateTime? reverseSelectedDate(String formattedDate) {
    try {
      // Parse the formatted date using the same date format
      return DateFormat('dd/MM/yyyy').parse(formattedDate);
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController createDateController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();

  void loadEvents() async {
    isDataLoading.value = true;
    try {
      List<EventModel> eventsNew = [];

      eventsNew = await Database().getEvents();

      eventModel.clear();
      eventModel.addAll(eventsNew);
    } finally {
      isDataLoading.value = false;
    }
  }

  void onCreateEvent() {
    try {
      String dateText = eventDateController.text;
      DateTime eventDate = DateFormat("dd/MM/yyyy").parse(dateText);
      String uniqueKey = DateTime.now().millisecondsSinceEpoch.toString();
      eventModel.add(EventModel(
          key: uniqueKey,
          title: titleController.text,
          description: descriptionController.text,
          createDate: null,
          eventDate: eventDate));
      Database().saveEvent(eventModel);
      clearControllers();
    } catch (e) {
      debugPrint("Error creaing event $e");
    }
  }

  void onEditEvent(String key, String newEventDate) {
    try {
      int index = eventModel.indexWhere((event) => event.key == key);
      if (index >= 0) {
        DateTime eventDate = DateFormat("dd/MM/yyyy").parse(newEventDate);

        EventModel updatedEvent = EventModel(
          key: key,
          title: eventModel[index].title,
          description: eventModel[index].description,
          createDate: eventModel[index].createDate,
          eventDate: eventDate,
        );

        eventModel[index] = updatedEvent;
        Database().saveEvent([updatedEvent]);
      }
    } catch (e) {
      debugPrint("Error parsing date: $e");
    }
  }

  onDeleteEvent(index) {
    try {
      String deletedKey = eventModel[index].key;
      eventModel.removeAt(index);
      Database().deleteEvent(deletedKey);
    } catch (e) {
      debugPrint("Error deleting event: $e");
    }
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    statusController.clear();
    createDateController.clear();
    eventDateController.clear();
  }
}
