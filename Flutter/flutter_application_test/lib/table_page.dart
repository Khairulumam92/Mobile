import 'package:flutter/material.dart';

class TablePage extends StatefulWidget {
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final List<Map<String, String>> _data = [
    {'Name': 'Alice', 'Age': '25', 'Role': 'Developer'},
    {'Name': 'Bob', 'Age': '30', 'Role': 'Designer'},
    {'Name': 'Charlie', 'Age': '35', 'Role': 'Manager'},
    {'Name': 'David', 'Age': '28', 'Role': 'Tester'},
    {'Name': 'Eve', 'Age': '22', 'Role': 'Intern'},
    {'Name': 'Frank', 'Age': '40', 'Role': 'Architect'},
    {'Name': 'Grace', 'Age': '29', 'Role': 'Analyst'},
    {'Name': 'Heidi', 'Age': '31', 'Role': 'Support'},
    {'Name': 'Ivan', 'Age': '26', 'Role': 'DevOps'},
    {'Name': 'Judy', 'Age': '33', 'Role': 'Product Owner'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  void _addEntry() {
    if (_nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _roleController.text.isNotEmpty) {
      setState(() {
        _data.add({
          'Name': _nameController.text,
          'Age': _ageController.text,
          'Role': _roleController.text,
        });
        _nameController.clear();
        _ageController.clear();
        _roleController.clear();
      });
    }
  }

  void _deleteEntry(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _data.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _ageController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Age',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _roleController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Role',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addEntry,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _data
                    .asMap()
                    .entries
                    .map(
                      (entry) => DataRow(
                        cells: [
                          DataCell(Text(entry.value['Name']!)),
                          DataCell(Text(entry.value['Age']!)),
                          DataCell(Text(entry.value['Role']!)),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteEntry(entry.key),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
