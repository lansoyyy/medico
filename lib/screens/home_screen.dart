import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medico/screens/notif_screen.dart';
import 'package:medico/screens/reminder_screen.dart';
import 'package:medico/services/add_medicine.dart';
import 'package:medico/utils/colors.dart';
import 'package:medico/widgets/text_widget.dart';
import 'package:medico/widgets/toast_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "Everyday";
  final List<String> filters = ["Everyday", "Today", "Week", "Month"];

  TimeOfDay selectedTime = TimeOfDay.now();

  DateTime selectedDate = DateTime.now();

  void _addMedicine() {
    TextEditingController nameController = TextEditingController();
    TextEditingController doseController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    String selectedFrequency = filters[0];

    Future<void> selectTime() async {
      TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() {
          timeController.text = picked.format(context);
          selectedTime = picked;
        });
      }
    }

    Future<void> selectDate() async {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        setState(() {
          dateController.text = "${picked.toLocal()}".split(' ')[0];
          selectedDate = picked;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Center(
                child: Text(
                  "Add Medicine",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Medicine Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: doseController,
                      decoration: InputDecoration(
                        labelText: "Dose",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: timeController,
                      decoration: InputDecoration(
                        labelText: "Time",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      readOnly: true,
                      onTap: selectTime,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedFrequency,
                      onChanged: (value) {
                        setState(() {
                          selectedFrequency = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Frequency",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      items: filters.map((filter) {
                        return DropdownMenuItem(
                          value: filter,
                          child: Text(filter),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    if (selectedFrequency == "Week" ||
                        selectedFrequency == "Month")
                      TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: "Select Date",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        readOnly: true,
                        onTap: selectDate,
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    addMedicine(nameController.text, doseController.text,
                        selectedFrequency, selectedTime, selectedDate);
                    Navigator.pop(context);
                  },
                  child: Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedicine,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextWidget(
          text: 'TB X Mobile Health Monitoring App',
          fontSize: 18,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NotifScreen()));
            },
            icon: Icon(Icons.notifications),
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtonsWidget(
              filters: filters,
              selectedFilter: selectedFilter,
              onFilterSelected: (filter) {
                setState(() {
                  selectedFilter = filter;
                });
              },
            ),
            SizedBox(height: 20),
            TextWidget(
              text: "Today's medicine report",
              fontSize: 18,
              color: Colors.black,
              fontFamily: 'Bold',
            ),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Medicine')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }

                  final data = snapshot.requireData;
                  final medicines = data.docs;

                  String currentTime =
                      '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';

                  final newList = medicines.where(
                    (element) {
                      return selectedFilter == "Everyday"
                          ? element['time'] == currentTime
                          : element['dateTime'].toDate().day ==
                                  DateTime.now().day &&
                              element['time'] == currentTime;
                    },
                  );

                  if (newList.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ReminderScreen(
                                  medicines: newList.toList(),
                                )));
                      },
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: medicines.where(
                        (element) {
                          return selectedFilter != 'Today'
                              ? element['frequency'] == selectedFilter
                              : element['frequency'] == selectedFilter &&
                                  element['dateTime'].toDate().day ==
                                      DateTime.now().day &&
                                  element['dateTime'].toDate().month ==
                                      DateTime.now().month;
                        },
                      ).length,
                      itemBuilder: (context, index) {
                        final medicine = medicines.where(
                          (element) {
                            return selectedFilter != 'Today'
                                ? element['frequency'] == selectedFilter
                                : element['frequency'] == selectedFilter &&
                                    element['dateTime'].toDate().day ==
                                        DateTime.now().day &&
                                    element['dateTime'].toDate().month ==
                                        DateTime.now().month;
                          },
                        ).elementAt(index);
                        return MedicineCard(
                          date: medicine['dateTime'].toDate(),
                          name: medicine['name']!,
                          dose: medicine['dose']!,
                          time: medicine['time']!,
                          frequency: medicine['frequency']!,
                          docId: medicine.id,
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String name;
  final String dose;
  final String time;
  final DateTime date;
  final String docId;

  final String frequency;

  const MedicineCard(
      {super.key,
      required this.name,
      required this.dose,
      required this.time,
      required this.frequency,
      required this.docId,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.medication, color: Colors.blue),
        title: TextWidget(
          align: TextAlign.start,
          text: name,
          fontSize: 18,
          color: Colors.black,
          fontFamily: 'Bold',
        ),
        subtitle: TextWidget(
          align: TextAlign.start,
          text: frequency == 'Everyday' || frequency == 'Today'
              ? "$dose\n$frequency - ${parseTime(time).format(context)}"
              : "$dose\n$frequency - ${DateFormat.yMMMd().format(date)}, ${parseTime(time).format(context)}",
          fontSize: 14,
          color: Colors.black,
          fontFamily: 'Regular',
        ),
        trailing: PopupMenuButton(
          color: Colors.white,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection('Medicine')
                      .doc(docId)
                      .delete();
                  showToast('Deleted succesfully!');
                },
                child: ListTile(
                  title: TextWidget(
                    align: TextAlign.start,
                    text: 'Delete',
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Medium',
                  ),
                  trailing: Icon(
                    Icons.delete_outline_rounded,
                  ),
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}

class ToggleButtonsWidget extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const ToggleButtonsWidget({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: filters.map((filter) {
        final bool isSelected = filter == selectedFilter;
        return GestureDetector(
          onTap: () => onFilterSelected(filter),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue),
            ),
            child: Text(
              filter,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blue,
                  fontFamily: 'Bold'),
            ),
          ),
        );
      }).toList(),
    );
  }
}
