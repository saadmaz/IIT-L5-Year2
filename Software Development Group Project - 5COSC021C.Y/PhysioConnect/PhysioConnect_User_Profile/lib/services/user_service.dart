// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user_model.dart';
// import '../models/user_stats.dart';
// import '../models/achievement_model.dart';

// class UserService {
//   final String baseUrl = 'https://your-api-url.com/api';
  
//   // Get current user profile
//   Future<User> getCurrentUser() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
      
//       if (token == null) {
//         throw Exception('Not authenticated');
//       }
      
//       final response = await http.get(
//         Uri.parse('$baseUrl/users/me'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return User.fromJson(data);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Failed to get user profile');
//       }
//     } catch (e) {
//       // For development, return mock data
//       await Future.delayed(const Duration(seconds: 1));
//       return User(
//         id: 1,
//         name: 'Dr. Jane Smith',
//         email: 'jane.smith@example.com',
//         profilePicture: 'https://randomuser.me/api/portraits/women/44.jpg',
//         phoneNumber: '+1 (555) 123-4567',
//         specializations: [
//           'Sports Rehabilitation',
//           'Orthopedic',
//           'Manual Therapy',
//         ],
//         professionalCredentials: 'PT, DPT, CSCS',
//         yearsOfExperience: 8,
//         licenseNumber: 'PT12345678',
//         bio: 'Experienced physiotherapist specializing in sports rehabilitation and orthopedic care. I focus on evidence-based treatment plans tailored to each patient\'s unique needs and goals. My approach combines manual therapy with therapeutic exercise to achieve optimal outcomes.',
//         certifications: [
//           'Certified Strength and Conditioning Specialist (CSCS)',
//           'Orthopedic Clinical Specialist (OCS)',
//           'Manual Therapy Certification (MTC)',
//         ],
//       );
      
//       // In production, uncomment:
//       // rethrow;
//     }
//   }

//   // Setup or update user profile
//   Future<void> setupProfile({
//     required String name,
//     String? professionalCredentials,
//     String? licenseNumber,
//     String? phoneNumber,
//     String? bio,
//     List<String>? specializations,
//     int? yearsOfExperience,
//     String? profilePicture,
//   }) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
      
//       if (token == null) {
//         throw Exception('Not authenticated');
//       }
      
//       final response = await http.put(
//         Uri.parse('$baseUrl/users/profile'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode({
//           'name': name,
//           'professional_credentials': professionalCredentials,
//           'license_number': licenseNumber,
//           'phone_number': phoneNumber,
//           'bio': bio,
//           'specializations': specializations,
//           'years_of_experience': yearsOfExperience,
//           'profile_picture': profilePicture,
//         }),
//       );

//       if (response.statusCode != 200) {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Failed to update profile');
//       }
//     } catch (e) {
//       // For development, just simulate API call
//       await Future.delayed(const Duration(seconds: 1));
      
//       // In production, uncomment:
//       // rethrow;
//     }
//   }

//   // Get user statistics and achievements
//   Future<UserStats> getUserStats() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
      
//       if (token == null) {
//         throw Exception('Not authenticated');
//       }
      
//       final response = await http.get(
//         Uri.parse('$baseUrl/users/stats'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return UserStats.fromJson(data);
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Failed to get user stats');
//       }
//     } catch (e) {
//       // For development, return mock data
//       await Future.delayed(const Duration(seconds: 1));
      
