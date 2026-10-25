# Laplace Rush

App para estudiar el Certamen 2 de Automatización y Control (USM): repaso por tema, tests, simulacro de 2 ejercicios en 90 minutos, cuestionario en modo reels, sobres de cartas y ranking con usuario y contraseña.

Es una página estática (`index.html`) publicada con GitHub Pages. El login y el ranking usan Supabase.

## Configuración
1. En Supabase: Authentication → Sign In / Providers → Email → desactivar **Confirm email**.
2. En Supabase: SQL Editor → pegar `supabase.sql` → Run.
3. En `config.js`: poner la Project URL y la anon public key (Project Settings → API).

Las contraseñas las guarda Supabase cifradas. Por dentro cada usuario se registra con un correo ficticio `usuario@laplace-rush.app`, así que una contraseña olvidada no se puede recuperar por correo.
