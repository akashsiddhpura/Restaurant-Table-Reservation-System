
 Function(String) nameValidator = (String val){
   RegExp nameValid = RegExp(
       r"^[a-zA-Z]+");
   if(val.isEmpty){
     return "Name Should Not Empty";
   }else if (!nameValid.hasMatch(val)){
     return "Example : Flutter";
   }
   else if(val.length < 5){
     return "Name Should Contains Minimum 5 Characters";
   }
   else {
     return null;
   }
 };

 Function(String) mobileValidator = (String val){
   RegExp mobileValid = RegExp(
       r"^[6-9]\d{9}$");
   if(val.isEmpty){
     return "Please Enter Valid Mobile Number";
   }else if(!mobileValid.hasMatch(val)){
     return "Invalid Mobile Number";
   }
   else if(val.length < 10){
     return "Mobile Number Should Contains Minimum 10 Characters";
   }
   else {
     return null;
   }
 };

 Function(String) emailValidator = (String val){
   RegExp emailValid = RegExp(
       r"^[a-z0-9.a-z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
   if(val.isEmpty){
     return "Email Should Not Empty";
   }else if (!emailValid.hasMatch(val)) {
     return "Example : example@gmail.com";
   } else {
     return null;
   }
 };

 Function(String) passwordValidator = (String val){
   if(val.isEmpty){
     return "Password Should Not Empty";
   }else if (val.length < 6) {
     return "Password length Should be 6";
   } else {
     return null;
   }
 };

 Function(String) addressValidator = (String val){
   if(val.isEmpty){
     return "Address Should Not Empty";
   }else if(val.length < 10){
     return "This Address to Short";
   }else {
     return null;
   }
 };

 Function(String) pinCodeValidator = (String val){
   RegExp pinCodeValid = RegExp(
       r"^[0-9]+");
   if(val.isEmpty){
     return "Please Enter Valid Pin Code";
   }else if (!pinCodeValid.hasMatch(val)){
     return "Example : 395006";
   }
   else if(val.length < 6){
     return "Pin Code Length Should 6 Digits";
   }
   else {
     return null;
   }
 };



 Function(String) tableValidator = (String val){
   RegExp tableValid = RegExp(
       r"^[0-9]+");
   if(val.isEmpty){
     return "Please Enter Valid Numbers Of Tables";
   }else if (!tableValid.hasMatch(val)){
     return "Example : 36";
   }
   else if(val.length == 0 && val.length < 3){
     return "Number Of Tables Length Should 2 Or 1 Digits";
   }
   else {
     return null;
   }
 };

 Function(String) capacityValidator = (String val){
   RegExp personValid = RegExp(
       r"^[1-9]+");
   if(val.isEmpty){
     return "Please Enter Valid Numbers Of Persons";
   }else if (!personValid.hasMatch(val)){
     return "Example : 360 & First Digit should Not 0";
   } else if(val.length < 2 && val.length < 4){
     return "Number Of Persons Length Should 3 Or 2 Digits";
   }
   else {
     return null;
   }
 };


 Function(String) rejectValidator = (String val){
   if(val.isEmpty){
     return "It should not empty";
   }else if (val != "REJECT"){
     return "Invalid text";
   } else {
     return null;
   }
 };

 Function(String) rejectReasonValidator = (String val){
   if(val.isEmpty){
     return "Reason should not empty";
   } else if(val.length < 5){
     return "Reason was to short please enter something";
   }
   else {
     return null;
   }
 };

 Function(String) acceptValidator = (String val){
   if(val.isEmpty){
     return "It should not empty";
   }else if (val != "ACCEPT"){
     return "Invalid text";
   } else {
     return null;
   }
 };


 Function(String) personValidator = (String val){
   RegExp tableValid = RegExp(
       r"^[0-9]+");
   if(val.isEmpty){
     return "Please Enter Valid Number";
   }else if (!tableValid.hasMatch(val)){
     return "Example : 36 or 06";
   }
   else if(val.length == 0 && val.length < 3){
     return "Number Of Tables Length Should 2 Or 1 Digits";
   }
   else {
     return null;
   }
 };

 Function(String) priceValidator = (String val){
   RegExp priceValid = RegExp(
       r"^[0-9]+");
   if(val.isEmpty){
     return "Please enter valid number";
   }else if (!priceValid.hasMatch(val)){
     return "Example : 36 or 06";
   }
   else if(val.length == 0 || val.length == 1){
     return "Example : 36 or 06";
   }
   else {
     return null;
   }
 };