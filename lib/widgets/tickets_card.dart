import 'package:flutter/material.dart';

class TicketsCard extends StatelessWidget {
  const TicketsCard({
    super.key,
    this.ticketPaths,
    this.ticketCaptions,
  });

  final List<String>? ticketPaths;
  final List<String>? ticketCaptions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tickets',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) => _buildTicketSlot(index)),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(61, 47, 35, 35),
            ),
            child: Center(
              child: Transform.rotate(
                angle: -0.25,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'COMING SOON',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketSlot(int index) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(right: 16, bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
