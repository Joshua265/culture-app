import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String caption;

  const EmptyListWidget({
    Key? key,
    this.caption = "Couldn't find any events",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty_list.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 24),
          Text(
            caption,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
