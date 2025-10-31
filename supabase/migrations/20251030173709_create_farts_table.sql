/*
  # Create farts logging table

  1. New Tables
    - `farts`
      - `id` (uuid, primary key) - Unique identifier for each fart log
      - `user_id` (uuid, foreign key) - References auth.users
      - `logged_at` (timestamptz) - When the fart was logged
      - `is_silent` (boolean) - Whether it was a silent fart
      - `created_at` (timestamptz) - Record creation timestamp
  
  2. Security
    - Enable RLS on `farts` table
    - Add policy for authenticated users to read their own fart logs
    - Add policy for authenticated users to insert their own fart logs
    - Add policy for authenticated users to delete their own fart logs
*/

CREATE TABLE IF NOT EXISTS farts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  logged_at timestamptz DEFAULT now() NOT NULL,
  is_silent boolean DEFAULT false NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL
);

ALTER TABLE farts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own fart logs"
  ON farts
  FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own fart logs"
  ON farts
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own fart logs"
  ON farts
  FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_farts_user_id ON farts(user_id);
CREATE INDEX IF NOT EXISTS idx_farts_logged_at ON farts(logged_at);
