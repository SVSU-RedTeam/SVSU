/*
# Create contact submissions table

1. New Tables
- `contact_submissions`
- `id` (uuid, primary key): Unique identifier for each contact request.
- `name` (text): Visitor's name.
- `email` (text): Visitor's email address.
- `message` (text): Message submitted through the recruitment/contact form.
- `created_at` (timestamptz): Time the request was submitted.

2. Security
- Enable row-level security on `contact_submissions`.
- Allow anonymous and signed-in visitors to submit contact requests.
- Do not expose read, update, or delete access to visitors.

3. Important Notes
- This is a single-tenant public website without user accounts.
- The form only needs insert access; submissions remain private to privileged administrators.
*/

CREATE TABLE IF NOT EXISTS public.contact_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL CHECK (char_length(name) BETWEEN 1 AND 120),
  email text NOT NULL CHECK (char_length(email) BETWEEN 3 AND 254),
  message text NOT NULL CHECK (char_length(message) BETWEEN 1 AND 4000),
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.contact_submissions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public can submit contact requests" ON public.contact_submissions;
CREATE POLICY "Public can submit contact requests"
ON public.contact_submissions
FOR INSERT
TO anon, authenticated
WITH CHECK (true);

DROP POLICY IF EXISTS "Visitors cannot read contact requests" ON public.contact_submissions;
CREATE POLICY "Visitors cannot read contact requests"
ON public.contact_submissions
FOR SELECT
TO anon, authenticated
USING (false);

DROP POLICY IF EXISTS "Visitors cannot update contact requests" ON public.contact_submissions;
CREATE POLICY "Visitors cannot update contact requests"
ON public.contact_submissions
FOR UPDATE
TO anon, authenticated
USING (false)
WITH CHECK (false);

DROP POLICY IF EXISTS "Visitors cannot delete contact requests" ON public.contact_submissions;
CREATE POLICY "Visitors cannot delete contact requests"
ON public.contact_submissions
FOR DELETE
TO anon, authenticated
USING (false);