//       // Create mock achievements
//       final achievements = [
//         Achievement(
//           id: 1,
//           title: 'Century Club',
//           description: 'Completed 100 patient sessions',
//           iconUrl: '',
//           awardedDate: DateTime.now().subtract(const Duration(days: 30)),
//           type: AchievementType.appointment,
//           progress: 100,
//           goal: 100,
//         ),
//         Achievement(
//           id: 2,
//           title: 'Knowledge Seeker',
//           description: 'Completed 5 professional development courses',
//           iconUrl: '',
//           awardedDate: DateTime.now().subtract(const Duration(days: 60)),
//           type: AchievementType.certification,
//           progress: 5,
//           goal: 5,
//         ),
//         Achievement(
//           id: 3,
//           title: 'Network Builder',
//           description: 'Connected with 50 professionals',
//           iconUrl: '',
//           awardedDate: DateTime.now().subtract(const Duration(days: 90)),
//           type: AchievementType.connection,
//           progress: 50,
//           goal: 50,
//         ),
//         Achievement(
//           id: 4,
//           title: 'Master Specialist',
//           description: 'Complete 10 specialization courses',
//           iconUrl: '',
//           awardedDate: DateTime.now().subtract(const Duration(days: 120)),
//           type: AchievementType.specialization,
//           progress: 7,
//           goal: 10,
//         ),
//       ];
      
//       // Create mock professional developments
//       final professionalDevelopments = [
//         ProfessionalDevelopment(
//           id: 1,
//           title: 'Advanced Manual Therapy Techniques',
//           type: 'course',
//           completionDate: DateTime.now().subtract(const Duration(days: 45)),
//           certificateUrl: 'https://example.com/cert1.pdf',
//           provider: 'National Physical Therapy Association',
//           creditHours: 20,
//           description: 'Comprehensive course on advanced manual therapy techniques for treating complex musculoskeletal conditions.',
//         ),
//         ProfessionalDevelopment(
//           id: 2,
//           title: 'Sports Rehabilitation Conference 2023',
//           type: 'conference',
//           completionDate: DateTime.now().subtract(const Duration(days: 90)),
//           provider: 'International Sports Medicine Society',
//           creditHours: 16,
//           description: 'Annual conference covering latest research and techniques in sports rehabilitation.',
//         ),
//         ProfessionalDevelopment(
//           id: 3,
//           title: 'Therapeutic Taping Workshop',
//           type: 'workshop',
//           completionDate: DateTime.now().subtract(const Duration(days: 120)),
//           certificateUrl: 'https://example.com/cert2.pdf',
//           provider: 'SporthTape Academy',
//           creditHours: 8,
//           description: 'Hands-on workshop for therapeutic taping techniques.',
//         ),
//       ];
      
//       return UserStats(
//         totalAppointments: 350,
//         completedAppointments: 312,
//         totalPatients: 145,
//         connectionCount: 78,
//         achievements: achievements,
//         professionalDevelopments: professionalDevelopments,
//         totalCertifications: 5,
//       );
      
//       // In production, uncomment:
//       // rethrow;
//     }
//   }

//   // Update user preferences
//   Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
      
//       if (token == null) {
//         throw Exception('Not authenticated');
//       }
      
//       // Save locally
//       for (var entry in preferences.entries) {
//         if (entry.value is bool) {
//           await prefs.setBool(entry.key, entry.value);
//         } else if (entry.value is String) {
//           await prefs.setString(entry.key, entry.value);
//         } else if (entry.value is int) {
//           await prefs.setInt(entry.key, entry.value);
//         } else if (entry.value is double) {
//           await prefs.setDouble(entry.key, entry.value);
//         }
//       }
      
//       // Save on server
//       final response = await http.put(
//         Uri.parse('$baseUrl/users/preferences'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(preferences),
//       );

//       if (response.statusCode != 200) {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Failed to update preferences');
//       }
//     } catch (e) {
//       // For development, just update local preferences
//       // We already did that above, so just simulate API call
//       await Future.delayed(const Duration(seconds: 1));
      
//       // In production, you might want to revert local changes if API fails
//       // and re-throw the exception
//       // rethrow;
//     }
//   }

//   // Get user's connections
//   Future<List<User>> getUserConnections() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
      
//       if (token == null) {
//         throw Exception('Not authenticated');
//       }
      
//       final response = await http.get(
//         Uri.parse('$baseUrl/users/connections'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => User.fromJson(json)).toList();
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Failed to get user connections');
//       }
//     } catch (e) {
//       // For development, return mock data
//       await Future.delayed(const Duration(seconds: 1));
      
