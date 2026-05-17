import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/notifier/account_notifier.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/providers.dart';
import 'package:ump_student_grab_mobile/theme/app_color.dart';
import 'package:ump_student_grab_mobile/widget/custom_input.dart';
import 'package:ump_student_grab_mobile/widget/custom_loading.dart';
import 'package:ump_student_grab_mobile/widget/custom_radio_button.dart';

class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  final _nameInput = TextEditingController();
  final _matricNoInput = TextEditingController();
  final _dateOfBirthInput = TextEditingController();
  final _phoneNoInput = TextEditingController();
  final _emailInput = TextEditingController();

  String? _selectedGender;
  String? _emailError;
  String? _matricNoError;
  String? _phoneNoError;
  bool _initialized = false;

  @override
  void dispose() {
    _nameInput.dispose();
    _matricNoInput.dispose();
    _dateOfBirthInput.dispose();
    _phoneNoInput.dispose();
    _emailInput.dispose();
    super.dispose();
  }

  void _initFromProfile() {
    if (_initialized) return;
    final profile = ref.read(accountNotifierProvider).valueOrNull;
    if (profile == null) return;
    _nameInput.text = profile.fullName;
    _matricNoInput.text = profile.matricNo ?? '';
    _phoneNoInput.text = profile.phoneNo;
    _emailInput.text = profile.email;
    _selectedGender = profile.gender;
    if (profile.birthDate != null && profile.birthDate!.isNotEmpty) {
      final date = DateFormat('yyyy-MM-dd').parse(profile.birthDate!);
      _dateOfBirthInput.text = DateFormat('dd/MM/yyyy').format(date);
    }
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    _initFromProfile();
    final isLoading = ref.watch(accountNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Personal Details',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  CustomInput(
                    userInput: _nameInput,
                    hintText: 'Name',
                    keyboardType: TextInputType.text,
                    showBorder: true,
                    borderRadius: 10,
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    userInput: _matricNoInput,
                    hintText: 'Matric No.',
                    keyboardType: TextInputType.text,
                    showBorder: true,
                    borderRadius: 10,
                    errorText: _matricNoError,
                    onChanged: (_) => setState(() => _matricNoError = null),
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    userInput: _dateOfBirthInput,
                    hintText: 'Date of birth',
                    isDatePicker: true,
                    keyboardType: TextInputType.datetime,
                    showBorder: true,
                    borderRadius: 10,
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gender',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 157, 157, 157))),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: CustomRadioButton(
                              label: 'Male',
                              selected: _selectedGender == 'Male',
                              onChanged: (_) =>
                                  setState(() => _selectedGender = 'Male'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomRadioButton(
                              label: 'Female',
                              selected: _selectedGender == 'Female',
                              onChanged: (_) =>
                                  setState(() => _selectedGender = 'Female'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 0.5),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contact Details',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  CustomInput(
                    userInput: _phoneNoInput,
                    hintText: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    showBorder: true,
                    borderRadius: 10,
                    errorText: _phoneNoError,
                    onChanged: (_) => setState(() => _phoneNoError = null),
                  ),
                  const SizedBox(height: 10),
                  CustomInput(
                    userInput: _emailInput,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    showBorder: true,
                    borderRadius: 10,
                    errorText: _emailError,
                    onChanged: (_) => setState(() => _emailError = null),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColor.primary,
                  ),
                  onPressed: isLoading ? null : _handleSave,
                  child: isLoading
                      ? const CustomLoading()
                      : const Text('Save',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() {
      _emailError = null;
      _matricNoError = null;
      _phoneNoError = null;
    });

    bool hasError = false;

    if (_emailInput.text.isEmpty) {
      setState(() => _emailError = 'This field is required.');
      hasError = true;
    }
    if (_emailInput.text.isNotEmpty &&
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_emailInput.text)) {
      setState(() => _emailError = 'Please enter a valid email address.');
      hasError = true;
    }
    if (_matricNoInput.text.isNotEmpty &&
        !RegExp(r'^[A-Za-z]{2}\d{5}$').hasMatch(_matricNoInput.text)) {
      setState(() =>
          _matricNoError = 'Please enter a valid matric number (e.g. CB12345).');
      hasError = true;
    }
    if (_phoneNoInput.text.isNotEmpty &&
        !RegExp(r'^(\+\d{1,3}[- ]?)?\d{10,11}$')
            .hasMatch(_phoneNoInput.text)) {
      setState(() => _phoneNoError = 'Phone number must be 10 or 11 digits.');
      hasError = true;
    }
    if (hasError) return;

    String? formattedDate;
    if (_dateOfBirthInput.text.isNotEmpty) {
      final date = DateFormat('dd/MM/yyyy').parse(_dateOfBirthInput.text);
      formattedDate = DateFormat('yyyy-MM-dd').format(date);
    }

    final failure = await ref
        .read(accountNotifierProvider.notifier)
        .updateProfile(UpdateProfileParams(
          fullName: _nameInput.text,
          matricNo: _matricNoInput.text,
          birthDate: formattedDate,
          gender: _selectedGender,
          phoneNo: _phoneNoInput.text,
          email: _emailInput.text,
        ));

    if (!mounted) return;

    if (failure != null) {
      Fluttertoast.showToast(
        msg: failure.message,
        backgroundColor: Colors.red.shade800,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Profile updated successfully.',
        backgroundColor: Colors.green.shade800,
        textColor: Colors.white,
      );
    }
  }
}
