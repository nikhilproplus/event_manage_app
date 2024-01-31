import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class EventCardWidget extends StatelessWidget {
  final String title;
  final String description;

  final DateTime createDate;
  final DateTime eventDate;
  final void Function(BuildContext)? deleteTapped;
  final void Function(BuildContext)? editTapped;
  const EventCardWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.createDate,
      required this.eventDate,
      this.deleteTapped,
      this.editTapped});

  @override
  Widget build(BuildContext context) {
    bool isActive = eventDate.isAfter(createDate);
    return Slidable(
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: editTapped,
            icon: Icons.edit,
            backgroundColor: Colors.blue,
            borderRadius: BorderRadius.circular(15),
          )
        ],
      ),
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        //delete button
        SlidableAction(
          onPressed: deleteTapped,
          icon: Icons.delete,
          backgroundColor: Colors.red,
          borderRadius: BorderRadius.circular(15),
        )
      ]),
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                    'create date: ${DateFormat('dd/MM/yyyy').format(createDate)}'),
              ],
            ),
            Text(
              description,
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isActive
                    ? Text(
                        'Active',
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        'Event passed',
                        style: TextStyle(color: Colors.red),
                      ),
                Text(
                    'Event date: ${DateFormat('dd/MM/yyyy').format(eventDate)}'),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
