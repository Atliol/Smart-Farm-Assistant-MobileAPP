import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_background.dart';

// 💡 Data Structure Model
class GuideSubItem {
  final String subTitle;
  final String subDescription;

  GuideSubItem({required this.subTitle, required this.subDescription});
}

class GuideItem {
  final String title;
  final IconData icon;
  final String? mainDescription; // Sub UI မရှိရင် သုံးရန်
  final List<GuideSubItem>? subItems; // Sub UI များရှိရင် သုံးရန်

  GuideItem({
    required this.title,
    required this.icon,
    this.mainDescription,
    this.subItems,
  });
}

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 Offline Demo Data (Navigation Button ၅ ခုနှင့် Sub UI များ)
    final List<GuideItem> guideList = [
      // ၁။ Home
      GuideItem(
        title: 'Home (Online & Offline)',
        icon: Icons.home_rounded,
        subItems: [
          GuideSubItem(
            subTitle: '• Weather Card & ၄ ရက်စာ ခန့်မှန်းချက်',
            subDescription: 'လက်ရှိ ရောက်ရှိနေသော ဒေသ၏ ရာသီဥတုကို ကြည့်နိုင်ပြီး၊ အောက်ခြေရှိ Button ကို နှိပ်၍ နောက် ၄ ရက်စာ မိုးလေဝသ အသေးစိတ်ကို ကြည့်နိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• Quick Access Section',
            subDescription: 'Measure (မြေတိုင်းတာရန်)၊ နေ့စဉ်စျေးနှုန်းများ နှင့် Calendar သို့ တိုက်ရိုက် သွားရောက်နိုင်ပါသည်။',
          ),
        ],
      ),

      // ၂။ Guide (မြေတိုင်းတာခြင်း & ပြက္ခဒိန်)
      GuideItem(
        title: 'Guide (Offline)',
        icon: Icons.menu_book,
        subItems: [
          GuideSubItem(
            subTitle: '• Measure (မြေတိုင်းတာခြင်း)',
            subDescription: 'GPS စနစ်ကို အသုံးပြု၍ စိုက်ပျိုးမြေ၏ အကျယ်အဝန်း၊ ဧရိယာတို့ကို တိကျစွာ တိုင်းတာပြီး မှတ်တမ်းတင် သိမ်းဆည်းနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• Calendar (စိုက်ပျိုးရေး ပြက္ခဒိန်)',
            subDescription: 'သီးနှံအလိုက် စိုက်ပျိုးချိန်၊ မြေသြဇာကျွေးချိန်၊ ပိုးသတ်ဆေးဖျန်းချိန် နှင့် ရိတ်သိမ်းချိန်များကို မှတ်တမ်းတင် သတိပေးချက် ပြုလုပ်နိုင်ပါသည်။',
          ),
        ],
      ),

      // ၃။ AI Assistant (Sub UI မရှိ - Description တစ်ခုတည်းပါဝင်)
      GuideItem(
        title: 'AI Assistant (Online)',
        icon: Icons.psychology_rounded,
        mainDescription:
        'စိုက်ပျိုးရေးနှင့် ပတ်သက်သော မေးခွန်းများ၊ သီးနှံရောဂါများ၊ စိုက်ပျိုးနည်းစနစ်များကို AI အကူအညီဖြင့် မေးမြန်းစုံစမ်းနိုင်သော စမတ်ကျသည့် စနစ်ဖြစ်ပါသည်။',
      ),

      // ၄။ Pesticides
      GuideItem(
        title: 'Pesticides (Offline)',
        icon: Icons.sanitizer_rounded,
        subItems: [
          GuideSubItem(
            subTitle: '• ပိုးသတ်ဆေး အမျိုးအစားများ ရှာဖွေခြင်း',
            subDescription: 'သီးနှံအလိုက် ကျရောက်တတ်သော ဖျက်ပိုးများအတွက် သင့်တော်သည့် ပိုးသတ်ဆေးများကို ရှာဖွေကြည့်ရှုနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• ဆေးနှုန်းထားနှင့် သုံးစွဲပုံ လမ်းညွှန်',
            subDescription: 'ဆေးတစ်ခွက်လျှင် ရေမည်မျှ ရောစပ်ရမည်နှင့် ဘေးအန္တရာယ်ကင်းရှင်းစွာ သုံးစွဲနိုင်မည့် ညွှန်ကြားချက်များ ပါဝင်ပါသည်။',
          ),
        ],
      ),

      // ၅။ News (Newsfeed)
      GuideItem(
        title: 'News (Online)',
        icon: Icons.newspaper_rounded,
        subItems: [
          GuideSubItem(
            subTitle: '• စိုက်ပျိုးရေး သတင်းများ',
            subDescription: 'ပြည်တွင်းပြည်ပ စိုက်ပျိုးရေးဆိုင်ရာ နောက်ဆုံးရ သတင်းနှင့် နည်းပညာအသစ်များကို ဖတ်ရှုနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• စျေးကွက် သတင်းအချက်အလက်',
            subDescription: 'သီးနှံစျေးကွက် အခြေအနေနှင့် ရောင်းဝယ်ရေးဆိုင်ရာ သတင်းအချက်အလက်များကို လေ့လာနိုင်ပါသည်။',
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'အသုံးပြုနည်း လမ်းညွှန်',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AppBackground(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: guideList.length,
          itemBuilder: (context, index) {
            final item = guideList[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Theme(
                // Divider စည်းကြောင်း ပျောက်သွားစေရန် Theme ပြင်ထားပါသည်
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: AppColors.primaryColor, size: 24),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.black12, height: 1),
                    const SizedBox(height: 12),

                    // 💡 Condition 1: Sub UI / Sub Items မရှိပါက Description တစ်ခုတည်းပြမည်
                    if (item.mainDescription != null)
                      Text(
                        item.mainDescription!,
                        style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black87),
                      ),

                    // 💡 Condition 2: Sub UI / Sub Items ရှိပါက Sub Title & Sub Description အစုံလိုက်ပြမည်
                    if (item.subItems != null)
                      ...item.subItems!.map((sub) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sub.subTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sub.subDescription,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}