import 'package:flutter/material.dart';
import 'package:guideurself/services/account.dart';

class ForgotPasswordFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String? selectedCampusName;
  final Function onSelectedCampusChanged;

  const ForgotPasswordFields({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.selectedCampusName,
    required this.onSelectedCampusChanged,
  });

  @override
  State<ForgotPasswordFields> createState() => _ForgotPasswordFieldsState();
}

class _ForgotPasswordFieldsState extends State<ForgotPasswordFields> {
  final campuses = [];

  @override
  void initState() {
    super.initState();
    _fetchCampuses();
  }

  void _fetchCampuses() async {
    final response = await getAllCampuses();
    setState(() {
      campuses.addAll(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            menuMaxHeight: 200,
            isExpanded: true,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: "Poppins",
              color: Color(0xFF323232),
            ),
            borderRadius: BorderRadius.circular(10),
            elevation: 1,
            hint: Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                "Select Account Type",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              labelText: "Select Account Type",
            ),
            value: widget.selectedCampusName,
            onChanged: (value) {
              Map<String, String> campus = campuses
                  .firstWhere((campus) => campus["campus_name"] == value);
              widget.onSelectedCampusChanged(campus);
            },
            validator: (value) =>
                value == null ? "Please select an account type" : null,
            items: campuses.map<DropdownMenuItem<String>>((campus) {
              return DropdownMenuItem<String>(
                value: campus["campus_name"],
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(campus["campus_name"]),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 25),
          // Email Field
          TextFormField(
            cursorColor: const Color(0xFF323232),
            style: const TextStyle(fontSize: 14),
            controller: widget.emailController,
            decoration: const InputDecoration(
              hintText: "Enter email",
              labelText: "Email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
