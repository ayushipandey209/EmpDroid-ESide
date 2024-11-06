import 'package:empdroid/services/FetchEmployeeDataService.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final String empid;
  const DashboardScreen({Key? key, required this.empid}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final List<Widget> _tabs; // Declare _tabs as late so it can be initialized later

  @override
  void initState() {
    super.initState();
    _tabs = [
      GenerateQRCodeTab(employeeId: widget.empid),
      FetchEmployeeDataTab(employeeId: widget.empid),
      const Text("Hello from Tab 3"),
      const Text("Hello from Tab 4"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Attendance Management"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.qr_code),),
            Tab(icon: Icon(Icons.person),),
               Tab(icon: Icon(Icons.book),),
           Tab(icon: Icon(Icons.headset_mic),),
            ],
          ),
        ),
        body: TabBarView(
          children: _tabs,
        ),
      ),
    );
  }
}

class GenerateQRCodeTab extends StatefulWidget {
  final String employeeId;

  const GenerateQRCodeTab({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<GenerateQRCodeTab> createState() => _GenerateQRCodeTabState();
}

class _GenerateQRCodeTabState extends State<GenerateQRCodeTab> {
  String? qrData;

  @override
  void initState() {
    super.initState();
    fetchEmployeeDetails();
  }

  Future<void> fetchEmployeeDetails() async {
    final fetchEmployeeDataService = FetchEmployeeDataService();
    Map<String, dynamic>? employeeDetails = await fetchEmployeeDataService.fetchEmployeeById(widget.employeeId);
    
    if (employeeDetails != null) {
      setState(() {
        qrData = 'ID: ${employeeDetails['id']}\n'
                  'Name: ${employeeDetails['fullName']}\n'
                  'Department: ${employeeDetails['department']}\n'
                  'Position: ${employeeDetails['position']}\n'
                  'Email: ${employeeDetails['email']}\n'
                  'Generated: ${DateTime.now().toLocal()}';
      });
    } else {
      setState(() {
        qrData = 'Employee not found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: qrData != null
                  ? QrImageView(
                      data: qrData!,
                      version: QrVersions.auto,
                      size: 250.0,
                      backgroundColor: Colors.white,
                    )
                  : const Text(
                      "Fetching employee details...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class FetchEmployeeDataTab extends StatefulWidget {
  final String employeeId;

  const FetchEmployeeDataTab({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<FetchEmployeeDataTab> createState() => _FetchEmployeeDataTabState();
}

class _FetchEmployeeDataTabState extends State<FetchEmployeeDataTab> {
  final FetchEmployeeDataService fetchEmployeeDataService = FetchEmployeeDataService();
  Map<String, dynamic>? employeeDetails;

  @override
  void initState() {
    super.initState();
    fetchEmployee();
  }

  Future<void> fetchEmployee() async {
    Map<String, dynamic>? employee = await fetchEmployeeDataService.fetchEmployeeById(widget.employeeId);
    setState(() {
      employeeDetails = employee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return employeeDetails != null
        ? ListTile(
            title: Text(employeeDetails!['fullName'] ?? 'Unknown'),
            subtitle: Text(employeeDetails!['position'] ?? 'No Position'),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
