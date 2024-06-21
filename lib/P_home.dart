import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'text_fields.dart';

enum SortCriterion { date, name }

enum SortOrder { ascending, descending }

//Clasa pentru optiunile de sortare
class SortOption {
  final SortCriterion criterion;
  final SortOrder order;

  SortOption({required this.criterion, required this.order});
}

//Clasa Event
class Event {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String place;
  final String tags;
  final String sport;
  final String region;
  final String imageURL;
  final String searchQuery;
  bool isLiked;
  bool isAttending;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.place,
    required this.tags,
    required this.sport,
    required this.region,
    required this.imageURL,
    required this.searchQuery,
    this.isLiked = false,
    this.isAttending = false,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _sortOption =
      SortOption(criterion: SortCriterion.date, order: SortOrder.ascending);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    newText(
                      customText: 'Evenimente apreciate:',
                      customStyle: const TextStyle(
                        color: Colors.teal,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    //Meniu pentru optiunile de sortare
                    PopupMenuButton<SortCriterion>(
                      icon: const Icon(Icons.sort),
                      onSelected: (SortCriterion criterion) {
                        setState(() {
                          if (_sortOption.criterion == criterion) {
                            _sortOption = SortOption(
                              criterion: criterion,
                              order: _sortOption.order == SortOrder.ascending
                                  ? SortOrder.descending
                                  : SortOrder.ascending,
                            );
                          } else {
                            _sortOption = SortOption(
                              criterion: criterion,
                              order: SortOrder.ascending,
                            );
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SortCriterion>>[
                        PopupMenuItem<SortCriterion>(
                          value: SortCriterion.date,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sortare după dată'),
                             
                             //Iconita pentru indicarea ordinii sortarii (crescatoare/descrescatoare)
                              Icon(
                                _sortOption.criterion == SortCriterion.date
                                    ? (_sortOption.order == SortOrder.ascending
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<SortCriterion>(
                          value: SortCriterion.name,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sortare după denumire'),

                               //Iconita pentru indicarea ordinii sortarii (crescatoare/descrescatoare)
                              Icon(
                                _sortOption.criterion == SortCriterion.name
                                    ? (_sortOption.order == SortOrder.ascending
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey[200]
                        : Colors.grey[800],
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                       BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: EventList(
              searchQuery: _searchController.text,
              sortOption: _sortOption,
            ),
          ),
        ],
      ),
    );
  }
}

class EventList extends StatefulWidget {
  final String searchQuery;
  final SortOption sortOption;

  EventList({required this.searchQuery, required this.sortOption});

  @override
  State<EventList> createState() => _EventListState(sortOption: sortOption);
}

class _EventListState extends State<EventList> {
  final SortOption sortOption;

  _EventListState({required this.sortOption});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('A apărut o eroare: ${snapshot.error}'));
        }
        List<Event> events = snapshot.data ?? [];

        events = events.where((event) => event.isLiked).toList();
        if (events.isEmpty) {
          return Column(
            children: [
              const SizedBox(height: 40),
              Lottie.asset(
                'assets/search.json',
                width: 300,
              ),
              const SizedBox(height: 40),
              const Text(
                  'Nu există evenimente apreciate. \n Explorează pagina de căutare.',
                  style: TextStyle(fontSize: 15)),
            ],
          );
        }

        // Aplică sortarea pe baza critetiului si a ordinii

        if (widget.sortOption.criterion == SortCriterion.date) {
          if (widget.sortOption.order == SortOrder.ascending) {
            events.sort((a, b) => a.date.compareTo(b.date));
          } else {
            events.sort((a, b) => b.date.compareTo(a.date));
          }
        } else if (widget.sortOption.criterion == SortCriterion.name) {
          if (widget.sortOption.order == SortOrder.ascending) {
            events.sort((a, b) => a.name.compareTo(b.name));
          } else {
            events.sort((a, b) => b.name.compareTo(a.name));
          }
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            Event event = events[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(event: event),
                  ),
                );
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          event.imageURL,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(event.startTime),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.place, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  event.region,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.check, size: 20, color: Colors.teal),
                              const SizedBox(width: 4),
                              Text(
                                event.sport,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up),
                                color: event.isLiked == true
                                    ? Colors.teal
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    event.isLiked = !(event.isLiked);
                                    FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(event.id)
                                        .update({
                                      'isLiked': event.isLiked,
                                    });
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.control_point_sharp),
                                color: event.isAttending == true
                                    ? Colors.teal
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    event.isAttending = !(event.isAttending); // Inverseaza starea de participare

                                    // Actualizează în Firestore
                                    FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(event.id)
                                        .update({
                                      'isAttending': event.isAttending,
                                    });
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

//Functie pentru obtinere date din Firestore
  Future<List<Event>> getEvents() async {
    QuerySnapshot eventsSnapshot =
        await FirebaseFirestore.instance.collection('events').get();
    List<Event> events = eventsSnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Extrage data din baza de date
      DateTime date = (data['date'] as Timestamp).toDate();

      // Extrage startTime și endTime din startTime și endTime
      String startTimeString = data['startTime'];
      String endTimeString = data['endTime'];

      // Converteste string-ul startTime in DateTime 
      DateTime startTime = _parseTimeString(startTimeString, date);

      // Converteste string-ul endTime in DateTime 
      DateTime endTime = _parseTimeString(endTimeString, date);

      return Event(
        id: doc.id,
        name: data['name'],
        description: data['description'],
        date: date,
        startTime: startTime,
        endTime: endTime,
        place: data['place'],
        tags: data['tags'],
        sport: data['sport'],
        region: data['region'],
        imageURL: data['media'][0],
        isLiked: data['isLiked'],
        isAttending: data['isAttending'],
        searchQuery: '',
      );
    }).toList();

    return events;
  }

  DateTime _parseTimeString(String timeString, DateTime date) {
    List<String> timeParts = timeString.split(' ');
    String time = timeParts[0];
    String amPm = timeParts[1];
    List<String> timeComponents = time.split(':');
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);
    if (amPm == 'PM' && hour < 12) {
      hour += 12;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}

//Detalii eveniment
class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event.imageURL,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              event.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 20, color: const Color.fromARGB(255, 72, 72, 72)),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd-MM-yyyy').format(event.startTime),
                  style: const TextStyle(
                      fontSize: 18,
                      color:  Color.fromARGB(255, 72, 72, 72)),
                ),
                const SizedBox(width: 50),

                const Icon(Icons.access_time_rounded,
                    size: 20, color:  Color.fromARGB(255, 72, 72, 72)),

                const SizedBox(width: 5),

                Text(
                  DateFormat('HH:mm').format(event.startTime),
                  style: const TextStyle(
                      fontSize: 18,
                      color:  Color.fromARGB(255, 72, 72, 72)),
                ),
                const Text(
                  ' - ',
                  style: TextStyle(
                      fontSize: 18,
                      color:  Color.fromARGB(255, 72, 72, 72)),
                ),
                 Text(
                  DateFormat('HH:mm').format(event.endTime),
                  style: const TextStyle(
                      fontSize: 18,
                      color:  Color.fromARGB(255, 72, 72, 72)),
                ),
                const Text(
                  ' (EEST) ',
                  style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 72, 72, 72)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.place,
                  size: 20,
                  color:  Color.fromARGB(255, 72, 72, 72),
                ),
                const SizedBox(width: 8),
                Text(
                  event.region,
                  style: const TextStyle(
                    fontSize: 18,
                    color:  Color.fromARGB(255, 72, 72, 72),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 30),
                Text(
                  event.place,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 97, 97, 97),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Text(
                  'Descriere: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:  Color.fromARGB(255, 72, 72, 72),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 330,
                  child: Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 18,
                      color:  Color.fromARGB(255, 72, 72, 72),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  '#',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 72, 72, 72),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  event.tags,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 97, 97, 97),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
