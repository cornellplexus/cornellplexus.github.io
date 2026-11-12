// Block Board settings.
//   supabaseUrl:      Supabase → Project Settings → API: the Project URL
//   supabaseAnonKey:  the "publishable" / "anon" key (safe here: the database only lets the signed-in team in)
//   teamEmail:        the shared team account everyone signs in to. Its password is set in Supabase
//                     (Authentication → Users) and is never written in this code.
// Never paste the "service_role" / "secret" key here.
// Leave supabaseUrl empty to run the board on one device only (handy for testing).
window.BLOCKBOARD_CONFIG = {
  supabaseUrl: "https://cskrawvrynicchqfmhlg.supabase.co",
  supabaseAnonKey: "sb_publishable_YjWEWxIlhxUWaFvUeUFNnQ_k-XbnFhw",
  teamEmail: "team@cornellplexus.example.com"
};
