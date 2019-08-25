class Profile {
  String name;
  String designation;
  String imagePath;
  String currentCityAndCountry;

  Profile({
    this.name,
    this.designation,
    this.imagePath,
    this.currentCityAndCountry,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => new Profile(
        name: json["name"],
        designation: json["designation"],
        imagePath: json["imagePath"],
        currentCityAndCountry: json["currentCityAndCountry"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "designation": designation,
        "imagePath": imagePath,
        "currentCityAndCountry": currentCityAndCountry,
      };
}

class Contact {
  String email;
  String phone;
  String countryCode;
  String linkedin;

  Contact({
    this.email,
    this.phone,
    this.linkedin,
    this.countryCode,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => new Contact(
        email: json["email"],
        phone: json["phone"],
        linkedin: json["linkedin"],
        countryCode: json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
        "linkedin": linkedin,
        "countryCode": countryCode,
      };
}

class Experience {
  String companyName;
  String designation;
  DateTime startDate;
  DateTime endDate;
  String summary;
  String companyLink;

  Experience({
    this.companyName,
    this.designation,
    this.startDate,
    this.endDate,
    this.summary,
    this.companyLink,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => new Experience(
        companyName: json["companyName"],
        designation: json["designation"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        summary: json["summary"],
        companyLink: json["companyLink"],
      );

  Map<String, dynamic> toJson() => {
        "companyName": companyName,
        "designation": designation,
        "startDate": startDate,
        "endDate": endDate,
        "summary": summary,
        "companyLink": companyLink,
      };
}

class Project {
  String projectName;
  DateTime startDate;
  DateTime endDate;
  String projectSummary;
  String projectLink;

  Project({
    this.projectName,
    this.startDate,
    this.endDate,
    this.projectSummary,
    this.projectLink,
  });

  factory Project.fromJson(Map<String, dynamic> json) => new Project(
        projectName: json["projectName"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        projectSummary: json["projectSummary"],
        projectLink: json["projectLink"],
      );

  Map<String, dynamic> toJson() => {
        "projectName": projectName,
        "startDate": startDate,
        "endDate": endDate,
        "projectSummary": projectSummary,
        "projectLink": projectLink,
      };
}

class Course {
  String courseName;
  DateTime startDate;
  DateTime endDate;
  String courseSummary;
  String courseLink;
  bool status;

  Course({
    this.courseName,
    this.startDate,
    this.endDate,
    this.courseSummary,
    this.courseLink,
    this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) => new Course(
        courseName: json["courseName"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        courseSummary: json["courseSummary"],
        courseLink: json["courseLink"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "courseName": courseName,
        "startDate": startDate,
        "endDate": endDate,
        "courseSummary": courseSummary,
        "courseLink": courseLink,
        "status": status,
      };
}

class Education {
  String universityName;
  DateTime startDate;
  DateTime endDate;
  String courseTaken;
  String collegeLink;

  Education({
    this.universityName,
    this.startDate,
    this.endDate,
    this.courseTaken,
    this.collegeLink,
  });

  factory Education.fromJson(Map<String, dynamic> json) => new Education(
        universityName: json["universityName"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        courseTaken: json["courseTaken"],
        collegeLink: json["collegeLink"],
      );

  Map<String, dynamic> toJson() => {
        "universityName": universityName,
        "startDate": startDate,
        "endDate": endDate,
        "courseTaken": courseTaken,
        "collegeLink": collegeLink,
      };
}

class Reference {
  String name;
  String designation;
  String company;
  String email;

  Reference({
    this.name,
    this.designation,
    this.company,
    this.email,
  });

  factory Reference.fromJson(Map<String, dynamic> json) => new Reference(
        name: json["name"],
        designation: json["designation"],
        company: json["company"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "designation": designation,
        "company": company,
        "email": email,
      };
}

class Language {
  String name;
  String level;

  Language({
    this.name,
    this.level,
  });

  factory Language.fromJson(Map<String, dynamic> json) => new Language(
        name: json["name"],
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "level": level,
      };
}

class Resume {
  Profile profile;
  Contact contact;
  List<Experience> experiences;
  List<Project> projects;
  List<Education> educations;
  List<String> skills;
  List<Language> languages;
  List<Reference> references;
  List<Course> courses;
  String profileSummary;

  Resume({
    this.profile,
    this.contact,
    this.experiences,
    this.projects,
    this.educations,
    this.skills,
    this.languages,
    this.references,
    this.courses,
    this.profileSummary,
  });

  factory Resume.fromJson(Map<String, dynamic> json) {
    var experiencesList = json['experiences'] as List;
    List<Experience> experiences = experiencesList.map((i) => Experience.fromJson(i)).toList();

    var projectsList = json['projects'] as List;
    List<Project> projects = projectsList.map((i) => Project.fromJson(i)).toList();

    var educationsList = json['educations'] as List;
    List<Education> educations = educationsList.map((i) => Education.fromJson(i)).toList();

    var referencesList = json['references'] as List;
    List<Reference> references = referencesList.map((i) => Reference.fromJson(i)).toList();

    var coursesList = json['courses'] as List;
    List<Course> courses = coursesList.map((i) => Course.fromJson(i)).toList();

    var languagesList = json['languages'] as List;
    List<Language> languages = languagesList.map((i) => Language.fromJson(i)).toList();

    return Resume(
      profile: Profile.fromJson(json["profile"]),
      contact: Contact.fromJson(json["contact"]),
      experiences: experiences,
      projects: projects,
      educations: educations,
      skills: json["companyLink"],
      languages: languages,
      references: references,
      courses: courses,
      profileSummary: json["profileSummary"],
    );
  }

  Map<String, dynamic> toJson() => {
        "profile": profile,
        "contact": contact,
        "experiences": experiences,
        "projects": projects,
        "educations": educations,
        "skills": skills,
        "languages": languages,
        "references": references,
        "courses": courses,
        "profileSummary": profileSummary,
      };
}
