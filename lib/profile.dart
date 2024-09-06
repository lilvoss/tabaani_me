import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'Profile_Screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;
  final TextEditingController birthdayController = TextEditingController();

  @override
  void dispose() {
    birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://images.pexels.com/photos/416920/pexels-photo-416920.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://media.istockphoto.com/id/1476170969/photo/portrait-of-young-man-ready-for-job-business-concept.webp?b=1&s=170667a&w=0&k=20&c=FycdXoKn5StpYCKJ7PdkyJo9G5wfNgmSLBWk3dI35Zw='),
                ),
              ),
            ],
          ),
          SizedBox(height: 70), // Adjusted to account for the avatar position
          Text(
            'Mohamed Bechir Kefi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Description here.',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabItem(Icons.settings, 'GENERAL SETTINGS', 0),
              _buildTabItem(Icons.receipt, 'BILLING INFORMATION', 1),
              _buildTabItem(Icons.security, 'SECURITY SETTINGS', 2),
            ],
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            setState(() {
              selectedIndex = index;
            });
          }
        },
        child: Column(
          children: [
            Icon(icon,
                color: selectedIndex == index ? Colors.orange : Colors.grey),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selectedIndex == index ? Colors.orange : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (selectedIndex == 0) _buildGeneralSettings(),
            if (selectedIndex == 1) _buildBillingInformation(),
            if (selectedIndex == 2) _buildSecuritySettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Column(
      children: [
        _buildCustomTextField('Full Name'),
        _buildCustomTextField('Description'),
        _buildCustomTextField('Email', enabled: false),
        TextField(
          controller: birthdayController,
          decoration: InputDecoration(
            labelText: 'Birthday',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
        ),
        SizedBox(height: 20),
        _buildCustomButton('Save'),
      ],
    );
  }

  Widget _buildBillingInformation() {
    return Column(
      children: [
        _buildCustomTextField('First Name'),
        _buildCustomTextField('Last Name'),
        _buildCustomDropdown(
            'Select Country', ['Country 1', 'Country 2', 'Country 3']),
        _buildCustomTextField('City'),
        _buildCustomTextField('Address'),
        _buildCustomTextField('Phone Number'),
        SizedBox(height: 20),
        _buildCustomButton('SAVE'),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      children: [
        _buildCustomTextField('Email'),
        SizedBox(height: 20),
        _buildCustomButton('CHANGE EMAIL & SEND PASSWORD RESET LINK'),
      ],
    );
  }

  Widget _buildCustomTextField(String labelText, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        enabled: enabled,
      ),
    );
  }

  Widget _buildCustomDropdown(String labelText, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        birthdayController.text = DateFormat.yMMMd().format(picked);
      });
    }
  }
}
