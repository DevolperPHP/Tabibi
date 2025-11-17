class CaseModel {
  final String id;
  final String? name;
  final String? userId;
  final String? age;
  final String? bp;
  final String? diabetic;
  final String? heartProblems;
  final String? surgicalOperations;
  final String? currentDisease;
  final String? currentDiseaseDetails;
  final String? imageLeft;
  final String? imageRight;
  final String? imageTop;
  final String? imageBottom;
  final String? imageFront;
  final String? imageChock;
  final String? imageToung;
  final String? imageCheek;
  final String? note;
  final String? status;
  final String? date;
  final int? sortedDate;
  final String? adminStatus;
  final String? category;
  final String? diagnose;
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
  final String? phone;
  final String? telegram;
  final String? rejectNote;
  final String? doctor;
  final String? doctorId;
  final String? doctorPhone;
  final String? doctorTelegram;
  final String? doctorUni;
  final String? startDate;
  final String? endDate;
  final String? doctorNote;
  final String? report;
  final String? gender;
  final String? serviceType;
  final String? zone;
  final String? toothRemoved;
  final String? tf;
  final String? bleedingDuringBrushing;

  CaseModel({
    required this.id,
    this.name,
    this.userId,
    this.age,
    this.bp,
    this.diabetic,
    this.heartProblems,
    this.surgicalOperations,
    this.currentDisease,
    this.currentDiseaseDetails,
    this.imageLeft,
    this.imageRight,
    this.imageTop,
    this.imageBottom,
    this.imageFront,
    this.imageChock,
    this.imageToung,
    this.imageCheek,
    this.note,
    this.status,
    this.date,
    this.sortedDate,
    this.adminStatus,
    this.category,
    this.diagnose,
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
    this.phone,
    this.telegram,
    this.rejectNote,
    this.doctor,
    this.doctorId,
    this.doctorPhone,
    this.doctorTelegram,
    this.doctorUni,
    this.startDate,
    this.endDate,
    this.doctorNote,
    this.report,
    this.gender,
    this.serviceType,
    this.zone,
    this.toothRemoved,
    this.tf,
    this.bleedingDuringBrushing,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['_id'] ?? '',
      name: _nullIfEmpty(json['name']),
      userId: _nullIfEmpty(json['userId']),
      age: _nullIfEmpty(json['age']),
      bp: _nullIfEmpty(json['bp']),
      diabetic: _nullIfEmpty(json['diabetic']),
      heartProblems: _nullIfEmpty(json['heartProblems']),
      surgicalOperations: _nullIfEmpty(json['surgicalOperations']),
      currentDisease: _nullIfEmpty(json['currentDisease']),
      currentDiseaseDetails: _nullIfEmpty(json['currentDiseaseDetails']),
      imageLeft: _nullIfEmpty(json['imageLeft']),
      imageRight: _nullIfEmpty(json['imageRight']),
      imageTop: _nullIfEmpty(json['imageTop']),
      imageBottom: _nullIfEmpty(json['imageBottom']),
      imageFront: _nullIfEmpty(json['imageFront']),
      imageChock: _nullIfEmpty(json['imageChock']),
      imageToung: _nullIfEmpty(json['imageToung']),
      imageCheek: _nullIfEmpty(json['imageCheek']),
      note: _nullIfEmpty(json['note']),
      status: _nullIfEmpty(json['status']),
      date: _nullIfEmpty(json['Date']),
      sortedDate: int.tryParse(json['sortedDate']?.toString() ?? ''),
      adminStatus: _nullIfEmpty(json['adminStatus']),
      category: _nullIfEmpty(json['category']),
      diagnose: _nullIfEmpty(json['diagnose']),
      painContinues: _nullIfEmpty(json['pain_continues']),
      painEat: _nullIfEmpty(json['pain_eat']),
      painEatType: _nullIfEmpty(json['pain_eat_type']),
      painCaildDrink: _nullIfEmpty(json['pain_caild_drink']),
      painCaildDrinkType: _nullIfEmpty(json['pain_caild_drink_type']),
      painHotDrink: _nullIfEmpty(json['pain_hot_drink']),
      painSleep: _nullIfEmpty(json['pain_sleep']),
      inflamation: _nullIfEmpty(json['inflamation']),
      teethMovement: _nullIfEmpty(json['teeth_movement']),
      calcifications: _nullIfEmpty(json['calcifications']),
      pigmentation: _nullIfEmpty(json['pigmentation']),
      painContinuesGum: _nullIfEmpty(json['pain_continues_gum']),
      painEatGum: _nullIfEmpty(json['pain_eat_gum']),
      roots: _nullIfEmpty(json['roots']),
      mouthInflammation: _nullIfEmpty(json['mouth_inflammation']),
      mouthUlcer: _nullIfEmpty(json['mouth_ulcer']),
      toothDecay: _nullIfEmpty(json['tooth_decay']),
      phone: _nullIfEmpty(json['phone']),
      telegram: _nullIfEmpty(json['telegram']),
      rejectNote: _nullIfEmpty(json['rejectNote']),
      doctor: _nullIfEmpty(json['doctor']),
      doctorId: _nullIfEmpty(json['doctorId']),
      doctorPhone: _nullIfEmpty(json['doctorPhone']),
      doctorTelegram: _nullIfEmpty(json['doctorTelegram']),
      doctorUni: _nullIfEmpty(json['doctorUni']),
      startDate: _nullIfEmpty(json['startDate']),
      endDate: _nullIfEmpty(json['endDate']),
      doctorNote: _nullIfEmpty(json['doctorNote']),
      report: _nullIfEmpty(json['report']),
      gender: _nullIfEmpty(json['gender']),
      serviceType: _nullIfEmpty(json['type']),  // Backend uses 'type' field
      zone: _nullIfEmpty(json['zone']),
      toothRemoved: _nullIfEmpty(json['toothRemoved']),
      tf: _nullIfEmpty(json['tf']),
      bleedingDuringBrushing: _nullIfEmpty(json['bleeding_during_brushing']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'userId': userId,
      'age': age,
      'bp': bp,
      'diabetic': diabetic,
      'heartProblems': heartProblems,
      'surgicalOperations': surgicalOperations,
      'currentDisease': currentDisease,
      'currentDiseaseDetails': currentDiseaseDetails,
      'imageLeft': imageLeft,
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
      'category': category,
      'adminStatus': adminStatus,
      'diagnose': diagnose,
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
      'phone': phone,
      'telegram': telegram,
      'rejectNote': rejectNote,
      'doctor': doctor,
      'doctorId': doctorId,
      'doctorPhone': doctorPhone,
      'doctorTelegram': doctorTelegram,
      'doctorUni': doctorUni,
      'startDate': startDate,
      'endDate': endDate,
      'doctorNote': doctorNote,
      'report': report,
      'gender': gender,
      'type': serviceType,  // Backend expects 'type' field
      'zone': zone,
      'toothRemoved': toothRemoved,
      'tf': tf,
      'bleeding_during_brushing': bleedingDuringBrushing,
    };
  }

  static String? _nullIfEmpty(dynamic value) {
    if (value == null) return null;
    final stringValue = value.toString().trim();
    return stringValue.isEmpty ? null : stringValue;
  }

  static List<CaseModel> fromJsonList(List jsonList) {
    return jsonList.map((json) => CaseModel.fromJson(json)).toList();
  }
  
  // Factory to convert from profile_model Case to CaseModel
  factory CaseModel.fromProfileCase(dynamic profileCase) {
    return CaseModel(
      id: profileCase.id,
      name: _nullIfEmpty(profileCase.name),
      userId: _nullIfEmpty(profileCase.userId),
      age: _nullIfEmpty(profileCase.age),
      bp: _nullIfEmpty(profileCase.bp),
      diabetic: _nullIfEmpty(profileCase.diabetic),
      heartProblems: _nullIfEmpty(profileCase.heartProblems),
      surgicalOperations: _nullIfEmpty(profileCase.surgicalOperations),
      currentDisease: _nullIfEmpty(profileCase.currentDisease),
      currentDiseaseDetails: _nullIfEmpty(profileCase.currentDiseaseDetails),
      imageLeft: _nullIfEmpty(profileCase.imageLeft),
      imageRight: _nullIfEmpty(profileCase.imageRight),
      imageTop: _nullIfEmpty(profileCase.imageTop),
      imageBottom: _nullIfEmpty(profileCase.imageBottom),
      imageFront: _nullIfEmpty(profileCase.imageFront),
      imageChock: _nullIfEmpty(profileCase.imageChock),
      imageToung: _nullIfEmpty(profileCase.imageToung),
      imageCheek: _nullIfEmpty(profileCase.imageCheek),
      note: _nullIfEmpty(profileCase.note),
      status: _nullIfEmpty(profileCase.status),
      date: _nullIfEmpty(profileCase.date),
      sortedDate: int.tryParse(profileCase.sortedDate ?? ''),
      adminStatus: _nullIfEmpty(profileCase.adminStatus),
      diagnose: _nullIfEmpty(profileCase.diagnose),
      zone: _nullIfEmpty(profileCase.zone),
      gender: _nullIfEmpty(profileCase.gender), // Add gender field
      toothRemoved: _nullIfEmpty(profileCase.toothRemoved),
      tf: _nullIfEmpty(profileCase.tf),
    );
  }
}
