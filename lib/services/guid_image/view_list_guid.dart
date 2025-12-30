import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tabibi/utils/constants/style_app.dart';
import 'package:tabibi/utils/design_system/modern_theme.dart';
import '../../controllers/case_controller.dart';
import '../../data/models/instruction_model.dart';
import '../../utils/constants/color_app.dart';
import '../../utils/constants/images_url.dart';
import '../../utils/constants/shadow_values.dart';
import '../../utils/constants/values_constant.dart';
import '../../views/widgets/actions_button.dart';
import '../../views/widgets/common/loading_indicator.dart';
import '../../views/widgets/more_widgets.dart';
import 'app_controller.dart';

class ViewListGuid extends StatelessWidget {
  final AppController controller = Get.put(AppController());
  CaseController caseController = Get.find<CaseController>();
  ViewListGuid({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Ensure instructions are loaded based on service type
    if (caseController.currentInstructions.isEmpty && caseController.selectedServiceType.value.isNotEmpty) {
      caseController.setServiceType(caseController.selectedServiceType.value);
    }
    
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F7),
      body: CustomScrollView(
        slivers: [
          // Normal App Header like other screens
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF007AFF),
                    Color(0xFF5856D6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo and title on the right
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'طبيبي',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Back arrow on the left
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Instructions Card
                Container(
                  margin: EdgeInsets.all(24),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.08),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF007AFF),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'تعليمات هامة',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D1D1F),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildModernInstruction("تأكد من وجود شخص معك لتصوير حالتك بوضوح تام."),
                      _buildModernInstruction("لضمان صورة واضحة، حاول أن تكون الإضاءة جيدة مع التأكد من نظافة الكاميرا."),
                      _buildModernInstruction("من الضروري جدًا غسل وتفريش الأسنان قبل التصوير."),
                      _buildModernInstruction("عليك إظهار منطقة الفم والأسنان فقط، وتحديد المنطقة المراد علاجها."),
                      _buildModernInstruction("اغسل يديك جيدًا وقم بتعقيمها قبل وبعد عملية التصوير، مع لبس القفازات الطبية."),
                    ],
                  ),
                ),
                
                // Image Grid
                Obx(() {
                  final int maxColumns = controller.countViewItems().value;
                  
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: maxColumns,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.55,
                      ),
                      itemCount: caseController.currentInstructions.length,
                      itemBuilder: (context, index) {
                        final instruction = caseController.currentInstructions[index];
                        final hasImage = instruction.image.value != null;
                        final hasExistingImage = caseController.existingImageUrls[instruction.name] != null;
                        
                        return GestureDetector(
                          onTap: () {
                            caseController.selectInstruction(instruction);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000).withOpacity(0.06),
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: hasImage 
                                    ? Color(0xFF34C759).withOpacity(0.3)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Column(
                                children: [
                                  // Image Area
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      color: Color(0xFFF8F9FA),
                                      child: Stack(
                                        children: [
                                          // Image Display
                                          Positioned.fill(
                                            child: Obx(() {
                                              // Check if user captured a new image
                                              if (instruction.image.value != null) {
                                                return Image.file(
                                                  instruction.image.value!,
                                                  fit: BoxFit.cover,
                                                );
                                              }
                                              
                                              // Check if there's an existing image from rejected case
                                              final existingImageUrl = caseController.existingImageUrls[instruction.name];
                                              if (existingImageUrl != null && existingImageUrl.isNotEmpty) {
                                                return Image.network(
                                                  'http://165.232.78.163/upload/images/$existingImageUrl',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Color(0xFFF8F9FA),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.image_not_supported_outlined,
                                                          color: Color(0xFF8E8E93),
                                                          size: 32,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                              
                                              // Default: show instruction placeholder
                                              return Container(
                                                color: Color(0xFFF8F9FA),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: Color(0xFF8E8E93),
                                                    size: 32,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          
                                          // Status Badge
                                          if (hasImage)
                                            Positioned(
                                              top: 12,
                                              right: 12,
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF34C759),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF34C759).withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          
                                          // Existing Image Badge
                                          if (hasExistingImage && !hasImage)
                                            Positioned(
                                              top: 12,
                                              right: 12,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF9500),
                                                  borderRadius: BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFFFF9500).withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  'موجودة',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // Title Area
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            instruction.title,
                                            maxLines: 3,
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF1D1D1F),
                                              height: 1.3,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: hasImage
                                                      ? Color(0xFF34C759).withOpacity(0.1)
                                                      : Color(0xFF8E8E93).withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: hasImage
                                                      ? Color(0xFF34C759)
                                                      : Color(0xFF8E8E93),
                                                  size: 12,
                                                ),
                                              ),
                                              if (hasImage)
                                                Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF34C759),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                
                // Captured Images Preview
                Obx(() {
                  List<Instruction> capturedImages = [];
                  for (int i = 0; i < caseController.currentInstructions.length; i++) {
                    if (caseController.currentInstructions[i].image.value != null) {
                      capturedImages.add(caseController.currentInstructions[i]);
                    }
                  }

                  if (capturedImages.isEmpty) return SizedBox.shrink();

                  return Container(
                    margin: EdgeInsets.all(24),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.08),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              color: Color(0xFF007AFF),
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'الصور الملتقطة (${capturedImages.length})',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: capturedImages.length,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(left: 12),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFF34C759).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  capturedImages[index].image.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                
                // Submit Button
                Obx(() {
                  return caseController.isLoading.value
                      ? Container(
                          margin: EdgeInsets.all(24),
                          height: 56,
                          child: Center(child: LoadingIndicator()),
                        )
                      : Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(24),
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF007AFF),
                                Color(0xFF5856D6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF007AFF).withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                caseController.submitSendInfo();
                              },
                              child: Center(
                                child: Text(
                                  'ارسال الحالة',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ),
                          ));
                }),
                
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModernInstruction(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(top: 6, left: 12),
            decoration: BoxDecoration(
              color: Color(0xFF007AFF),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C3C43),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
