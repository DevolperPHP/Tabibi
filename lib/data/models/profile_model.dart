// نموذج بيانات المستخدم
class UserData {
  final String id;
  String name;
  int age;
  String city;
  final String? zone;
  final String email;
  final String password;
  final String gender;
  final bool isAdmin;
  final bool inCase;
  final bool isDoctor;

  final String role;
  final String bp;
  final String diabetic;
  final String toothRemoved;
  final String tf;
  final String? phone;
  final String? telegram;

  UserData({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    this.zone,
    required this.email,
    required this.password,
    required this.isAdmin,
    required this.gender,
    required this.inCase,
    required this.isDoctor,
    required this.role,
    required this.bp,
    required this.diabetic,
    required this.toothRemoved,
    required this.tf,
    this.phone,
    this.telegram,
  });

  // دالة تحويل من JSON إلى نموذج UserData
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] as int,
      city: json['city'] ?? '',
      zone: json['zone'] as String?,
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      isAdmin: json['isAdmin'] as bool,
      inCase: json['inCase'] as bool,
      isDoctor: json['isDoctor'] as bool,
      bp: json['bp'] ?? 'no',
      diabetic: json['diabetic'] ?? 'no',
      toothRemoved: json['toothRemoved'] ?? 'no',
      tf: json['tf'] ?? 'no',
      phone: json['phone'],
      telegram: json['telegram'],
    );
  }

  // دالة تحويل من نموذج UserData إلى JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'age': age,
      'city': city,
      'zone': zone,
      'email': email,
      'password': password,
      'isAdmin': isAdmin,
      'inCase': inCase,
      'isDoctor': isDoctor,
      'bp': bp,
      'diabetic': diabetic,
      'toothRemoved': toothRemoved,
      'tf': tf,
      'phone': phone,
      'telegram': telegram,
    };
  }
}

// نموذج بيانات الحالة
class Case {
  final String id;
  final String name;
  final String userId;
  final String age;
  final String? gender;
  final String? phone;
  final String? telegram;
  final String? type;
  final String bp;
  final String diabetic;
  final String toothRemoved;
  final String tf;
  final String? heartProblems;
  final String? surgicalOperations;
  final String? currentDisease;
  final String? currentDiseaseDetails;
  // Doctor info (when case is acquired)
  final String? doctorName;
  final String? doctorPhone;
  final String? doctorTelegram;
  final String? doctorUni;
  final String? imageLeft;
  final String? imageRight;
  final String imageTop;
  final String imageBottom;
  final String imageFront;
  final String imageChock;
  final String imageToung;
  final String imageCheek;
  final String note;
  final String status;
  final String diagnose;
  final String date;
  final String sortedDate;
  final String adminStatus;
  final String? rejectNote;
  final String? serviceType;
  // New case sheet fields matching backend
  final String? painContinues;
  final String? painEat;
  final String? painEatType; // Sub-question for pain_eat
  final String? painCaildDrink;
  final String? painCaildDrinkType; // Sub-question for pain_caild_drink
  final String? painHotDrink;
  final String? painSleep;
  final String? inflamation;
  final String? teethMovement;
  final String? calcifications;
  final String? pigmentation;
  final String? painContinuesGum;
  final String? painEatGum;
  final String? roots;
  final String? mouthInflammation;
  final String? mouthUlcer;
  final String? toothDecay;
  final String? bleedingDuringBrushing;
  final String? zone;
  final int v;

