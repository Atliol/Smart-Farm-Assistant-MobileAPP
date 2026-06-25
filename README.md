# 🌾 UniProject - Smart Agriculture Assistant

Flutter ဖြင့် တည်ဆောက်ထားပြီး တောင်သူလယ်သမားများအတွက် စိုက်ပျိုးရေးဆိုင်ရာ အကြံပေးချက်များကို ချက်ချင်း ပံ့ပိုးပေးနိုင်မည့် မိုဘိုင်းအပလီကေးရှင်း ဖြစ်ပါသည်။ ဤ App တွင် Google Gemini AI ကို အသုံးပြု၍ အမေးအဖြေပြုလုပ်နိုင်ခြင်းနှင့် Firebase Backend ကို အသုံးပြု၍ ဒေတာများကို စီမံခန့်ခွဲနိုင်ခြင်းတို့ ပါဝင်ပါသည်။

---

## 🚀 ထူးခြားချက်များ (Features)

* **AI Chat Assistant:** Google Gemini 1.5 Flash မော်ဒယ်ကို အသုံးပြု၍ စိုက်ပျိုးရေးပြဿနာများ၊ ပိုးမွှားနှိမ်နင်းနည်းများနှင့် မြေသြဇာအသုံးပြုမှုများကို အချိန်နှင့်တပြေးညီ မေးမြန်းနိုင်ခြင်း။
* **Quick Suggestion Chips:** တောင်သူများ အမေးများလေ့ရှိသည့် မေးခွန်းများကို ကလစ်တစ်ချက်နှိပ်ရုံဖြင့် အလွယ်တကူ မေးမြန်းနိုင်ခြင်း။
* **Firebase Integration:** လုံခြုံစိတ်ချရသော Backend စနစ်နှင့် User Authentication / Cloud Firestore ဒေတာသိုလှောင်မှုများအတွက် အဆင်သင့်ဖြစ်စေရန် ပြင်ဆင်ထားခြင်း။
* **Smooth UI/UX:** ဖုန်း screen အားလုံးနှင့် ကိုက်ညီပြီး မက်ဆေ့ခ်ျအသစ်ရောက်တိုင်း အလိုအလျောက် အောက်ဆုံးသို့ ဆင်းပေးမည့် ချောမွေ့သော Chat Performance။

---

## 🛠️ အသုံးပြုထားသော နည်းပညာများ (Tech Stack)

* **Frontend:** Flutter (Dart)
* **AI Engine:** Google Generative AI SDK (`google_generative_ai`)
* **Backend:** Firebase Core (`firebase_core`)
* **HTTP Network:** `http` package

---

## ⚙️ စတင်အသုံးပြုရန် ပြင်ဆင်ခြင်း (Setup Instructions)

### ၁။ လိုအပ်ချက်များ (Prerequisites)
* သင့်စက်တွင် **Flutter SDK** ထည့်သွင်းထားရပါမည်။
* **Node.js** နှင့် **Firebase CLI** ရှိရပါမည်။

### ၂။ Package များ ဒေါင်းလုဒ်ဆွဲခြင်း
ပရောဂျက် Folder ထဲတွင် Terminal ကိုဖွင့်ပြီး အောက်ပါ Command ကို Run ပါ-
```bash
flutter pub get
