import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  const { kakao_access_token } = await req.json()

  const kakaoRes = await fetch("https://kapi.kakao.com/v2/user/me", {
    headers: { Authorization: `Bearer ${kakao_access_token}` },
  })
  const kakaoUser = await kakaoRes.json()
  if (!kakaoUser.id) return new Response("invalid token", { status: 401 })

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  )

  const { data, error } = await supabase.auth.admin.generateLink({
    type: "magiclink",
    email: `kakao_${kakaoUser.id}@motungi.app`,
  })
  if (error) return new Response(error.message, { status: 500 })

  return new Response(JSON.stringify({ access_token: data.properties?.hashed_token }), {
    headers: { "Content-Type": "application/json" },
  })
})
