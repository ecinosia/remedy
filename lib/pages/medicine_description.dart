import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remedy/component/description_list.dart';
import 'package:get/get.dart';
import 'package:remedy/pages/home_page.dart';

class MedicineDescription extends StatelessWidget {
  const MedicineDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.to(HomePage()),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(3, 65, 114, 1),
          title: const Text('Medicine Description List'),
        ),
        body: ListView.builder(
            itemCount: medicineList.length,
            itemBuilder: (context, index) {
              Medicine medicine = medicineList[index];
              return Card(
                child: ListTile(
                  title: Text(medicine.title),
                  //subtitle: Text(medicine.description),
                  leading: Image.asset("images/medicine.png"),
                ),
              );
            }));
  }
}