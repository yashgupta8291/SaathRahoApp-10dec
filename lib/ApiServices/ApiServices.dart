import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:maan/Presentations/Authentication/otp.dart';
import 'package:maan/Presentations/HomePage.dart';
import 'package:maan/Presentations/UpdateProfile/UpdatePassword/UpdatePassword.dart';
import 'package:maan/Presentations/UpdateProfile/UpdatePhoneNumber/confirmPhoneNo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GetX/TokenController.dart';
import '../Models/Bhojanalya.dart';
import '../Models/Hostel.dart';
import '../Models/Office.dart';
import '../Models/Property.dart';
import '../Models/roomate.dart';
import '../Presentations/UpdateProfile/UpdateEmail/updateEmail.dart';

class ApiFunctions {
  final TokenController tokenController = Get.find();
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<void> reportUser(
      String userId, String reportedBy, String reason) async {
    try {
      // Create the request body
      final Map<String, String> body = {
        'userId': userId,
        'reportedBy': reportedBy,
        'reason': reason,
      };

      // Make the POST request to report the user
      final response = await http.post(
        Uri.parse('${baseUrl}/report_user'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Successfully reported the user

        final data = jsonDecode(response.body);
        print(data['message']);
        // Show a success message or handle the success state
      } else {
        // Handle failure response
        final data = jsonDecode(response.body);
        print('Failed to report user: ${data['message']}');
        // Show an error message
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
      // Show a failure message
    }
  }

  Future<void> deleteRoomChat(String roomId) async {
    try {
      // Make the POST request to the server
      final response = await http.delete(
        Uri.parse('$baseUrl//delete_room_chat/$roomId'),
      );

      if (response.statusCode == 200) {
        // Successfully deleted the chat
        final data = jsonDecode(response.body);
        print(data['message']);
        // Show a success message or handle the success state
      } else {
        // Handle failure response
        final data = jsonDecode(response.body);
        print('Failed to delete chat: ${data['message']}');
        // Show an error message
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
      // Show a failure message
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      // Make the POST request to the server
      final body = jsonEncode({
        'email': email,
      });
      final response = await http.post(
        Uri.parse('$baseUrl/resend-otp'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Successfully deleted the chat
        final data = jsonDecode(response.body);
        print(data['message']);
        // Show a success message or handle the success state
      } else {
        // Handle failure response
        final data = jsonDecode(response.body);
        print('Failed to delete chat: ${data['message']}');
        // Show an error message
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
      // Show a failure message
    }
  }

  Future<void> signup(
      {required String name,
      required String email,
      required String password,
      required String phoneNo,
      required BuildContext context}) async {
    final url = Uri.parse('$baseUrl/signup');
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'phoneNo': phoneNo,
    });

    print("object");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));

        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return OtpPage(
              email: email,
              phone: phoneNo,
              password: password,
              name: name,
            );
          },
        ));
      } else {
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Verify OTP function
  Future<void> verifyOTP(
      {required String email,
      required String password,
      required String otp,
      required BuildContext context}) async {
    final url = Uri.parse('$baseUrl/verify-otp');
    final body = jsonEncode({
      'email': email,
      'otp': otp,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        final Map<String, dynamic> userData = jsonDecode(response.body)['user'];
        final token = jsonDecode(response.body)['token'];
        tokenController.token.value = token;
        tokenController.couponCode.value = userData['couponCode'] ?? "";
        tokenController.name.value = userData['name'] ?? "";
        tokenController.email.value = userData['email'] ?? "";
        tokenController.address.value = userData['address'] ?? "Katni";
        tokenController.profilePic.value = userData['profilePic'] ?? "";
        tokenController.phoneNumber.value = userData['phoneNo'] ?? "";
        await prefs.setString('name', userData['name']);
        await prefs.setString('password', password);
        await prefs.setString('couponCode', userData['couponCode'] ?? "");
        await prefs.setString('email', userData['email']);
        await prefs.setString('uid', userData['_id']);
        await prefs.setString('id', userData['uid']);
        await prefs.setString('phoneNo', userData['phoneNo'] ?? '');
        await prefs.setString('profilePic', userData['profilePic'] ?? '');
        await prefs.setString('pincode', userData['pincode'] ?? '');
        await prefs.setString('address', userData['address'] ?? 'Mumbai k');
        await prefs.setString('membership', userData['membership'] ?? '');
        await prefs.setString(
            'membershipStart', userData['membershipStart'] ?? '');
        await prefs.setString('membershipEnd', userData['membershipEnd'] ?? '');
        await prefs.setBool(
            'isFeatureListing', userData['isFeatureListing'] ?? false);
        await prefs.setBool(
            'membershipExpiry', userData['membershipExpiry'] ?? false);
        await prefs.setStringList(
            'transactions', List<String>.from(userData['transactions'] ?? []));
        // print(userData['profilePic']);

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ));
        print(jsonDecode(response.body));
      } else {}
    } catch (e) {}
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(response.body);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> userData = jsonDecode(response.body)['user'];
        final token = jsonDecode(response.body)['token'];
        tokenController.token.value = token;
        tokenController.couponCode.value = userData['couponCode'] ?? "";
        tokenController.name.value = userData['name'] ?? "";
        tokenController.email.value = userData['email'] ?? "";
        tokenController.address.value = userData['address'] ?? "Katni";
        tokenController.profilePic.value = userData['profilePic'] ?? "";
        tokenController.phoneNumber.value = userData['phoneNo'] ?? "";
        tokenController.verified.value = userData['verified'] ?? false;
        // Store u;ser data in SharedPreferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setString('name', userData['name']);
        await prefs.setString('password', password);
        await prefs.setString('couponCode', userData['couponCode'] ?? "");
        await prefs.setString('email', userData['email']);
        await prefs.setString('uid', userData['_id']);
        await prefs.setString('id', userData['uid']);
        await prefs.setString('phoneNo', userData['phoneNo'] ?? '');
        await prefs.setString('profilePic', userData['profilePic'] ?? '');
        await prefs.setString('pincode', userData['pincode'] ?? '');
        await prefs.setString('address', userData['address'] ?? 'Mumbai k');
        await prefs.setString('verified', userData['verified'] ?? '');
        await prefs.setString('membership', userData['membership'] ?? '');
        await prefs.setString(
            'membershipStart', userData['membershipStart'] ?? '');
        await prefs.setString('membershipEnd', userData['membershipEnd'] ?? '');
        await prefs.setBool(
            'isFeatureListing', userData['isFeatureListing'] ?? false);
        await prefs.setBool(
            'membershipExpiry', userData['membershipExpiry'] ?? false);
        await prefs.setStringList(
            'transactions', List<String>.from(userData['transactions'] ?? []));
        // print(userData['profilePic']);

        // Navigate to HomePage
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } else {
        // Handle error responses
        print('Error: ${response.statusCode} - ${response.body}');
        // Optionally, you can show a message to the user
      }
    } catch (e) {
      print('Login error: $e');
      // Handle any exceptions here, like showing an error message to the user
    }
  }

  Future<void> forgetPassword(String email) async {
    final url = Uri.parse('$baseUrl/forget-password');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('Password reset code sent to your email.');
    } else {
      print('Failed to send password reset code: ${response.body}');
    }
  }

  Future<void> updateProfilePic(String email, String picture) async {
    final url = Uri.parse('$baseUrl/update-profile-picture');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email, 'newProfilePic': picture}),
    );

    if (response.statusCode == 200) {
      print('profil picture updated successfully');
    } else {
      print('Failed to update: ${response.body}');
    }
  }

  Future<void> verifyPasswordResetOTP(
      String email, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/verify-password-reset-otp');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      print('Password reset successful.');
    } else {
      print('Failed to reset password: ${response.body}');
    }
  }

  Future<void> submitFeedback(String uid, String feedback) async {
    final url =
        Uri.parse('$baseUrl/submit-feedback'); // Replace with your API endpoint
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'Uid': uid,
        'Feedback': feedback,
      }),
    );

    if (response.statusCode == 201) {
      print('Feedback submitted successfully: ${response.body}');
    } else {
      print('Failed to submit feedback: ${response.body}');
    }
  }

  Future<void> UpdateAddress(
      String email, String newAddress, BuildContext context) async {
    final url =
        Uri.parse('$baseUrl/updateAddress'); // Ensure baseUrl is defined
    final body = jsonEncode({
      'email': email,
      'newAddress': newAddress,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('address', newAddress);
        print(response.body);
      } else {
        print('Failed : ${response.body}');
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  Future<void> UpdateName(
      String email, String newName, BuildContext context) async {
    final url = Uri.parse('$baseUrl/updateName'); // Ensure baseUrl is defined
    final body = jsonEncode({
      'email': email,
      'newName': newName,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', newName);
        print(response.body);
      } else {
        print('Failed to add property to wishlist: ${response.body}');
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  Future<void> initiateEmailUpdate(BuildContext context, String email) async {
    final url = Uri.parse('$baseUrl/initiate-email-update');
    final body = jsonEncode({
      'email': email,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully updated email, navigate to UpdateEmailPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmEmailUpdatePage()),
        );
        print('Response body: ${response.body}');
      } else {
        print('Failed to update email: ${response.body}');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email. Please try again.')),
        );
      }
    } catch (e) {
      print('Error updating email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> initiatePhoneUpdate(BuildContext context, String email) async {
    final url = Uri.parse('$baseUrl/initiate-phone-update');
    final body = jsonEncode({
      'email': email,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully updated email, navigate to UpdateEmailPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UpdatePhoneNo()),
        );
        print('Response body: ${response.body}');
      } else {
        print('Failed to update email: ${response.body}');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email. Please try again.')),
        );
      }
    } catch (e) {
      print('Error updating email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> initiatePasswordUpdate(
    BuildContext context,
    String email,
  ) async {
    final url = Uri.parse('$baseUrl/initiate-password-update');
    final body = jsonEncode({
      'email': email,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully updated email, navigate to UpdateEmailPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UpdatePassword()),
        );
        print('Response body: ${response.body}');
      } else {
        print('Failed to update email: ${response.body}');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email. Please try again.')),
        );
      }
    } catch (e) {
      print('Error updating email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> verifyEmailUpdate(
      BuildContext context, String email, String otp, String newEmail) async {
    final url = Uri.parse('$baseUrl/verify-email-update');
    final body = jsonEncode({'email': email, 'otp': otp, 'newEmail': newEmail});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully updated email, navigate to UpdateEmailPage

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', newEmail);
        Navigator.pop(context);
        Navigator.pop(context);
        print('Response body: ${response.body}');
      } else {
        print('Failed to update email: ${response.body}');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email. Please try again.')),
        );
      }
    } catch (e) {
      print('Error updating email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> verifyPhoneUpdate(
      BuildContext context, String email, String otp, String newPhone) async {
    final url = Uri.parse('$baseUrl/verify-phone-update');
    final body = jsonEncode({'email': email, 'otp': otp, 'newPhone': newPhone});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Successfully updated email, navigate to UpdateEmailPage

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('phoneNo', newPhone);
        Navigator.pop(context);
        Navigator.pop(context);
        print('Response body: ${response.body}');
      } else {
        print('Failed to update email: ${response.body}');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email. Please try again.')),
        );
      }
    } catch (e) {
      print('Error updating email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> verifyPasswordUpdate(BuildContext context, String email,
      String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/verify-password-update');
    final body =
        jsonEncode({'email': email, 'otp': otp, 'newPassword': newPassword});

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully updated email, navigate to UpdateEmailPage

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('password', newPassword);
        Navigator.pop(context);
        Navigator.pop(context);

        print('Response body: ${response.body}');
      } else {
        print('Failed to update email: ${response.body}');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update email. Please try again.')),
        );
      }
    } catch (e) {
      print('Error updating email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<void> createConsultation({
    required String name,
    required String email,
    required String phoneNo,
    required String uid,
  }) async {
    final url =
        Uri.parse('$baseUrl/createConsultation'); // Replace with your API URL

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Name': name,
          'Email': email,
          'PhoneNo': phoneNo,
          'Uid': uid,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Consultation created successfully: ${data['consultation']}');
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to create consultation: ${errorData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

// Function to submit the roommate form
  Future<void> submitRoommateForm({
    required String name,
    required String location,
    required String userUid,
    required String hometown,
    required String roomPreference,
    required String budget,
    required String languagePreference,
    required String preferredGender,
    required String occupation,
    required String moveInDetails,
    required String pincode,
    required bool feature,
    required String locationPreference,
    required List<String> interests,
    required String description,
    String? image, // Optional field
    bool isApproved = false,
    String categoryType = 'Roommate',
  }) async {
    final String url =
        '${baseUrl}/create-roommate'; // Replace with your API URL

    // Prepare the form data as a Map
    final Map<String, dynamic> formData = {
      'uid': userUid, // Matches the field in the mongoose schema
      'name': name,
      'pincode': pincode,
      'location': location,
      'hometown': hometown,
      'budget': budget,
      'roomPreference': roomPreference,
      'languagePreference': languagePreference,
      'genderPreference':
          preferredGender, // Ensure this matches the backend enum
      'occupation': occupation,
      'moveInDate': moveInDetails, // Adjust the field name for backend
      'locationPreference': locationPreference,
      'interests': interests,
      'description': description,
      'image': image ?? '', // Optional, default to empty string if null
      'isApproved': isApproved,
      'FeatureListing':
          feature, // Send as false, or adjust based on your app logic
      'categoryType': categoryType,
    };

    print(formData);

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData), // Convert the form data to JSON
      );
      print(response.body);

      // Check if the response is successful
      if (response.statusCode == 201) {
        print('Form created successfully');
        // Successfully submitted the form
      } else {
        // Handle failure (e.g., show an error message to the user)
      }
    } catch (e) {
      print("Error submitting form: $e");
      // Handle error if the request fails
    }
  }

  Future<void> submitRentAgreementForm({
    required String ownerName,
    required String ownerNumber,
    required String ownerAddress,
    required String tenantName,
    required String tenantAddress,
    required String tenantPhoneNo,
    required String propertyState,
    required String pincode,
    required String propertyCity,
    required String propertyPincode,
    required String propertyLocalAddress,
    required int monthlyRent,
    required int securityDeposit,
    required String lockInPeriod,
    required String noticePeriod,
    required String agreementValidity,
    required DateTime agreementStartDate,
    required String createdBy,
    required String emailAddress,
    required List<Map<String, dynamic>>
        itemsProvided, // e.g., [{'itemName': 'Chair', 'itemQuantity': 2}]
    required String uid,
  }) async {
    final url = Uri.parse(
        'https://yourapi.com/api/rentAgreement'); // Replace with your API URL

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'OwnerName': ownerName,
          'pincode': pincode,
          'OwnerNumber': ownerNumber,
          'OwnerAddress': ownerAddress,
          'TenantName': tenantName,
          'TenantAddress': tenantAddress,
          'TenantPhoneNo': tenantPhoneNo,
          'PropertyState': propertyState,
          'PropertyCity': propertyCity,
          'PropertyPincode': propertyPincode,
          'PropertyLocalAddress': propertyLocalAddress,
          'MonthlyRent': monthlyRent,
          'SecurityDeposit': securityDeposit,
          'LockInPeriod': lockInPeriod,
          'NoticePeriod': noticePeriod,
          'AgreementValidity': agreementValidity,
          'AgreementStartDate': agreementStartDate.toIso8601String(),
          'CreatedBy': createdBy,
          'EmailAddress': emailAddress,
          'ItemsProvided': itemsProvided,
          'Uid': uid,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Rent agreement created successfully: ${data['message']}');
      } else {
        final errorData = jsonDecode(response.body);
        print('Failed to create rent agreement: ${errorData['message']}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<bool> createRoomForm({
    required String uid,
    required String roomName,
    required String location,
    required String pincode,
    required String title,
    String? monthlyMaintenance,
    required String floorNo,
    required String totalFloor,
    required String carpetArea,
    required String facing,
    String? advance,
    required String bachelors,
    required String bedrooms,
    required String listedBy,
    required String bathroom,
    required String furnished,
    required String parking,
    required bool featureListing,
    required String categoryOfPeople,
    required List<String> amenities,
    String? description,
    bool isApproved = false,
    required List<String> images,
  }) async {
    final Uri apiUrl =
        Uri.parse('${baseUrl}/create-room'); // Replace with your API URL

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          // Set appropriate header
          // 'Authorization': 'Bearer <YourAuthToken>', // If you are using JWT or some form of authentication
        },
        body: json.encode({
          'uid': uid,
          'roomName': roomName,
          'location': location,
          'pincode': pincode,
          'title': title,
          'monthlyMaintenance': monthlyMaintenance,
          'floorNo': floorNo,
          'totalFloor': totalFloor,
          'carpetArea': carpetArea,
          'facing': facing,
          'advance': advance,
          'bachelors': bachelors,
          'bedrooms': bedrooms,
          'listedBy': listedBy,
          'bathroom': bathroom,
          'furnished': furnished,
          'parking': parking,
          'categoryOfPeople': categoryOfPeople,
          'amenities': amenities,
          'description': description,
          'isApproved': isApproved,
          'images': images,
          'featureListing': featureListing
        }),
      );

      if (response.statusCode == 201) {
        // Successfully created
        return true;
      } else {
        // Failed to create
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> sendHostelDetails({
    required String hostelName,
    required String rent,
    required String location,
    required String HostelDes,
    required String maintainance,
    required String timing,
    required String totalfloor,
    required String deposit,
    required String gender,
    required String bathrom,
    required String dining,
    required String furnished,
    required String parking,
    required String sharing,
    required String pincode,
    required String electricity,
    required String categoryType,
    required String visitors,
    required List<String> images,
    required List<String> amenities,
    required bool isApproved,
    required bool feature,
    required String uid,
  }) async {
    final String url =
        '${baseUrl}/Createhostels'; // Replace with your API endpoint

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'hostelName': hostelName,
          'rent': rent,
          'location': location,
          'maintenance': maintainance,
          'pincode': pincode,
          'timings': timing,
          'totalFloor': totalfloor,
          'deposit': deposit,
          'gender': gender,
          'bathroom': bathrom,
          'dining': dining,
          'furnished': furnished,
          'parking': parking,
          'sharing': sharing,
          'electricity': electricity,
          'visitors': visitors,
          'images': images,
          'amenities': amenities,
          'description': HostelDes,
          'category': categoryType,
          'isApproved': false,
          'uid': uid,
          'FeatureListing': feature
        }),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('Hostel details submitted successfully!');
      }
      if (response.statusCode == 200) {
        print('Hostel details submitted successfully!');
      } else {
        print('Failed to submit hostel details. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> createBhojnalaya({
    required List<String> bhojnalayaImages,
    required String location,
    required String bhojnalayaName,
    required String categoryType,
    required String MonthlyCharge1,
    required List<String> amenities,
    required String parking,
    required String specialThali,
    required String MonthlyCharge2,
    required String priceOfThali,
    required String timings,
    required String vegOrNonVeg,
    required String parcelOfFood,
    required String description,
    required bool isApproved,
    required bool feature,
    required String uid,
    required String pincode,
  }) async {
    // Define the API endpoint
    const String apiUrl =
        '${baseUrl}/Createbhojnalayas'; // Replace with actual API URL

    // Prepare the data to be sent in the request body
    Map<String, dynamic> requestBody = {
      'images': bhojnalayaImages,
      'location': location,
      'bhojanalayName': bhojnalayaName,
      'CategoryType': categoryType,
      'monthlyCharge1': MonthlyCharge1,
      'Amenities': amenities,
      'parking': parking,
      'specialThali': specialThali,
      'monthlyCharge2': MonthlyCharge2,
      'priceOfThali': priceOfThali,
      'timings': timings,
      'pincode': pincode,
      'veg': vegOrNonVeg,
      'parcelOfFood': parcelOfFood,
      'description': description,
      'isApproved': isApproved,
      'FeatureListing': feature,
      'uid': uid,
    };

    // Send a POST request to the API
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        // If the server returns a successful response
        print('object');
        Map<String, dynamic> responseData = json.decode(response.body);
        // Return the response data from the server
      } else {
        // If the server returns an error response
        throw Exception('Failed to create Bhojnalaya');
      }
    } catch (e) {
      // Handle errors, such as network issues
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> createOfficeListing({
    required String title,
    required String officeLocation,
    required String officeTitle,
    required String officeMonthlyMaintenance,
    required String officeFloorNo,
    required String officeTotalFloor,
    required String carpetArea,
    required String officeFacing,
    required String officeDeposit,
    required String parkingAvailable,
    required String noOfCabins,
    required String pincode,
    required String noOfBathrooms,
    required String furnished,
    required String listedBy,
    required String officeId,
    List<String>? amenities,
    required String officeDescription,
    required bool isApproved,
    required bool feature,
    required List<String>? officeImages,
  }) async {
    final url = Uri.parse('${baseUrl}/office-listings');

    final body = jsonEncode({
      "officeName": title,
      "location": officeLocation,
      "title": officeTitle,
      "monthlyMaintenance": officeMonthlyMaintenance,
      "floorNo": officeFloorNo,
      "totalFloor": officeTotalFloor,
      "carpetArea": carpetArea,
      "facing": officeFacing,
      "deposit": officeDeposit,
      "parking": parkingAvailable,
      "cabins": noOfCabins,
      "bathroom": noOfBathrooms,
      "furnished": furnished,
      'pincode': pincode,
      "listedBy": listedBy,
      "amenities": amenities ?? [],
      "description": officeDescription,
      "isApproved": isApproved,
      "FeatureListing": feature,
      "uid": officeId,
      "images": officeImages ?? [],
    });

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Successful request
        print("Office listing created successfully: ${response.body}");
      } else {
        // Handle error response
        print("Failed to create office listing: ${response.body}");
      }
    } catch (error) {
      print("Error creating office listing: $error");
    }
  }

  Future<void> createTransaction(double amount, String membership) async {
    print(tokenController.token.value);
    final response = await http.post(
      Uri.parse('${baseUrl}/create-transaction'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenController.token.value}',
      },
      body: jsonEncode({'amount': amount, 'membership': membership}),
    );

    if (response.statusCode == 201) {
      print('Transaction created successfully: ${response.body}');
    } else {
      throw Exception('Failed to create transaction: ${response.body}');
    }
  }

  Future<void> deleteUser(String token) async {
    final url = Uri.parse(
        'http://10.2.2:8000/api/deleteAccount'); // Replace with your API URL

    final headers = {
      'Authorization': 'Bearer $token', // Pass the JWT token in the headers
      'Content-Type': 'application/json', // Content-Type header
    };

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Successfully deleted
        print('User deleted successfully');
        final data = jsonDecode(response.body);
        print(data);
      } else {
        // Handle failure
        print('Failed to delete user: ${response.statusCode}');
        final data = jsonDecode(response.body);
        print(data['message']);
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSearchResults(
      String query) async {
    if (query.isEmpty) {
      return [];
    }

    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/search?q=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);

      return results.map((result) {
        // Get the schema from the result
        final schema = result['schema'];
        final res = result['result'];
        final user = result['user']; // Extract user data
        print(schema);
        // Create a Map to return both result and user
        final data = {
          'schema': schema,
          'result':
              _mapResultToModel(res, schema), // Map result based on schema
          'user': user, // Add user data to the returned map
        };

        return data; // Return both result and user together
      }).toList();
    } else {
      // Handle non-200 responses
      throw Exception('Failed to fetch search results');
    }
  }
