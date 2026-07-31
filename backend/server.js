require("dotenv").config();

const express = require("express");

const app = express();

const PORT = 3000;

const OPENROUTER_API_URL =
  "https://openrouter.ai/api/v1/chat/completions";

const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;

if (!OPENROUTER_API_KEY) {
  console.error("❌ OPENROUTER_API_KEY မတွေ့ပါ");
  process.exit(1);
}

app.use(express.json({ limit: "10mb" }));

// ========================================
// Test API
// ========================================

app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Smart Farm Backend is running!",
  });
});

// ========================================
// AI Chat API
// ========================================

app.post("/api/ai/chat", async (req, res) => {
  try {
    const {
      userMessage,
      chatHistory = [],
      imageBase64,
    } = req.body;

    // ------------------------------------
    // Validate
    // ------------------------------------

    if (
      (!userMessage || userMessage.trim() === "") &&
      !imageBase64
    ) {
      return res.status(400).json({
        success: false,
        message: "Message သို့မဟုတ် Image လိုအပ်ပါတယ်။",
      });
    }

    // ------------------------------------
    // System Prompt
    // ------------------------------------

    const systemPrompt = `
You are an AI agriculture assistant for Myanmar farmers.

Your name is Smart Farm AI Assistant.

Your main purpose is to help farmers with:

- Rice farming
- Corn farming
- Vegetable farming
- Crop cultivation
- Soil management
- Fertilizer
- Pests
- Crop diseases
- Plant problems
- Irrigation
- Farming methods
- General agriculture questions

IMPORTANT RULES:

1. If the user asks in Myanmar language, answer in Myanmar language.

2. Keep answers simple and easy for Myanmar farmers to understand.

3. Give practical advice.

4. Use bullet points when appropriate.

5. If the user sends an image of a crop or plant, analyze the visible symptoms carefully.

6. Do not claim that an image diagnosis is 100% certain.

7. If you are uncertain, clearly explain that it may require confirmation from an agriculture expert.

8. When discussing pesticides or fertilizers, avoid giving dangerous or excessive instructions.

9. Explain the reason behind your recommendation when useful.

10. Do not make up information.

11. Be polite and helpful.

12. If the question is not related to agriculture, you can still answer briefly, but explain that you are mainly designed as an agriculture assistant.
`;

    // ------------------------------------
    // Messages
    // ------------------------------------

    const messages = [];

    messages.push({
      role: "system",
      content: systemPrompt,
    });

    // ------------------------------------
    // Chat History
    // ------------------------------------

    for (const message of chatHistory) {
      const role = message?.role;
      const content = message?.content;

      if (
        (role === "user" || role === "assistant") &&
        content &&
        content.toString().trim() !== ""
      ) {
        messages.push({
          role: role,
          content: content.toString(),
        });
      }
    }

    // ------------------------------------
    // Current User Message
    // ------------------------------------

    if (imageBase64) {
      const question =
        userMessage?.trim() ||
        `
ဒီဓာတ်ပုံထဲက အပင်/သီးနှံကို စစ်ဆေးပေးပါ။
မြင်ရတဲ့ လက္ခဏာတွေ၊ ဖြစ်နိုင်တဲ့ ပြဿနာ၊
နောက်ထပ် ဘာလုပ်သင့်လဲဆိုတာ မြန်မာလိုရှင်းပြပေးပါ။
`;

      messages.push({
        role: "user",
        content: [
          {
            type: "text",
            text: question,
          },
          {
            type: "image_url",
            image_url: {
              url: `data:image/jpeg;base64,${imageBase64}`,
            },
          },
        ],
      });
    } else {
      messages.push({
        role: "user",
        content: userMessage.trim(),
      });
    }

    // ------------------------------------
    // OpenRouter Request
    // ------------------------------------

    const requestBody = {
      model: "google/gemini-2.5-flash",
      messages: messages,
      temperature: 0.7,
      max_tokens: 1000,
    };

    const response = await fetch(OPENROUTER_API_URL, {
      method: "POST",

      headers: {
        Authorization: `Bearer ${OPENROUTER_API_KEY}`,
        "Content-Type": "application/json",
        "HTTP-Referer": "https://smartfarm.app",
        "X-Title": "Smart Farm",
      },

      body: JSON.stringify(requestBody),
    });

    const data = await response.json();

    // ------------------------------------
    // OpenRouter Error
    // ------------------------------------

    if (!response.ok) {
      console.error("OpenRouter Error:", data);

      return res.status(response.status).json({
        success: false,
        message:
          data?.error?.message ||
          "OpenRouter API Error",
      });
    }

    // ------------------------------------
    // AI Response
    // ------------------------------------

    const content =
      data?.choices?.[0]?.message?.content;

    if (!content) {
      return res.status(500).json({
        success: false,
        message: "AI response မရရှိပါ။",
      });
    }

    return res.json({
      success: true,
      answer: content.toString().trim(),
    });
  } catch (error) {
    console.error("Server Error:", error);

    return res.status(500).json({
      success: false,
      message: "AI Server Error",
    });
  }
});

// ========================================
// Start Server
// ========================================

app.listen(PORT, () => {
  console.log(
    `🚀 Smart Farm Backend running at http://localhost:${PORT}`
  );
});