//       // Create mock connections
//       return [
//         User(
//           id: 2,
//           name: 'Dr. John Davis',
//           email: 'john.davis@example.com',
//           profilePicture: 'https://randomuser.me/api/portraits/men/32.jpg',
//           professionalCredentials: 'PT, OCS',
//           specializations: ['Orthopedic', 'Pain Management'],
//         ),
//         User(
//           id: 3,
//           name: 'Dr. Sarah Johnson',
//           email: 'sarah.johnson@example.com',
//           profilePicture: 'https://randomuser.me/api/portraits/women/67.jpg',
//           professionalCredentials: 'PT, DPT, GCS',
//           specializations: ['Geriatric', 'Neurological'],
//         ),
//         User(
//           id: 4,
//           name: 'Dr. Michael Chen',
//           email: 'michael.chen@example.com',
//           profilePicture: 'https://randomuser.me/api/portraits/men/75.jpg',
//           professionalCredentials: 'PT, DPT, SCS',
//           specializations: ['Sports Rehabilitation', 'Vestibular Rehabilitation'],
//         ),
//       ];
      
//       // In production, uncomment:
//       // rethrow;
//     }
//   }

//   // Add professional development
//   Future<void> addProfessionalDevelopment(ProfessionalDevelopment development) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
      
//       if (token == null) {
//         throw Exception('Not authenticated');
//       }
      
//       final response = await http.post(
//         Uri.parse('$baseUrl/users/professional-development'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: jsonEncode(development.toJson()),
//       );

//       if (response.statusCode != 201) {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Failed to add professional development');
//       }
//     } catch (e) {
//       // For development, just simulate API call
//       await Future.delayed(const Duration(seconds: 1));
      
//       // In production, uncomment:
//       // rethrow;
//     }
//   }

//   // Search for professionals
//   Future<List<User>> searchProfessionals(String query, {List<String>? specializations}) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
      
//       if (token == null) {
//         throw Exception('Not authenticated');
//       }
      
//       final queryParams = {
//         'q': query,
//       };
      
//       if (specializations != null && specializations.isNotEmpty) {
//         queryParams['specializations'] = specializations.join(',');
//       }
      
//       final uri = Uri.parse('$baseUrl/users/search').replace(queryParameters: queryParams);
      
//       final response = await http.get(
//         uri,
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => User.fromJson(json)).toList();
//       } else {
//         final error = jsonDecode(response.body);
//         throw Exception(error['message'] ?? 'Failed to search professionals');
//       }
//     } catch (e) {
//       // For development, return mock data
//       await Future.delayed(const Duration(seconds: 1));
      
//       // Create mock search results
//       return [
//         User(
//           id: 5,
//           name: 'Dr. Emily Rodriguez',
//           email: 'emily.rodriguez@example.com',
//           profilePicture: 'https://randomuser.me/api/portraits/women/23.jpg',
//           professionalCredentials: 'PT, DPT, WCS',
//           specializations: ['Women\'s Health', 'Orthopedic'],
//         ),
//         User(
//           id: 6,
//           name: 'Dr. Robert Kim',
//           email: 'robert.kim@example.com',
//           profilePicture: 'https://randomuser.me/api/portraits/men/52.jpg',
//           professionalCredentials: 'PT, DPT',
//           specializations: ['Neurological', 'Pediatric'],
//         ),
//       ];
      
//       // In production, uncomment:
//       // rethrow;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/user_stats.dart';
import '../models/achievement_model.dart';

class UserService {
  final String baseUrl = 'https://your-api-url.com/api';
  
  // Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get user profile');
      }
    } catch (e) {
      // For development, return mock data
      await Future.delayed(const Duration(seconds: 1));
      return User(
        id: 1,
        name: 'Dr. Jane Smith',
        email: 'jane.smith@example.com',
        profilePicture: 'https://randomuser.me/api/portraits/women/44.jpg',
        phoneNumber: '+1 (555) 123-4567',
        specializations: [
          'Sports Rehabilitation',
          'Orthopedic',
          'Manual Therapy',
        ],
        professionalCredentials: 'PT, DPT, CSCS',
        yearsOfExperience: 8,
        licenseNumber: 'PT12345678',
        bio: 'Experienced physiotherapist specializing in sports rehabilitation and orthopedic care. I focus on evidence-based treatment plans tailored to each patient\'s unique needs and goals. My approach combines manual therapy with therapeutic exercise to achieve optimal outcomes.',
        certifications: [
          'Certified Strength and Conditioning Specialist (CSCS)',
          'Orthopedic Clinical Specialist (OCS)',
          'Manual Therapy Certification (MTC)',
        ],
      );
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Setup or update user profile
  Future<void> setupProfile({
    required String name,
    String? professionalCredentials,
    String? licenseNumber,
    String? phoneNumber,
    String? bio,
    List<String>? specializations,
    int? yearsOfExperience,
    String? profilePicture,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      final response = await http.put(
        Uri.parse('$baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'professional_credentials': professionalCredentials,
          'license_number': licenseNumber,
          'phone_number': phoneNumber,
          'bio': bio,
          'specializations': specializations,
          'years_of_experience': yearsOfExperience,
          'profile_picture': profilePicture,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      // For development, just simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Get user statistics and achievements
  Future<UserStats> getUserStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/users/stats'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserStats.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get user stats');
      }
    } catch (e) {
      // For development, return mock data
      await Future.delayed(const Duration(seconds: 1));
      
      // Create mock achievements
      final achievements = [
        Achievement(
          id: 1,
          title: 'Century Club',
          description: 'Completed 100 patient sessions',
          iconUrl: '',
          awardedDate: DateTime.now().subtract(const Duration(days: 30)),
          type: AchievementType.appointment,
          progress: 100,
          goal: 100,
        ),
        Achievement(
          id: 2,
          title: 'Knowledge Seeker',
          description: 'Completed 5 professional development courses',
          iconUrl: '',
          awardedDate: DateTime.now().subtract(const Duration(days: 60)),
          type: AchievementType.certification,
          progress: 5,
          goal: 5,
        ),
        Achievement(
          id: 3,
          title: 'Network Builder',
          description: 'Connected with 50 professionals',
          iconUrl: '',
          awardedDate: DateTime.now().subtract(const Duration(days: 90)),
          type: AchievementType.connection,
          progress: 50,
          goal: 50,
        ),
        Achievement(
          id: 4,
          title: 'Master Specialist',
          description: 'Complete 10 specialization courses',
          iconUrl: '',
          awardedDate: DateTime.now().subtract(const Duration(days: 120)),
          type: AchievementType.specialization,
          progress: 7,
          goal: 10,
        ),
      ];
      
      // Create mock professional developments
      final professionalDevelopments = [
        ProfessionalDevelopment(
          id: 1,
          title: 'Advanced Manual Therapy Techniques',
          type: 'course',
          completionDate: DateTime.now().subtract(const Duration(days: 45)),
          certificateUrl: 'https://example.com/cert1.pdf',
          provider: 'National Physical Therapy Association',
          creditHours: 20,
          description: 'Comprehensive course on advanced manual therapy techniques for treating complex musculoskeletal conditions.',
        ),
        ProfessionalDevelopment(
          id: 2,
          title: 'Sports Rehabilitation Conference 2023',
          type: 'conference',
          completionDate: DateTime.now().subtract(const Duration(days: 90)),
          provider: 'International Sports Medicine Society',
          creditHours: 16,
          description: 'Annual conference covering latest research and techniques in sports rehabilitation.',
        ),
        ProfessionalDevelopment(
          id: 3,
          title: 'Therapeutic Taping Workshop',
          type: 'workshop',
          completionDate: DateTime.now().subtract(const Duration(days: 120)),
          certificateUrl: 'https://example.com/cert2.pdf',
          provider: 'SporthTape Academy',
          creditHours: 8,
          description: 'Hands-on workshop for therapeutic taping techniques.',
        ),
      ];
      
      return UserStats(
        totalAppointments: 350,
        completedAppointments: 312,
        totalPatients: 145,
        connectionCount: 78,
        achievements: achievements,
        professionalDevelopments: professionalDevelopments,
        totalCertifications: 5,
      );
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      // Save locally
      for (var entry in preferences.entries) {
        if (entry.value is bool) {
          await prefs.setBool(entry.key, entry.value);
        } else if (entry.value is String) {
          await prefs.setString(entry.key, entry.value);
        } else if (entry.value is int) {
          await prefs.setInt(entry.key, entry.value);
        } else if (entry.value is double) {
          await prefs.setDouble(entry.key, entry.value);
        }
      }
      
      // Save on server
      final response = await http.put(
        Uri.parse('$baseUrl/users/preferences'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(preferences),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update preferences');
      }
    } catch (e) {
      // For development, just update local preferences
      // We already did that above, so just simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In production, you might want to revert local changes if API fails
      // and re-throw the exception
      // rethrow;
    }
  }

  // Get user's connections
  Future<List<User>> getUserConnections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/users/connections'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to get user connections');
      }
    } catch (e) {
      // For development, return mock data
      await Future.delayed(const Duration(seconds: 1));
      
      // Create mock connections
      return [
        User(
          id: 2,
          name: 'Dr. John Davis',
          email: 'john.davis@example.com',
          profilePicture: 'https://randomuser.me/api/portraits/men/32.jpg',
          professionalCredentials: 'PT, OCS',
          specializations: ['Orthopedic', 'Pain Management'],
        ),
        User(
          id: 3,
          name: 'Dr. Sarah Johnson',
          email: 'sarah.johnson@example.com',
          profilePicture: 'https://randomuser.me/api/portraits/women/67.jpg',
          professionalCredentials: 'PT, DPT, GCS',
          specializations: ['Geriatric', 'Neurological'],
        ),
        User(
          id: 4,
          name: 'Dr. Michael Chen',
          email: 'michael.chen@example.com',
          profilePicture: 'https://randomuser.me/api/portraits/men/75.jpg',
          professionalCredentials: 'PT, DPT, SCS',
          specializations: ['Sports Rehabilitation', 'Vestibular Rehabilitation'],
        ),
      ];
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Add professional development
  Future<void> addProfessionalDevelopment(ProfessionalDevelopment development) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/users/professional-development'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(development.toJson()),
      );

      if (response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to add professional development');
      }
    } catch (e) {
      // For development, just simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In production, uncomment:
      // rethrow;
    }
  }

  // Search for professionals
  Future<List<User>> searchProfessionals(String query, {List<String>? specializations}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null) {
        throw Exception('Not authenticated');
      }
      
      final queryParams = {
        'q': query,
      };
      
      if (specializations != null && specializations.isNotEmpty) {
        queryParams['specializations'] = specializations.join(',');
      }
      
      final uri = Uri.parse('$baseUrl/users/search').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to search professionals');
      }
    } catch (e) {
      // For development, return mock data
      await Future.delayed(const Duration(seconds: 1));
      
      // Create mock search results
      return [
        User(
          id: 5,
          name: 'Dr. Emily Rodriguez',
          email: 'emily.rodriguez@example.com',
          profilePicture: 'https://randomuser.me/api/portraits/women/23.jpg',
          professionalCredentials: 'PT, DPT, WCS',
          specializations: ['Women\'s Health', 'Orthopedic'],
        ),
        User(
          id: 6,
          name: 'Dr. Robert Kim',
          email: 'robert.kim@example.com',
          profilePicture: 'https://randomuser.me/api/portraits/men/52.jpg',
          professionalCredentials: 'PT, DPT',
          specializations: ['Neurological', 'Pediatric'],
        ),
      ];
      
      // In production, uncomment:
      // rethrow;
    }
  }
}