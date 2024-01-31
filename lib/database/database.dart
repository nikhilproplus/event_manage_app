import 'dart:convert';

import 'package:event_manage_app/controller/controller.dart';
import 'package:event_manage_app/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  // List<EventModel> geteventDataList = [];
  final EventController eventController = Get.put(EventController());

//save data
  void saveEvent(List<EventModel> eventDataM) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Retrieve existing data
    List<String>? existingEventsEncoded =
        sharedPreferences.getStringList('eventdata');
    List<String> eventsEncoded = [];

    if (existingEventsEncoded != null) {
      // Decode existing events and check if an item with the same key exists
      List<EventModel> existingEvents = existingEventsEncoded
          .map((eventData) => EventModel.fromJson(jsonDecode(eventData)))
          .toList();

      for (EventModel newData in eventDataM) {
        int existingIndex =
            existingEvents.indexWhere((event) => event.key == newData.key);

        if (existingIndex != -1) {
          // Update existing item
          existingEvents[existingIndex] = newData;
        } else {
          // Add new item to the list
          existingEvents.add(newData);
        }
      }

      // Encode the updated list
      eventsEncoded.addAll(
          existingEvents.map((eventData) => jsonEncode(eventData.toJson())));
    } else {
      // If no existing data, encode the new data
      eventsEncoded.addAll(
          eventDataM.map((eventData) => jsonEncode(eventData.toJson())));
    }

    await sharedPreferences.setStringList('eventdata', eventsEncoded);
    debugPrint('sharedpreference data $eventsEncoded');
  }

//get data
  Future<List<EventModel>> getEvents() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final eventDataList = sharedPreferences.getStringList('eventdata');

    if (eventDataList == null) {
      return []; // Return an empty list if no data is found
    }

    return eventDataList
        .map((eventData) => EventModel.fromJson(jsonDecode(eventData)))
        .toList();
  }

  void deleteEvent(String deletedKey) async {
    print('deteted key $deletedKey');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? existingEventsEncoded =
        sharedPreferences.getStringList('eventdata');

    if (existingEventsEncoded != null) {
      // Remove the item with the deleted key directly
      existingEventsEncoded.removeWhere((eventData) =>
          EventModel.fromJson(jsonDecode(eventData)).key == deletedKey);

      // Update SharedPreferences
      await sharedPreferences.setStringList('eventdata', existingEventsEncoded);
      debugPrint('sharedpreference data $existingEventsEncoded');
    }
  }
}
