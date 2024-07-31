import 'package:flutter/material.dart';
import 'package:hms_project/controller/booking_patient_controller.dart';
import 'package:hms_project/presentation/constants/colorconstants.dart';

import 'package:provider/provider.dart';

class NewBookings extends StatefulWidget {
  const NewBookings({super.key});

  @override
  State<NewBookings> createState() => _NewBookingsState();
}

class _NewBookingsState extends State<NewBookings> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController lastnamecontroller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController phnumbercontroller = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController patientidcontroller = TextEditingController();
  String? _selectedDoctor;
  String? _selectedDoctorId;
  String? _selectedTimeSlot;
  String? _selectedDepartment;
  String phoneNumber = "";
  List<String> _doctorList = [];

  callFuction() async {
    await Provider.of<BookingPatientController>(context, listen: false)
        .department();
  }

  @override
  void initState() {
    super.initState();
    callFuction();
  }

  @override
  void dispose() {
    patientidcontroller.dispose();
    _emailController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    phnumbercontroller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var functionprovider =
        Provider.of<BookingPatientController>(context, listen: false);
    var varprovider = Provider.of<BookingPatientController>(context);
    fieldSubmitted() async {
      _doctorList.clear();
      varprovider.deptList[0];
      varprovider.timeList.clear();
      varprovider.patientBookingModel.list?.clear();
      await functionprovider.patientdata(patientidcontroller.text.trim());
      if (varprovider.patientBookingModel.list == null ||
          varprovider.patientBookingModel.list!.isEmpty) {
        _emailController.clear();
        _reasonController.clear();
        _dateController.clear();
        firstnamecontroller.clear();
        lastnamecontroller.clear();
        phnumbercontroller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No patient found'),
            backgroundColor: ColorConstants.mainRed,
          ),
        );
      } else {
        setState(() {
          firstnamecontroller.text =
              varprovider.patientBookingModel.list?[0].fname ?? "";
          lastnamecontroller.text =
              varprovider.patientBookingModel.list?[0].lname ?? "";
          _emailController.text =
              varprovider.patientBookingModel.list?[0].email ?? "";
          phoneNumber = varprovider.patientBookingModel.list?[0].phn ?? "";
          phnumbercontroller.text = varprovider.patientBookingModel.list?[0].phn
                  ?.replaceRange(0, 6, "**") ??
              "";
          _selectedDepartment = varprovider.patientBookingModel.list?[0].dep;
          _selectedDoctor = varprovider.patientBookingModel.list?[0].doc;
          _selectedDoctorId = varprovider.patientBookingModel.list?[0].empid;
        });
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstants.mainBlue,
            title: Text("New Booking"),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: patientidcontroller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            labelText: 'Patient Id',
                            prefixIcon: Icon(
                              Icons.person,
                              color: ColorConstants.mainBlue,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                await fieldSubmitted();
                              },
                              icon: const Icon(
                                Icons.check,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            await fieldSubmitted();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter a Valid Patient Id';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: firstnamecontroller,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            labelText: 'First Name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: ColorConstants.mainBlue,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (name) => name!.length < 3
                              ? "Name should be at least 3 characters"
                              : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: lastnamecontroller,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            labelText: 'Last Name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: ColorConstants.mainBlue,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: _emailController,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            labelText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: ColorConstants.mainBlue,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: phnumbercontroller,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            labelText: 'Phone Number',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: ColorConstants.mainBlue,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.length >= 7) {
                              return null;
                            } else {
                              return "Mobile number is required";
                            }
                          },
                        ),
                        const SizedBox(height: 25.0),
                        DropdownButtonFormField<String>(
                          value: _selectedDepartment,
                          hint: const Text('Select Department'),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.local_hospital,
                              color: ColorConstants.mainBlue,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          items: varprovider.deptList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            setState(() {
                              _selectedDepartment = newValue;
                            });
                            int itemid = 0;
                            _doctorList.clear();
                            varprovider.timeList.clear();
                            await functionprovider.doctors(_selectedDepartment);
                            for (var i = 0; i < _doctorList.length; i++) {
                              if (_doctorList[i] == _selectedDoctor) {
                                itemid = i;
                              }
                            }
                            await functionprovider.doctorTime(varprovider
                                .doctorsmodelclass.list?[itemid].empcode);
                            if (varprovider
                                .doctorsmodelclass.list!.isNotEmpty) {
                              for (var i = 0;
                                  i <
                                      varprovider
                                          .doctorsmodelclass.list!.length;
                                  i++) {
                                _doctorList.add(varprovider
                                        .doctorsmodelclass.list?[i].name ??
                                    "");
                              }
                            }

                            _selectedDoctor = _doctorList[0];
                            _selectedTimeSlot = varprovider.timeList[0];
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a department';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        DropdownButtonFormField<String>(
                          value: _selectedDoctor,
                          hint: const Text('Select Doctor'),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.medical_services,
                              color: ColorConstants.mainBlue,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            suffix: TextButton(
                                onPressed: () {},
                                child: const Text("check availability")),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          items: _doctorList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            int itemid = 0;
                            setState(() {
                              _selectedDoctor = newValue;
                            });
                            for (var i = 0; i < _doctorList.length; i++) {
                              if (_doctorList[i] == _selectedDoctor) {
                                itemid = i;
                              }
                            }
                            varprovider.timeList.clear();
                            await functionprovider.doctorTime(varprovider
                                .doctorsmodelclass.list?[itemid].empcode);
                            _selectedTimeSlot = varprovider.timeList[0];
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a doctor';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25.0),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Book your slot",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0ea69f),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50.0, vertical: 15.0),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: _reasonController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            labelText: 'Reason (Optional)',
                            prefixIcon: Icon(
                              Icons.edit,
                              color: ColorConstants.mainBlue,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            labelText: 'Date',
                            prefixIcon: Icon(
                              Icons.timer,
                              color: ColorConstants.mainBlue,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 25.0),
                        DropdownButtonFormField<String>(
                          value: _selectedTimeSlot,
                          hint: const Text('Select Time Slot'),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          items: varprovider.timeList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedTimeSlot = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a time slot';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                await functionprovider.patientBooking(
                                  patientId: patientidcontroller.text.trim(),
                                  fName: firstnamecontroller.text.trim(),
                                  lName: lastnamecontroller.text.trim(),
                                  eMail: _emailController.text.trim(),
                                  phNum: phoneNumber,
                                  dept: _selectedDepartment!,
                                  docId: _selectedDoctorId!,
                                  reason: _reasonController.text.trim(),
                                  date: _dateController.text.trim(),
                                  time: _selectedTimeSlot!,
                                );
                                varprovider.isSuccessful == true
                                    ? showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                "You are successfully appointed"),
                                            actions: [
                                              TextButton(
                                                child: Text("return"),
                                                onPressed: () {
                                                  patientidcontroller.clear();
                                                  _emailController.clear();
                                                  _reasonController.clear();
                                                  _dateController.clear();
                                                  firstnamecontroller.clear();
                                                  lastnamecontroller.clear();
                                                  phnumbercontroller.clear();
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          );
                                        },
                                      )
                                    : ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Appointment not Booked'),
                                          backgroundColor:
                                              ColorConstants.mainRed,
                                        ),
                                      );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0ea69f),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 15.0),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