static Future<List<Map<String, dynamic>>> fetchCityResults(
      String query) async {
    if (query.isEmpty) {
      return [];
    }

    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/searchCity?city=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);

      return results.map((result) {
        // Get the schema from the result
        final schema = result['schema'];
        final res = result['result'];
        final user = result['user']; // Extract user data
        print(schema);
        // Create a Map to return both result and user
        final data = {
          'schema': schema,
          'result':
              _mapResultToModel(res, schema), // Map result based on schema
          'user': user, // Add user data to the returned map
        };

        return data; // Return both result and user together
      }).toList();
    } else {
      // Handle non-200 responses
      throw Exception('Failed to fetch search results');
    }
  }

// Helper function to map result to the correct model based on schema
  static dynamic _mapResultToModel(Map<String, dynamic> res, String schema) {
    if (res is! Map<String, dynamic>) {
      print('Unexpected result type: ${res.runtimeType}');
      return res;
    }
    switch (schema) {
      case 'RoomForm':
        return Property.fromJson(res); // Return mapped Property model
      case 'Office':
        return Office.fromJson(res);
      case 'Hostel':
        return Hostel.fromJson(res);
      case 'Bhojnalaya':
        return Bhojnalaya.fromJson(res);
      case 'Roommate':
        return Roommate.fromJson(res);
      default:
        return res; // If schema is unrecognized, return the raw result
    }
  }

  static Future<bool> verifyCoupon(String couponCode) async {
    final url =
        Uri.parse('${baseUrl}/verify-coupon'); // Replace with your API endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'couponCode': couponCode}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Coupon data: ${data['data']}'); // Log coupon details if needed
        return true; // Coupon is valid
      } else if (response.statusCode == 404) {
        print('Error: ${jsonDecode(response.body)['message']}');
        return false; // Coupon not found
      } else {
        print('Error: ${jsonDecode(response.body)['message']}');
        return false; // Other errors
      }
    } catch (e) {
      print('Error verifying coupon: $e');
      return false; // Server or network error
    }
  }

  static Future<bool> _performAction(String endpoint, String roomid) async {
    final url = Uri.parse('$baseUrl/$endpoint?chatRoomId=$roomid');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(response.body); // Log details if needed
        return true; // Action was successful
      } else {
        final message = jsonDecode(response.body)['message'];
        print('Error: $message');
        return false; // Action failed
      }
    } catch (e) {
      print('Error performing action: $e');
      return false; // Server or network error
    }
  }

  // Specific actions using the generic method
  static Future<bool> muteNotifications(String roomid) async {
    return await _performAction('mute-user', roomid);
  }

  static Future<bool> unmuteNotifications(String roomid) async {
    return await _performAction('unmute-user', roomid);
  }

  static Future<bool> blockUser(String roomid) async {
    return await _performAction('block-user', roomid);
  }

  static Future<bool> unblockUser(String roomid) async {
    return await _performAction('unblock-user', roomid);
  }

  static Future<bool> toggleImportant(String roomid) async {
    return await _performAction('important', roomid);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print(googleAuth);
      const String baseUrl = 'http://10.0.2.2:8000/api';

      // Send the Google Auth details to your backend
      final response = await http.post(
        Uri.parse('${baseUrl}/google-login'),
        body: json.encode({
          'name': googleUser.displayName,
          'email': googleUser.email,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final responseBody = json.decode(response.body);
      print(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // User logged in or created successfully
        print('User logged in: ${responseBody['message']}');
        final Map<String, dynamic> userData = jsonDecode(response.body)['user'];
        final token = jsonDecode(response.body)['token'];
        tokenController.token.value = token;
        tokenController.couponCode.value = userData['couponCode'] ?? "";
        tokenController.name.value = userData['name'] ?? "";
        tokenController.email.value = userData['email'] ?? "";
        tokenController.address.value = userData['address'] ?? "Katni";
        tokenController.profilePic.value = userData['profilePic'] ?? "";
        print(tokenController.token.value);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setString('name', userData['name']);
        // await prefs.setString('password', password);
        await prefs.setString('couponCode', userData['couponCode'] ?? "");
        await prefs.setString('email', userData['email']);
        await prefs.setString('uid', userData['_id']);
        await prefs.setString('id', userData['uid']);
        await prefs.setString('phoneNo', userData['phoneNo'] ?? '');
        await prefs.setString('profilePic', userData['profilePic'] ?? '');
        await prefs.setString('pincode', userData['pincode'] ?? '');
        await prefs.setString('address', userData['address'] ?? '');
        await prefs.setString('membership', userData['membership'] ?? '');
        await prefs.setString(
            'membershipStart', userData['membershipStart'] ?? '');
        await prefs.setString('membershipEnd', userData['membershipEnd'] ?? '');
        await prefs.setBool(
            'isFeatureListing', userData['isFeatureListing'] ?? false);
        await prefs.setBool(
            'membershipExpiry', userData['membershipExpiry'] ?? false);
        await prefs.setStringList(
            'transactions', List<String>.from(userData['transactions'] ?? []));
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
        // You can save user data locally or navigate to another screen
        // Example: Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle other response statuses or errors
        print('Error: ${responseBody['message']}');
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
  }

  Future<void> checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('IsLogin');
    String? email = prefs.getString('email');
    String? name = prefs.getString('name');

    if (login != null) {
      // User is already logged in with Google, proceed with backend authentication or navigate to home screen
      // Optionally, send the stored email to your backend to verify the user session
      final response = await http.post(
        Uri.parse('${baseUrl}/google-login'),
        body: json.encode({'email': email, 'name': name}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('User logged in: ${responseBody['user']}');
        final Map<String, dynamic> userData = jsonDecode(response.body)['user'];
        final token = jsonDecode(response.body)['token'];
        tokenController.token.value = token;
        tokenController.couponCode.value = userData['couponCode'] ?? "";
        tokenController.name.value = userData['name'] ?? "";
        tokenController.email.value = userData['email'] ?? "";
        tokenController.address.value = userData['address'] ?? "";
        tokenController.profilePic.value = userData['profilePic'] ?? "";
        tokenController.phoneNumber.value = userData['phoneNo'] ?? "";

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', true);
        await prefs.setString('name', userData['name']);
        // await prefs.setString('password', password);
        await prefs.setString('couponCode', userData['couponCode'] ?? "");
        await prefs.setString('email', userData['email']);
        await prefs.setString('uid', userData['_id']);
        await prefs.setString('id', userData['uid']);
        await prefs.setString('phoneNo', userData['phoneNo'] ?? '');
        await prefs.setString('profilePic', userData['profilePic'] ?? '');
        await prefs.setString('pincode', userData['pincode'] ?? '');
        await prefs.setString('address', userData['address'] ?? '');
        await prefs.setString('membership', userData['membership'] ?? '');
        await prefs.setString(
            'membershipStart', userData['membershipStart'] ?? '');
        await prefs.setString('membershipEnd', userData['membershipEnd'] ?? '');
        await prefs.setBool(
            'isFeatureListing', userData['isFeatureListing'] ?? false);
        await prefs.setBool(
            'membershipExpiry', userData['membershipExpiry'] ?? false);
        await prefs.setStringList(
            'transactions', List<String>.from(userData['transactions'] ?? []));
      }
      // Successfully authenticated, proceed to the home screen
    }
  }
}
