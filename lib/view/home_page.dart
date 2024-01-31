import 'package:event_manage_app/controller/controller.dart';
import 'package:event_manage_app/model/event_model.dart';
import 'package:event_manage_app/view/event_create_screen.dart';
import 'package:event_manage_app/view/event_edit_screen.dart';
import 'package:event_manage_app/view/widgets/event_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final EventController eventController = Get.put(EventController());
    eventController.loadEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.put(EventController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Manage'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return EventCreateDialog(
                onPressed: () {
                  eventController.onCreateEvent();
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
        tooltip: 'Create Event',
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 50,
            left: 15,
            right: 15,
          ),
          child: Obx(
            () => eventController.isDataLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : eventController.eventModel.isEmpty
                    ? const Center(
                        child: Text('No events available.'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: eventController.eventModel.length,
                        itemBuilder: (context, index) {
                          final event = eventController.eventModel[index];
                          return Column(
                            children: [
                              EventCardWidget(
                                  title: event.title,
                                  description: event.description,
                                  key: Key(event.key),
                                  createDate: event.createDate,
                                  eventDate: event.eventDate,
                                  deleteTapped: (p0) =>
                                      eventController.onDeleteEvent(index),
                                  editTapped: (p0) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EventEditScreen(
                                          index: event.key,
                                        );
                                      },
                                    );
                                  }),
                              const SizedBox(
                                height: 15,
                              )
                            ],
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
