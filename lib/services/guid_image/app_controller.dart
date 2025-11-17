import 'dart:io';

import 'package:get/get.dart';
import '../../data/models/instruction_model.dart';
import '../../utils/constants/values_constant.dart';

class AppController extends GetxController {
  RxInt countViewItems() =>
      (Values.width ~/ 250 == 0 ? 3 : (Values.width / 150).round()).obs;

  // Dynamic instructions based on service type
  List<Instruction> getInstructionsForServiceType(String serviceType) {
    switch (serviceType) {
      case 'معالجة الاسنان':
        return _getTreatmentInstructions();
      case 'تنظيف الاسنان':
        return _getCleaningInstructions();
      case 'تعويض الاسنان':
        return _getReplacementInstructions();
      default:
        return _getTreatmentInstructions();
    }
  }

  // معالجة الاسنان - 3 images
  List<Instruction> _getTreatmentInstructions() => [
        Instruction(
          image: Rx<File?>(null),
          name: 'imageChock',
          title: "السطح الماضغ",
          steps: [
            "افتح فمك حتى يظهر السطح الماضغ للسن المتسوس كما في الصورة.",
            "التقط صورة للسطح الماضغ للسن المتسوس.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image22.png",
        ),
        Instruction(
          image: Rx<File?>(null),
          name: 'imageCheek',
          title: "السطح الخدي",
          steps: [
            "افتح فمك و قم بسحب الخد والشفاه حتى يتضح لك السطح الخارجي للسن المتسوس(السطح الخدي) كما في الصورة.",
            "التقط صورة للسطح الخارجي(الخدي) للسن المتسوس.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/cheek-serfuce.png",
        ),
        Instruction(
          image: Rx<File?>(null),
          name: 'imageToung',
          title: "السطح اللساني",
          steps: [
            "قم بفتح فمك و أبعد لسانك عن السن حتى يظهر السطح الداخلي (اللساني) للسن المتسوس كما في الصورة.",
            "التقط صورة للسطح الداخلي (اللساني) للسن المتسوس.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image4.jpg",
        ),
      ];

  // تنظيف الاسنان - 4 images
  List<Instruction> _getCleaningInstructions() => [
        Instruction(
          image: Rx<File?>(null),
          name: 'imageFront',
          title: "الأسنان الأمامية",
          steps: [
            "قم بالابتسامة حتى تظهر أسنانك الأمامية وتأكد من جعل حواف الأسنان السفلى تتقاطع مع حواف الأسنان العليا كما في الصورة.",
            "التقط صورة للأسنان الأمامية.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image6.png",
        ),
        Instruction(
          image: Rx<File?>(null),
          name: 'imageLeft',
          title: "السطح الخدي - الجانب الأيمن",
          steps: [
            "قم بالابتسامة وبعدها اسحب خدك الأيسر حتى يظهر السطح الخارجي (الخدي) من الأسنان كما في الصورة.",
            "التقط صورة للسطح الخارجي (الخدي) للأسنان الجانب الأيسر.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image5.png",
        ),
        Instruction(
          image: Rx<File?>(null),
          name: 'imageRight',
          title: "السطح الخدي - الجانب الأيسر",
          steps: [
            "قم بالابتسامة وبعدها اسحب خدك الأيمن حتى يظهر السطح الخارجي (الخدي) من الأسنان كما في الصورة.",
            "التقط صورة للسطح الخارجي (الخدي) للأسنان الجانب الأيمن.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image-right.jpeg",
        ),
        Instruction(
          image: Rx<File?>(null),
          name: 'imageTop',
          title: "الأسنان العلوية",
          steps: [
            "قم بفتح فمك حتى تظهر الأسنان العلوية كلها كما موضح في الصورة.",
            "التقط صورة للاسنان العلوية كلها.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image1.png",
        ),
        Instruction(
          image: Rx<File?>(null),
          name: 'imageBottom',
          title: "الأسنان السفلية",
          steps: [
            "قم بفتح فمك حتى تظهر الأسنان السفلية كلها واسحب لسانك إلى الخلف حتى لا يحجب الأسنان كما في الصورة.",
            "قم بتصوير الاسنان السفلية.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image2.png",
        ),
      ];

  // تعويض الاسنان - 2 images
  List<Instruction> _getReplacementInstructions() => [
        Instruction(
          image: Rx<File?>(null),
          name: 'imageTop',
          title: "الأسنان العلوية",
          steps: [
            "قم بفتح فمك حتى تظهر الأسنان العلوية كلها كما موضح في الصورة.",
            "التقط صورة للاسنان العلوية كلها.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image1.png",
        ),
        Instruction(
          image: Rx<File?>(null),
          name: 'imageBottom',
          title: "الأسنان السفلية",
          steps: [
            "قم بفتح فمك حتى تظهر الأسنان السفلية كلها واسحب لسانك إلى الخلف حتى لا يحجب الأسنان كما في الصورة.",
            "قم بتصوير الاسنان السفلية.",
            "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
            "إذا واجهت مشكلة في التصوير راجع التعليمات العامة، وحاول مرة أخرى.",
          ],
          imagePath: "assets/images/image2.png",
        ),
      ];

  // Legacy - for backward compatibility (will be removed)
  final List<Instruction> instructions = [
    Instruction(
      image: Rx<File?>(null),
      name: 'imageFront',
      title: "الأسنان الأمامية",
      steps: [
        "قم بالابتسامة حتى تظهر أسنانك الأمامية وتأكد من جعل حواف الأسنان السفلى تتقاطع مع حواف الأسنان العليا كما في الصورة.",
        "التقط صورة للأسنان الأمامية.",
        "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
        "إذا واجهت مشكلة في التصوير، راجع التعليمات العامة وحاول مرة أخرى.",
      ],
      imagePath: "assets/images/image6.png",
    ),
    Instruction(
      image: Rx<File?>(null),
      name: 'imageChock',
      title: "الأسنان الماضغة",
      steps: [
        "افتح فمك حتى يظهر السطح الماضغ للسن المتسوس كما في الصورة.",
        "التقط صورة للسطح الماضغ للسن المتسوس.",
        "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
        "إذا واجهت مشكلة في التصوير، راجع التعليمات العامة وحاول مرة أخرى.",
      ],
      imagePath: "assets/images/image22.png",
    ),
    Instruction(
      image: Rx<File?>(null),
      name: 'imageBottom',
      title: "الأسنان السفلية",
      steps: [
        "قم بفتح فمك حتى تظهر الأسنان السفلية كلها واسحب لسانك إلى الخلف حتى لا يحجب الأسنان كما في الصورة.",
        "قم بتصوير الأسنان السفلية.",
        "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
        "إذا واجهت مشكلة في التصوير، راجع التعليمات العامة وحاول مرة أخرى.",
      ],
      imagePath: "assets/images/image2.png",
    ),
    Instruction(
      image: Rx<File?>(null),
      name: 'imageTop',
      title: "الأسنان العلوية",
      steps: [
        "قم بفتح فمك حتى تظهر الأسنان العلوية كلها كما هو موضح في الصورة.",
        "التقط صورة للأسنان العلوية كلها.",
        "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
        "إذا واجهت مشكلة في التصوير، راجع التعليمات العامة وحاول مرة أخرى.",
      ],
      imagePath: "assets/images/image1.png",
    ),
    Instruction(
      image: Rx<File?>(null),
      name: 'imageToung',
      title: "تحت اللسان",
      steps: [
        "قم بفتح فمك وأبعد لسانك عن السن حتى يظهر السطح الداخلي (اللساني) للسن المتسوس كما في الصورة.",
        "التقط صورة للسطح الداخلي (اللساني) للسن المتسوس.",
        "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
        "إذا واجهت مشكلة في التصوير، راجع التعليمات العامة وحاول مرة أخرى.",
      ],
      imagePath: "assets/images/image4.jpg",
    ),
    Instruction(
      image: Rx<File?>(null),
      name: 'imageCheek',
      title: "السطح الخدي",
      steps: [
        "قم بالابتسامة وبعدها اسحب خدك حتى يظهر السطح الخارجي (الخدي) من الأسنان كما في الصورة.",
        "التقط صورة للسطح الخارجي (الخدي) للأسنان.",
        "تأكد من وضوح الصورة وعدم احتوائها على أي عيوب.",
        "إذا واجهت مشكلة في التصوير، راجع التعليمات العامة وحاول مرة أخرى.",
      ],
      imagePath: "assets/images/image5.png",
    ),
  ];

  // Clear all images
  void clearAllImages() {
    for (var instruction in instructions) {
      instruction.image.value = null;
    }
  }
}
