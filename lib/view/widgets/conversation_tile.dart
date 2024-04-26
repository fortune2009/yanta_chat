import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yanta/commons/colors.dart';
import 'package:yanta/commons/space.dart';
import 'package:yanta/commons/utils.dart';

class ChatTile extends StatelessWidget {
  const ChatTile(
      {required this.lastMessage,
      required this.topic,
      super.key,
      required this.timestamp});
  final String lastMessage;
  final String topic;
  final int timestamp;
  // final MessageData details;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  // image: DecorationImage(
                  //     image: NetworkImage(imageUrl), fit: BoxFit.cover),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.grayscalePlaceholderColor),
                      child: Styles.boldTextStyle(getSingleInitial(topic)),
                    ),
                    const WSpace(10),
                    SizedBox(
                      width: deviceWidth(context) / 1.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Styles.semiBoldTextStyle(topic,
                                  fontSize: 14, fontWeight: FontWeight.w700),
                              Styles.semiBoldTextStyle(
                                  DateFormat('HH:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          timestamp)),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ],
                          ),
                          const HSpace(4),
                          Styles.regularTextStyle(
                            lastMessage,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
