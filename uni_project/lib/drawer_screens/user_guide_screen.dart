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
  final String? mainDescription;
  final List<GuideSubItem>? subItems;

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
    final List<GuideItem> guideList = [
      // ၁။ Home Section
      GuideItem(
        title: 'ပင်မ (Online & Offline)',
        icon: Icons.home_rounded,
        subItems: [
          GuideSubItem(
            subTitle: '• ၄ ရက်စာ မိုးလေဝသခန့်မှန်းချက်များ(Online)',
            subDescription: 'လက်ရှိ ရောက်ရှိနေသော မြို့ရွာဒေသ၏ ရာသီဥတု၊ အပူချိန်တို့ကို ကြည့်နိုင်ပါသည်။ "၄ ရက်စာ မိုးလေဝသ ခန့်မှန်းချက်များ" ကိုနှိပ်၍ နောက်ရက်စာ ခန့်မှန်းချက်များကို ကြည့်ရှုနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• တောင်သူလက်စွဲများ(Online & Offline)',
            subDescription: '# တိုင်းတာရန်(Online)\n---------------------------------\n GPS နည်းပညာကို အသုံးပြု၍ စိုက်ပျိုးမြေ ဧရိယာအကျယ်အဝန်းကို ကိုယ်တိုင် တိကျစွာ တိုင်းတာတွက်ချက်နိုင်ပါသည်။\n\n # သီးနှံစျေးနှုန်း(Online)\n------------------------------------\n ကုန်စည်ဒိုင်များ၏ စပါး၊ ပဲ၊ ပြောင်း၊ ဟင်းသီးဟင်းရွက် စသည့် သီးနှံအလိုက် နေ့စဉ် ပြင်ပစျေးကွက် ပေါက်စျေးများကို စစ်ဆေးကြည့်ရှုနိုင်ပါသည်။\n\n # မှတ်တမ်းစနစ်(Offline)\n-------------------------------------\n နေ့စဉ် စိုက်ပျိုးရေး ကုန်ကျစရိတ်နှင့် ဝင်ငွေများကို နေ့စဉ် မှတ်တမ်းတင်နိုင်ပြီး ရာသီကုန်ချိန်တွင် အရှုံး/အမြတ် တွက်ချက်ပေးမည် ဖြစ်ပါသည်။\n\n # တွက်ချက်ရန်(Offline)\n------------------------------------\n စပါး သို့မဟုတ် အခြားသီးနှံ တစ်ဧက စိုက်ပျိုးမည်ဆိုပါက ကုန်ကျမည့် စိုက်ပျိုးစရိတ်၊ လုပ်သားခ နှင့် ခန့်မှန်း သီးနှံပေါက်စျေးများကို ကြိုတင် တွက်ချက်ပေးပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• စိုက်ပျိုးနည်းပညာများ(Offline)',
            subDescription: 'စပါး၊ ပြောင်း၊ ခရမ်းချဉ် စသည့် သီးနှံများ၏ စိုက်ပျိုးချိန်နှင့် ပြုစုနည်းများကိုကြည့်နိုင်ပြီး "အားလုံး" ကိုနှိပ်၍ စိုက်ပျိုးရေး လမ်းညွှန်များ ဖတ်နိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• အပင်ရောဂါများ(Offline)',
            subDescription: 'ကျရောက်တတ်သော စိုက်ပျိုးရေး ရောဂါများကို လေ့လာနိုင်ပြီး "အားလုံး" ကို နှိပ်ပါက "အပင်ရောဂါ" အုပ်စုစစ်ထုတ်ထားသော ဗဟုသုတများဆီ သို့ တိုက်ရိုက် ရောက်ရှိပါမည်။',
          ),

          GuideSubItem(
            subTitle: '• ဓာတ်မြေဩဇာများ(Offline)',
            subDescription: 'သီးနှံအလိုက် လိုအပ်သော NPK အချိုးအစားများ၊ အပင်သက်တမ်းအလိုက် ကျွေးရမည့် နှုန်းထားများနှင့် မြေဆီလွှာ မပျက်စီးစေရန် သဘာဝမြေဩဇာ ပြုလုပ်သုံးစွဲနည်းများကို လေ့လာနိုင်ပါသည်။ "အားလုံး" ကိုနှိပ်၍ အသေးစိတ် ဖတ်ရှုနိုင်ပါသည်။',
          ),
        ],
      ),

      // ၂။ Guide Section (စိုက်ပျိုးရေး နည်းပညာ & ဗဟုသုတ)
      GuideItem(
        title: 'လမ်းညွှန် (Offline)',
        icon: Icons.menu_book_rounded,
        subItems: [
          GuideSubItem(
            subTitle: '• စိုက်ပျိုးနည်းပညာများ(Offline)',
            subDescription: 'သီးနှံအလိုက် မြေပြင်ဆင်ပုံ၊ မျိုးစေ့ချပုံ၊ ရေသွင်း/မြေသြဇာကျွေးပုံ စသည့် အဆင့်ဆင့် စိုက်ပျိုးနည်းများကို ရုပ်ပုံများနှင့်တကွ ဖတ်ရှုနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• မွေးမြူရေး နည်းပညာများ(Offline)',
            subDescription: 'ကြက်၊ ဝက်၊ နွား၊ ဆိတ် စသည့် တိရစ္ဆာန် မွေးမြူရေးဆိုင်ရာ စနစ်တကျ ပြုစုထိန်းသိမ်းနည်းများ၊ အစာကျွေးမွေးမှုစနစ်နှင့် ရောဂါကာကွယ်ရေး နည်းလမ်းများကို လေ့လာနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• ရေလုပ်ငန်း နည်းပညာများ(Offline)',
            subDescription: 'ငါး၊ ပုဇွန် စသည့် ရေသတ္တဝါ မွေးမြူရေး နည်းစနစ်များ၊ ကန်ပြုပြင် ထိန်းသိမ်းခြင်း၊ အစာကျွေးနည်းနှင့် ရေအရည်အသွေး ထိန်းသိမ်းခြင်းဆိုင်ရာ နည်းပညာများကို ဖတ်ရှုနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• အထွေထွေ ဗဟုသုတများ(Offline)',
            subDescription: 'အပင်ရောဂါ၊ မြေသြဇာအသုံးပြုပုံ၊ သီးနှံကာကွယ်ရေး စသည့် ခေါင်းစဉ် (Tag) အလိုက်ရွေးချယ်ပြီး ဖတ်ရှုနိုင်ပါသည်။',
          ),
        ],
      ),

      // ၃။ AI Assistant Section
      GuideItem(
        title: 'AI လက်စွဲ (Online)',
        icon: Icons.psychology_rounded,
        mainDescription:
        'စိုက်ပျိုးရေးနှင့် ပတ်သက်သော မေးခွန်းများ၊ သီးနှံရောဂါလက္ခဏာများ၊ ဆေးနှုန်းထားများနှင့် စိုက်ပျိုးနည်းစနစ်များကို AI အကူအညီဖြင့် မြန်မာဘာသာဖြင့် တိုက်ရိုက် မေးမြန်းစုံစမ်းနိုင်သော စမတ်ကျသည့် စနစ်ဖြစ်ပါသည်။ (အင်တာနက် လိုအပ်ပါသည်။)',
      ),

      // ၄။ Pesticides (ပိုးသတ်ဆေး၊ မှိုသတ်ဆေး၊ ပေါင်းသတ်ဆေးနှင့် မြေဩဇာများ)
      GuideItem(
        title: 'ဆေးဝါး (Offline)',
        icon: Icons.sanitizer_rounded,
        subItems: [
          GuideSubItem(
            subTitle: '• ပိုးသတ်ဆေး(Offline)',
            subDescription: 'သီးနှံအလိုက် ကျရောက်တတ်သော ဖျက်ပိုးများအတွက် သင့်တော်သည့် ပိုးသတ်ဆေးများကို အမျိုးအစားအလိုက် ရှာဖွေကြည့်ရှုနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• မှိုသတ်ဆေး/ကာကွယ်ဆေး(Offline)',
            subDescription: 'မှိုသတ်ဆေးနှင့် ကာကွယ်ဆေးများကို Offline ဖတ်ရှုနိုင်ပါသည်။',
          ),
          // 💡 ပေါင်းသတ်ဆေး Category အတွက် ဖြည့်စွက်ချက်
          GuideSubItem(
            subTitle: '• ပေါင်းသတ်ဆေး(Offline)',
            subDescription: 'သီးနှံအမျိုးအစားနှင့် ပေါင်းပင်အမျိုးအစား (ရိုးပြတ်/ရွက်ကျယ်/မြက်ပေါင်း) အလိုက် အသုံးပြုရမည့် ပေါင်းသတ်ဆေးများ၊ ဆေးနှုန်းထားနှင့် အသုံးပြုရမည့် အချိန်ကို လေ့လာနိုင်ပါသည်။',
          ),
          // 💡 ဓာတ်မြေဩဇာ Category အတွက် ဖြည့်စွက်ချက်
          GuideSubItem(
            subTitle: '• ဓာတ်မြေဩဇာ(Offline)',
            subDescription: 'သီးနှံအလိုက် လိုအပ်သော NPK (နိုက်ထရိုဂျင်၊ ဖော့စဖရပ်၊ ပိုတက်ဆီယမ်) ဓာတ်မြေဩဇာ အမျိုးအစားများ၊ အချိုးအစားနှင့် အပင်သက်တမ်းအလိုက် ကျွေးရမည့် နည်းလမ်းများကို ကြည့်ရှုနိုင်ပါသည်။',
          ),
        ],
      ),

      // ၅။ News (Community Newsfeed - တောင်သူချင်း ဆွေးနွေးမေးမြန်းရာ)
      GuideItem(
        title: 'သတင်းများ (Online)',
        icon: Icons.newspaper_rounded,
        subItems: [
          GuideSubItem(
            subTitle: '• အကောင့်ဖွင့်ခြင်းနှင့် စိုက်ပျိုးရေး မေးခွန်းများ မေးမြန်းခြင်း',
            subDescription: 'အကောင့်လွယ်ကူစွာ ဖွင့်လှစ်ပြီး မိမိစိုက်ပျိုးထားသော သီးနှံများတွင် ကြုံတွေ့နေရသည့် အခက်အခဲများ၊ ရောဂါများနှင့် မေးခွန်းများကို ဓာတ်ပုံများနှင့်တကွ ပို့စ် (Post) တင်၍ မေးမြန်းနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• Comment များတွင် ဝင်ရောက်ဆွေးနွေးခြင်း',
            subDescription: 'အခြားတောင်သူများနှင့် စိုက်ပျိုးရေး ပညာရှင်များ၏ ပို့စ်များတွင် မိမိ၏ အတွေ့အကြုံနှင့် အကြံဉာဏ်များကို Comment များ ရေးသား၍ လွတ်လပ်စွာ ဝင်ရောက်ဆွေးနွေးနိုင်ပါသည်။',
          ),
          GuideSubItem(
            subTitle: '• Post များကို Like, Share ပြုလုပ်ခြင်း',
            subDescription: 'မိမိ ကြိုက်နှစ်သက်သော သတင်းနှင့် နည်းပညာ ပို့စ်များကို Like ပေးခြင်း၊ အခြားတောင်သူများ သိရှိစေရန် Share ပြုလုပ်ခြင်းများပြုလုပ်နိုင်ပါသည်။',
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

                    // Condition 1: Sub UI မရှိလျှင် Description တစ်ခုတည်း ပြမည်
                    if (item.mainDescription != null)
                      Text(
                        item.mainDescription!,
                        style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black87),
                      ),

                    // Condition 2: Sub UI ရှိပါက Sub Title & Description အစုံလိုက် ပြမည်
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