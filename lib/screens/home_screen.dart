import 'package:flutter/material.dart';
import 'package:medico/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> medicines = [
    {'name': 'Paracetamol Extra', 'dose': '500 mg', 'time': '8:00 AM'},
    {'name': 'Azithromycin', 'dose': '500 mg', 'time': '6:00 AM'},
    {'name': 'Anclofen', 'dose': '500 mg', 'time': '7:00 AM'},
  ];

  String selectedFilter = "Everyday";
  final List<String> filters = ["Everyday", "Today", "Week", "Month"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            100,
          ),
        ),
        child: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextWidget(
          text: "Your medicine reminder",
          fontSize: 18,
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];
                    return MedicineCard(
                      name: medicine['name']!,
                      dose: medicine['dose']!,
                      time: medicine['time']!,
                    );
                  },
                ),
              ),
            ),
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

  const MedicineCard(
      {super.key, required this.name, required this.dose, required this.time});

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
          text: "$dose\nEveryday - $time",
          fontSize: 14,
          color: Colors.black,
          fontFamily: 'Regular',
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {},
                child: ListTile(
                  title: TextWidget(
                    align: TextAlign.start,
                    text: 'View',
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Medium',
                  ),
                  trailing: Icon(
                    Icons.remove_red_eye,
                  ),
                ),
              ),
              PopupMenuItem(
                onTap: () {},
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
