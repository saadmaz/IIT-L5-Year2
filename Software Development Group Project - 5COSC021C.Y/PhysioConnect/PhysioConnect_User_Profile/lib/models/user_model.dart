class User {
  final int id;
  final String name;
  final String email;
  String? profilePicture;
  String? phoneNumber;
  List<String>? specializations;
  String? professionalCredentials;
  int? yearsOfExperience;
  String? licenseNumber;
  String? bio;
  List<String>? certifications;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.phoneNumber,
    this.specializations,
    this.professionalCredentials,
    this.yearsOfExperience,
    this.licenseNumber,
    this.bio,
    this.certifications,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      phoneNumber: json['phone_number'],
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : null,
      professionalCredentials: json['professional_credentials'],
      yearsOfExperience: json['years_of_experience'],
      licenseNumber: json['license_number'],
      bio: json['bio'],
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'email': email,
    };
    
    if (profilePicture != null) data['profile_picture'] = profilePicture;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (specializations != null) data['specializations'] = specializations;
    if (professionalCredentials != null) data['professional_credentials'] = professionalCredentials;
    if (yearsOfExperience != null) data['years_of_experience'] = yearsOfExperience;
    if (licenseNumber != null) data['license_number'] = licenseNumber;
    if (bio != null) data['bio'] = bio;
    if (certifications != null) data['certifications'] = certifications;
    
    return data;
  }
}