  Case({
    required this.id,
    required this.name,
    required this.userId,
    required this.age,
    this.gender,
    this.phone,
    this.telegram,
    this.type,
    required this.bp,
    required this.diabetic,
    required this.toothRemoved,
    required this.tf,
    this.heartProblems,
    this.surgicalOperations,
    this.currentDisease,
    this.currentDiseaseDetails,
    this.doctorName,
    this.doctorPhone,
    this.doctorTelegram,
    this.doctorUni,
    this.imageLeft,
    this.imageRight,
    required this.imageTop,
    required this.imageBottom,
    required this.imageFront,
    required this.imageChock,
    required this.imageToung,
    required this.imageCheek,
    required this.note,
    required this.status,
    required this.date,
    required this.sortedDate,
    required this.diagnose,
    required this.adminStatus,
    this.rejectNote,
    this.serviceType,
    this.painContinues,
    this.painEat,
    this.painEatType,
    this.painCaildDrink,
    this.painCaildDrinkType,
    this.painHotDrink,
    this.painSleep,
    this.inflamation,
    this.teethMovement,
    this.calcifications,
    this.pigmentation,
    this.painContinuesGum,
    this.painEatGum,
    this.roots,
    this.mouthInflammation,
    this.mouthUlcer,
    this.toothDecay,
    this.bleedingDuringBrushing,
    this.zone,
    required this.v,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      userId: json['userId'] ?? '',
      age: json['age'] ?? '',
      gender: json['gender'],
      phone: json['phone'],
      telegram: json['telegram'],
      type: json['type'],
      bp: json['bp'] ?? '',
      diagnose: json['diagnose'] ?? '',
      diabetic: json['diabetic'] ?? '',
      toothRemoved: json['toothRemoved'] ?? '',
      tf: json['tf'] ?? '',
      heartProblems: json['heartProblems'],
      surgicalOperations: json['surgicalOperations'],
      currentDisease: json['currentDisease'],
      currentDiseaseDetails: json['currentDiseaseDetails'],
      doctorName: json['doctor'],
      doctorPhone: json['doctorPhone'],
      doctorTelegram: json['doctorTelegram'],
      doctorUni: json['doctorUni'],
      imageLeft: json['imageLeft'],
      imageRight: json['imageRight'],
      imageTop: json['imageTop'] ?? '',
      imageBottom: json['imageBottom'] ?? '',
      imageFront: json['imageFront'] ?? '',
      imageChock: json['imageChock'] ?? '',
      imageToung: json['imageToung'] ?? '',
      imageCheek: json['imageCheek'] ?? '',
      note: json['note'] ?? '',
      status: json['status'] ?? '',
      date: json['Date'] ?? '',
      sortedDate: json['sortedDate'] ?? '',
      adminStatus: json['adminStatus'] ?? '',
      rejectNote: json['rejectNote'],
      serviceType: json['type'],  // Backend uses 'type' field
      painContinues: json['pain_continues'],
      painEat: json['pain_eat'],
      painEatType: json['pain_eat_type'],
      painCaildDrink: json['pain_caild_drink'],
      painCaildDrinkType: json['pain_caild_drink_type'],
      painHotDrink: json['pain_hot_drink'],
      painSleep: json['pain_sleep'],
      inflamation: json['inflamation'],
      teethMovement: json['teeth_movement'],
      calcifications: json['calcifications'],
      pigmentation: json['pigmentation'],
      painContinuesGum: json['pain_continues_gum'],
      painEatGum: json['pain_eat_gum'],
      roots: json['roots'],
      mouthInflammation: json['mouth_inflammation'],
      mouthUlcer: json['mouth_ulcer'],
      toothDecay: json['tooth_decay'],
      bleedingDuringBrushing: json['bleeding_during_brushing'],
      zone: json['zone'],
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'userId': userId,
      'gender': gender,
      'bp': bp,
      'diabetic': diabetic,
      'heartProblems': heartProblems,
      'surgicalOperations': surgicalOperations,
      'currentDisease': currentDisease,
      'currentDiseaseDetails': currentDiseaseDetails,
      'imageLeft': imageLeft,
      'diagnose': diagnose,
      'imageRight': imageRight,
      'imageTop': imageTop,
      'imageBottom': imageBottom,
      'imageFront': imageFront,
      'imageChock': imageChock,
      'imageToung': imageToung,
      'imageCheek': imageCheek,
      'note': note,
      'status': status,
      'Date': date,
      'sortedDate': sortedDate,
      'adminStatus': adminStatus,
      'rejectNote': rejectNote,
      'type': serviceType,  // Backend uses 'type' field
      'pain_continues': painContinues,
      'pain_eat': painEat,
      'pain_eat_type': painEatType,
      'pain_caild_drink': painCaildDrink,
      'pain_caild_drink_type': painCaildDrinkType,
      'pain_hot_drink': painHotDrink,
      'pain_sleep': painSleep,
      'inflamation': inflamation,
      'teeth_movement': teethMovement,
      'calcifications': calcifications,
      'pigmentation': pigmentation,
      'pain_continues_gum': painContinuesGum,
      'pain_eat_gum': painEatGum,
      'roots': roots,
      'mouth_inflammation': mouthInflammation,
      'mouth_ulcer': mouthUlcer,
      'tooth_decay': toothDecay,
      'bleeding_during_brushing': bleedingDuringBrushing,
      'zone': zone,
      '__v': v,
    };
  }
}

// نموذج البيانات الكامل الذي يحتوي على بيانات المستخدم والحالات
class UserModel {
  final UserData userData;
  final List<Case> cases;

  UserModel({
    required this.userData,
    required this.cases,
  });

  // دالة تحويل من JSON إلى نموذج UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userData: UserData.fromJson(json['userData']),
      cases: (json['cases'] as List)
          .map((caseJson) => Case.fromJson(caseJson))
          .toList(),
    );
  }

  // دالة تحويل من نموذج UserModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'userData': userData.toJson(),
      'cases': cases.map((c) => c.toJson()).toList(),
    };
  }
}
