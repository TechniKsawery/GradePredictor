-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  avatar_url TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS for profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can view their own profile' AND tablename = 'profiles') THEN
        CREATE POLICY "Users can view their own profile" ON profiles FOR SELECT USING (auth.uid() = id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can update their own profile' AND tablename = 'profiles') THEN
        CREATE POLICY "Users can update their own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can insert their own profile' AND tablename = 'profiles') THEN
        CREATE POLICY "Users can insert their own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
    END IF;
END $$;

-- Function to handle new user profiles
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, display_name)
  VALUES (new.id, split_part(new.email, '@', 1))
  ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on signup
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created') THEN
        CREATE TRIGGER on_auth_user_created
          AFTER INSERT ON auth.users
          FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
    END IF;
END $$;

-- Subjects table
CREATE TABLE IF NOT EXISTS subjects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  grading_mode TEXT DEFAULT 'mixed',
  max_normal_points DOUBLE PRECISION,
  max_bonus_points DOUBLE PRECISION,
  custom_grading_scale JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add columns for subject max points
DO $$
DECLARE
    attempts INT := 0;
BEGIN
    LOOP
        attempts := attempts + 1;
        BEGIN
            ALTER TABLE subjects ADD COLUMN IF NOT EXISTS max_normal_points DOUBLE PRECISION;
            ALTER TABLE subjects ADD COLUMN IF NOT EXISTS max_bonus_points DOUBLE PRECISION;
            ALTER TABLE subjects ADD COLUMN IF NOT EXISTS grading_mode TEXT DEFAULT 'mixed';
            ALTER TABLE subjects ADD COLUMN IF NOT EXISTS custom_grading_scale JSONB;
            EXIT;
        EXCEPTION WHEN SQLSTATE '40P01' THEN
            IF attempts >= 5 THEN
                RAISE;
            END IF;
            PERFORM pg_sleep(0.2 * attempts);
        END;
    END LOOP;
END $$;

-- Grades table
CREATE TABLE IF NOT EXISTS grades (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject_id UUID REFERENCES subjects(id) ON DELETE CASCADE,
  grade DOUBLE PRECISION NOT NULL,
  weight DOUBLE PRECISION NOT NULL DEFAULT 1.0,
  type TEXT DEFAULT 'test',
  date TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Exams table (calendar)
CREATE TABLE IF NOT EXISTS exams (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subject_id UUID REFERENCES subjects(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    date TIMESTAMPTZ NOT NULL,
    weight DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    max_points DOUBLE PRECISION,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE grades ENABLE ROW LEVEL SECURITY;
ALTER TABLE exams ENABLE ROW LEVEL SECURITY;

-- Policies for subjects
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can manage their own subjects' AND tablename = 'subjects') THEN
        CREATE POLICY "Users can manage their own subjects" ON subjects FOR ALL USING (auth.uid() = user_id);
    END IF;
END $$;

-- Policies for grades
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can manage grades of their own subjects' AND tablename = 'grades') THEN
        CREATE POLICY "Users can manage grades of their own subjects" ON grades FOR ALL USING (
            subject_id IN (SELECT id FROM subjects WHERE user_id = auth.uid())
        );
    END IF;
END $$;

-- Policies for exams
DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can manage exams of their own subjects' AND tablename = 'exams') THEN
        CREATE POLICY "Users can manage exams of their own subjects" ON exams FOR ALL USING (
            subject_id IN (SELECT id FROM subjects WHERE user_id = auth.uid())
        );
    END IF;
END $$;

-- Add points columns to grades
DO $$
DECLARE
    attempts INT := 0;
BEGIN
    LOOP
        attempts := attempts + 1;
        BEGIN
            ALTER TABLE grades ADD COLUMN IF NOT EXISTS points DOUBLE PRECISION;
            ALTER TABLE grades ADD COLUMN IF NOT EXISTS max_points DOUBLE PRECISION;
            EXIT;
        EXCEPTION WHEN SQLSTATE '40P01' THEN
            IF attempts >= 5 THEN
                RAISE;
            END IF;
            PERFORM pg_sleep(0.2 * attempts);
        END;
    END LOOP;
END $$;
