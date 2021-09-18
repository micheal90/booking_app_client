
import 'package:booking_app_client/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUsers {

  CollectionReference employeeCollectionRef =
      FirebaseFirestore.instance.collection('employee');

  

  Future getEmployees() async {
    var emps = await employeeCollectionRef.get();
    return emps.docs;
  }

  Future addEmployeeData(EmployeeModel employeeModel) async {
    await employeeCollectionRef.doc(employeeModel.id).set(employeeModel.toMap());
  }

  Future addEployeeData(EmployeeModel employeeModel) async {
    await employeeCollectionRef
        .doc(employeeModel.id)
        .set(employeeModel.toMap());
  }

  

  Future getEmployeeData(String employeeId) async {
    return await employeeCollectionRef.doc(employeeId).get();
  
  }

  

  Future deleteEmployee(String employeeId) async {
    await employeeCollectionRef.doc(employeeId).delete();
  }

 

  Future updateEmployee(EmployeeModel employeeModel) async {
    await employeeCollectionRef
        .doc(employeeModel.id)
        .update(employeeModel.toMap());
  }
}
