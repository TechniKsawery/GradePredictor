import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight request
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { grades } = await req.json()
    const apiKey = Deno.env.get("GEMINI_API_KEY")

    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: "Missing GEMINI_API_KEY environment variable" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      )
    }

    // Build compact representation
    const compactGrades = grades.map((g: any) => ({
      id: g.id || '',
      subject: g.subject_name || '',
      category: g.category_name || '',
      value: g.grade_text || '',
      comment: g.comment || '',
    }))

    const prompt = `
Jesteś ekspertem analizującym oceny i punkty w polskim dzienniku szkolnym (Librus/Vulcan).
Twoim zadaniem jest przeanalizowanie listy ocen i określenie dla każdej pozycji:
1. Czy to jest ocena punktowa (is_points: true) czy tradycyjna ocena 1-6 (is_points: false).
2. Liczba uzyskanych punktów (points: float lub null).
3. Maksymalna liczba punktów do zdobycia (max_points: float lub null).
4. Ostateczna wartość oceny w skali 1-6 (grade: float, np. "5-" to 4.75, "4+" to 4.5, "5" to 5.0, "1" to 1.0, brak oceny/nieobecność to 0.0).
   - Jeśli to ocena punktowa (is_points: true), zawsze przypisz grade = 0.0 (nie obliczaj oceny z punktów, aplikacja zajmie się tym na żądanie).
   - Jeśli to zwykła ocena (is_points: false), po prostu ją przeparsuj (np. "3+" -> 3.5, "4=" -> 3.75, "np"/"nb" -> 0.0).

Ważna zasada spójności przedmiotu: Zwróć uwagę, że zazwyczaj dany przedmiot w semestrze u jednego nauczyciela jest oceniany albo w pełni punktowo (wtedy nawet małe oceny typu "5" oznaczają 5 punktów, a nie ocenę bardzo dobrą), albo w pełni tradycyjnie (skala ocen 1-6). Przeanalizuj kontekst innych ocen w ramach tego samego przedmiotu (subject), aby podjąć spójną decyzję dla wszystkich ocen tego przedmiotu.

Zwróć wynik jako poprawny format JSON - wyłącznie tablicę obiektów (bez dodatkowego tekstu markdown, bez owijania w \`\`\`json):
Każdy obiekt w tablicy MUSI mieć dokładnie takie pola:
- "id": string (dokładnie ten sam co wejściowy)
- "is_points": boolean
- "points": number lub null
- "max_points": number lub null
- "grade": number
- "reason": string (krótkie wyjaśnienie dlaczego tak sklasyfikowano)

Oto dane do przetworzenia:
${JSON.stringify(compactGrades)}
`

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: { responseMimeType: "application/json" }
        })
      }
    )

    if (!response.ok) {
      const errText = await response.text()
      console.error(`[Gemini API Error] Status: ${response.status}. Details: ${errText}`)
      return new Response(
        JSON.stringify({ error: "Failed to call AI model" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      )
    }

    const resJson = await response.json()
    const textContent = (resJson.candidates?.[0]?.content?.parts?.[0]?.text || "").trim()

    try {
      // Validate that Gemini output is actual valid JSON
      const parsedData = JSON.parse(textContent)
      return new Response(
        JSON.stringify(parsedData),
        { headers: { ...corsHeaders, "Content-Type": "application/json" } }
      )
    } catch (parseError: any) {
      console.error(`[Gemini JSON Parse Error] Failed to parse output as JSON. Raw text: ${textContent}. Error: ${parseError.message}`)
      return new Response(
        JSON.stringify({ error: "AI model returned invalid JSON" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      )
    }

  } catch (error: any) {
    console.error(`[Edge Function Exception] ${error.message}`)
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    )
  }
})
