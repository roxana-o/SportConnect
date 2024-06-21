import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

//Clasa model pentru utilizator
class User {
  final String id;
  final String name;
  final String email;
  final List<String> attendingEvents;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.attendingEvents = const [],
  });
}

//Clasa model pentru eveniment
class Event {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String place;
  final String tags;
  final String imageURL;
  final String sport;
  final String region;
  int likesCount;
  List<String> attendees;
  bool isAttending;
  bool isLiked;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.place,
    required this.tags,
    required this.imageURL,
    required this.sport,
    required this.region,
    this.likesCount = 0,
    this.attendees = const [],
    this.isAttending = false,
    this.isLiked = false,
  });
}

//Clasa cu lista de evenimente
class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSport = 'Sport';
  String _selectedRegion = 'Județ';
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = getUser(
        'sXANlgheWEepX9BP0oUweWtigiB3'); //FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Caută',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey[600]
                                  : Colors.grey[400]),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: _selectedSport,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSport = newValue!;
                          });
                        },
                        items: <String>[
                          'Sport',
                          'Aerobic',
                          'Atletism',
                          'Alergat',
                          'Badminton',
                          'Balet',
                          'Baschet',
                          'Baseball',
                          'Box',
                          'Canotaj',
                          'Ciclism',
                          'Dans',
                          'Fotbal',
                          'Înot',
                          'Judo',
                          'Karate',
                          'Lupte',
                          'Patinaj',
                          'Ping Pong',
                          'Polo',
                          'Rugby',
                          'Scrimă',
                          'Scufundare',
                          'Schi',
                          'Surf',
                          'Taekwondo',
                          'Tenis',
                          'Volei'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: _selectedRegion,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRegion = newValue!;
                          });
                        },
                        items: <String>[
                          'Județ',
                          'Alba',
                          'Arad',
                          'Argeș',
                          'Bacău',
                          'Bihor',
                          'Bistrița-Năsăud',
                          'Botoșani',
                          'Brăila',
                          'Brașov',
                          'București',
                          'Buzău',
                          'Călărași',
                          'Caraș-Severin',
                          'Cluj',
                          'Constanța',
                          'Covasna',
                          'Dâmbovița' 'Dolj',
                          'Galați',
                          'Giurgiu',
                          'Gorj',
                          'Harghita',
                          'Hunedoara',
                          'Ialomița',
                          'Iași',
                          'Ilfov',
                          'Maramureș',
                          'Mehedinți',
                          'Mureș',
                          'Neamț',
                          'Olt',
                          'Prahova',
                          'Sălaj',
                          'Satu Mare',
                          'Sibiu',
                          'Suceava',
                          'Teleorman',
                          'Timiș',
                          'Tulcea',
                          'Vâlcea',
                          'Vaslui',
                          'Vrancea'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: [
              if (_selectedSport != 'Sport')
                Chip(
                  label: Text(
                    _selectedSport,
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  backgroundColor: Colors.grey[300],
                  onDeleted: () {
                    setState(() {
                      _selectedSport = 'Sport';
                    });
                  },
                ),
              if (_selectedRegion != 'Județ')
                Chip(
                  label: Text(
                    _selectedRegion,
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                  backgroundColor: Colors.grey[300],
                  onDeleted: () {
                    setState(() {
                      _selectedRegion = 'Județ';
                    });
                  },
                ),
            ],
          ),
          Expanded(
            child: FutureBuilder<User>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('A apărut o eroare: ${snapshot.error}'));
                }
                User user = snapshot.data!;
                return EventList(
                  searchQuery: _searchController.text,
                  selectedSport: _selectedSport,
                  selectedRegion: _selectedRegion,
                  user: user,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Functie pentru obtinerea utilizatorului din Firestore
Future<User> getUser(String userId) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (!userDoc.exists) {
    throw Exception(
        "Utilizatorul cu ID $userId nu exista"); //Utilizatorul nu exista
  }

  Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
  if (data == null) {
    throw Exception(
        "Datele utilizatorului cu ID $userId sunt nule"); //Utilizatorul are date nule
  }

  return User(
    id: userDoc.id,
    name: data['name'] ?? '',
    email: data['email'] ?? '',
    attendingEvents: List<String>.from(data['attendingEvents'] ?? []),
  );
}

//Clasa pentru listarea evenimentelor
class EventList extends StatefulWidget {
  final String searchQuery;
  final String selectedSport;
  final String selectedRegion;
  final User user;

  EventList({
    required this.searchQuery,
    required this.selectedSport,
    required this.selectedRegion,
    required this.user,
  });

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  void toggleAttending(Event event, User user) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.id);
    if (user.attendingEvents.contains(event.id)) {
      // Eliminarea unui eveniment din lista de participare
      await docRef.update({
        'attendingEvents': FieldValue.arrayRemove([event.id])
      }).then((_) {
        print('Eveniment eliminat din lista de participare');
      }).catchError((error) {
        setState(() {
          event.isAttending = !event.isAttending;
        });
        print('Eroare la eliminarea evenimentului: $error');
      });
    } else {
      // Adaugare eveniment la lista de participare
      await docRef.update({
        'attendingEvents': FieldValue.arrayUnion([event.id])
      }).then((_) {
        print('Eveniment adaug la lista de participare');
      }).catchError((error) {
        setState(() {
          event.isAttending = !event.isAttending;
        });
        print('Eroare la adaugare eveniment: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: getEvents(widget.user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('A apărut o eroare: ${snapshot.error}'));
        }
        List<Event> events = snapshot.data ?? [];

        //Aplicare filtre de cautare
        events = events.where((event) {
          bool matchesSearch = event.name
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase());
          bool matchesSport = widget.selectedSport == 'Sport' ||
              event.sport == widget.selectedSport;
          bool matchesRegion = widget.selectedRegion == 'Județ' ||
              event.region == widget.selectedRegion;
          return matchesSearch && matchesSport && matchesRegion;
        }).toList();

        //Nu exista evenimente conform filtrelor
        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/saddie.json',
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Din păcate nu sunt disponibile evenimente \n pentru filtrul selectat.',
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
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
                                SizedBox(width: 4),
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
                                const Icon(Icons.place,
                                    size: 16, color: Colors.grey),
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
                              const Icon(Icons.check,
                                  size: 20, color: Colors.teal),
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
                                icon: Icon(Icons.thumb_up),
                                color: event.isLiked == true
                                    ? Colors.teal
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    event.isLiked = !(event.isLiked);

                                    // Actualizează în Firestore
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
                                icon: Icon(Icons.control_point_outlined),
                                color: event.isAttending
                                    ? Colors.teal
                                    : Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    event.isAttending = !event.isAttending;
                                    toggleAttending(event, widget.user);
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
}

//Functie pentru obtinerea listei de evenimente din Firestore
Future<List<Event>> getEvents(User user) async {
  QuerySnapshot eventsSnapshot =
      await FirebaseFirestore.instance.collection('events').get();
  List<Event> events = eventsSnapshot.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    DateTime date = (data['date'] as Timestamp).toDate();
    String startTimeString = data['startTime'];
    String endTimeString = data['endTime'];
    DateTime startTime = _parseTimeString(startTimeString, date);
    DateTime endTime = _parseTimeString(endTimeString, date);
    bool isAttending = user.attendingEvents.contains(doc.id);

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
      isAttending: isAttending,
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

//Functie pentru adaugare/eliminare eveniment din lista de participare
void toggleAttending(Event event, User user) async {
  final docRef = FirebaseFirestore.instance.collection('users').doc(user.id);
  if (user.attendingEvents.contains(event.id)) {
// Eliminare
    await docRef.update({
      'attendingEvents': FieldValue.arrayRemove([event.id])
    });
  } else {
//Adaugare
    await docRef.update({
      'attendingEvents': FieldValue.arrayUnion([event.id])
    });
  }
}

//Detalii eveniment
class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
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
                fontSize: 24,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 20, color: Color.fromARGB(255, 72, 72, 72)),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd-MM-yyyy').format(event.startTime),
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 72, 72, 72)),
                ),
                const SizedBox(width: 50),
                const Icon(Icons.access_time_rounded,
                    size: 20, color: Color.fromARGB(255, 72, 72, 72)),
                const SizedBox(width: 5),
                Text(
                  DateFormat('HH:mm').format(event.startTime),
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 72, 72, 72)),
                ),
                const Text(
                  ' - ',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 72, 72, 72)),
                ),
                Text(
                  DateFormat('HH:mm').format(event.endTime),
                  style: const TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 72, 72, 72)),
                ),
                const Text(
                  ' (EEST) ',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 72, 72, 72)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.place,
                  size: 20,
                  color: Color.fromARGB(255, 72, 72, 72),
                ),
                const SizedBox(width: 8),
                Text(
                  event.region,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 72, 72, 72),
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
                    color: Color.fromARGB(255, 72, 72, 72),
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
                      color: Color.fromARGB(255, 72, 72, 72),
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
                    color: Color.fromARGB(255, 72, 72, 72),
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
