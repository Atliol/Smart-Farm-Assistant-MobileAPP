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
* **Offline Database** Hive  (`Json Type`)
* **Flutter Map** Land Measurement 
* **calculator** price calculator
* **money tracker** month,year money calculate 
* **Backend:** Firebase Core (`firebase_core`)
* **HTTP Network:** `http` package

---
# 📸 Screenshots
## loading page
<img width="988" height="574" alt="image" src="https://github.com/user-attachments/assets/a6871528-95a7-4be3-86f3-fad36e187fee" />

## login page
<img width="883" height="653" alt="image" src="https://github.com/user-attachments/assets/1e3e2772-4fdf-415b-9402-8ff03fb343b9" />

## Home page
<img width="975" height="584" alt="image" src="https://github.com/user-attachments/assets/21e95d73-29b3-459b-a096-c700554850be" />

## Room page
<img width="875" height="526" alt="image" src="https://github.com/user-attachments/assets/995db8d5-e8f6-4dcd-bddc-74f8cbc1543e" />

## Student page
<img width="975" height="580" alt="image" src="https://github.com/user-attachments/assets/d186625a-b522-4fc2-8bc3-bcb6cbae06a4" />

## Visitor page
<img width="975" height="585" alt="image" src="https://github.com/user-attachments/assets/2d953854-7907-4d63-a666-2846f0bbe674" />

## Fee page
<img width="862" height="515" alt="image" src="https://github.com/user-attachments/assets/ab10639f-1040-452e-a765-3028f847f442" />


## ⚙️ စတင်အသုံးပြုရန် ပြင်ဆင်ခြင်း (Setup Instructions)

### ၁။ လိုအပ်ချက်များ (Prerequisites)
* သင့်စက်တွင် **Flutter SDK** ထည့်သွင်းထားရပါမည်။
* **Node.js** နှင့် **Firebase CLI** ရှိရပါမည်။

### ၂။ Package များ ဒေါင်းလုဒ်ဆွဲခြင်း
ပရောဂျက် Folder ထဲတွင် Terminal ကိုဖွင့်ပြီး အောက်ပါ Command ကို Run ပါ
```bash
flutter pub get
```
### Firebase ထဲသို့ Log in ဝင်ပါ
```bash
firebase login
```

### FlutterFire CLI ကို အသုံးပြု၍ Configure လုပ်ပါ
```bash
dart pub global run flutterfire_cli:flutterfire configure
```
```bash
flutter run
```

