import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:qwitter_flutter_app/components/message_card.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';
import 'package:qwitter_flutter_app/models/message_data.dart';
import 'package:qwitter_flutter_app/providers/messages_provider.dart';
import 'package:qwitter_flutter_app/theme/theme_constants.dart';

class ScrollableMessages extends ConsumerStatefulWidget {
  ScrollableMessages({
    super.key,
    required this.msgs,
    required this.scrollController,
    required this.isGroup,
  });
  List<MessageData> msgs;
  final bool isGroup;
  final ScrollController scrollController;
  @override
  ConsumerState<ScrollableMessages> createState() {
    return _ScrollableMessagesState();
  }
}

class _ScrollableMessagesState extends ConsumerState<ScrollableMessages> {
  AppUser user = AppUser();
  void longHold(MessageData message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: black,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: black),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Reply",
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    final value = ClipboardData(text: message.text);
                    Clipboard.setData(value);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Copy message text",
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ref.watch(messagesProvider.notifier).DeleteMessage(message);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Delete Message",
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Expanded(
      child: GroupedListView<MessageData, DateTime>(
        reverse: true,
        controller: widget.scrollController,
        sort: false,
        padding: const EdgeInsets.all(8),
        elements: widget.msgs,
        groupBy: (msgs) => DateTime(
          msgs.date.year,
          msgs.date.month,
          msgs.date.day,
        ),
        groupHeaderBuilder: (MessageData msg) => SizedBox(
          height: 40,
          child: Center(
            child: Text(
              DateFormat.yMMMd().format(msg.date),
              style: const TextStyle(color: white),
            ),
          ),
        ),
        itemBuilder: (context, MessageData message) => Align(
          alignment: message.name == user.username
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: InkWell(
              child: MessageCard(
                msg: message,
                tag: UniqueKey().toString(),
                longHold: longHold,
                isGroup: widget.isGroup,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
