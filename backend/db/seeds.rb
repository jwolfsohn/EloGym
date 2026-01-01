# Clear existing data
puts "Clearing existing data..."
DayExercise.destroy_all
CompletedExercise.destroy_all
UserSplit.destroy_all
Friend.destroy_all
Battle.destroy_all
TrainingDay.destroy_all
Exercise.destroy_all
TrainingSplit.destroy_all
User.destroy_all

puts "Creating exercises..."

# Create exercises
exercises_data = [
  # Push exercises
  { name: "Bench Press", muscle_group: "Chest", equipment: "Barbell" },
  { name: "Incline Bench Press", muscle_group: "Chest", equipment: "Barbell" },
  { name: "Dumbbell Press", muscle_group: "Chest", equipment: "Dumbbell" },
  { name: "Overhead Press", muscle_group: "Shoulders", equipment: "Barbell" },
  { name: "Dumbbell Shoulder Press", muscle_group: "Shoulders", equipment: "Dumbbell" },
  { name: "Lateral Raise", muscle_group: "Shoulders", equipment: "Dumbbell" },
  { name: "Front Raise", muscle_group: "Shoulders", equipment: "Dumbbell" },
  { name: "Tricep Extension", muscle_group: "Triceps", equipment: "Cable" },
  { name: "Tricep Dips", muscle_group: "Triceps", equipment: "Bodyweight" },
  { name: "Close Grip Bench Press", muscle_group: "Triceps", equipment: "Barbell" },

  # Pull exercises
  { name: "Deadlift", muscle_group: "Back", equipment: "Barbell" },
  { name: "Barbell Row", muscle_group: "Back", equipment: "Barbell" },
  { name: "Pull-ups", muscle_group: "Back", equipment: "Bodyweight" },
  { name: "Lat Pulldown", muscle_group: "Back", equipment: "Cable" },
  { name: "T-Bar Row", muscle_group: "Back", equipment: "Barbell" },
  { name: "Face Pulls", muscle_group: "Rear Delts", equipment: "Cable" },
  { name: "Bicep Curl", muscle_group: "Biceps", equipment: "Barbell" },
  { name: "Hammer Curl", muscle_group: "Biceps", equipment: "Dumbbell" },
  { name: "Preacher Curl", muscle_group: "Biceps", equipment: "Dumbbell" },

  # Leg exercises
  { name: "Squat", muscle_group: "Legs", equipment: "Barbell" },
  { name: "Front Squat", muscle_group: "Legs", equipment: "Barbell" },
  { name: "Leg Press", muscle_group: "Legs", equipment: "Machine" },
  { name: "Leg Extension", muscle_group: "Quads", equipment: "Machine" },
  { name: "Leg Curl", muscle_group: "Hamstrings", equipment: "Machine" },
  { name: "Romanian Deadlift", muscle_group: "Hamstrings", equipment: "Barbell" },
  { name: "Calf Raise", muscle_group: "Calves", equipment: "Machine" },
  { name: "Lunges", muscle_group: "Legs", equipment: "Dumbbell" },

  # Arnold specific (Chest/Back)
  { name: "Cable Flyes", muscle_group: "Chest", equipment: "Cable" },
  { name: "Dumbbell Flyes", muscle_group: "Chest", equipment: "Dumbbell" },
  { name: "Chest Dips", muscle_group: "Chest", equipment: "Bodyweight" },
  { name: "Seated Cable Row", muscle_group: "Back", equipment: "Cable" },
  { name: "One Arm Dumbbell Row", muscle_group: "Back", equipment: "Dumbbell" },

  # Arnold Shoulders/Arms
  { name: "Arnold Press", muscle_group: "Shoulders", equipment: "Dumbbell" },
  { name: "Upright Row", muscle_group: "Shoulders", equipment: "Barbell" },
  { name: "Shrugs", muscle_group: "Traps", equipment: "Dumbbell" },
  { name: "Skull Crushers", muscle_group: "Triceps", equipment: "Barbell" },
  { name: "Concentration Curl", muscle_group: "Biceps", equipment: "Dumbbell" },
]

exercises = {}
exercises_data.each do |ex|
  exercise = Exercise.create!(ex)
  exercises[ex[:name]] = exercise
end

puts "Created #{Exercise.count} exercises"

# Create PPL Split
puts "Creating PPL split..."
ppl = TrainingSplit.create!(
  name: "PPL",
  description: "Push-Pull-Legs: A 3-day rotation focusing on pushing movements, pulling movements, and leg exercises"
)

# PPL Days
push_day = TrainingDay.create!(split: ppl, day_name: "Push", day_order: 1)
pull_day = TrainingDay.create!(split: ppl, day_name: "Pull", day_order: 2)
legs_day = TrainingDay.create!(split: ppl, day_name: "Legs", day_order: 3)

# Push day exercises
[
  "Bench Press", "Incline Bench Press", "Dumbbell Press",
  "Overhead Press", "Dumbbell Shoulder Press", "Lateral Raise", "Front Raise",
  "Tricep Extension", "Tricep Dips", "Close Grip Bench Press"
].each do |name|
  DayExercise.create!(day: push_day, exercise: exercises[name])
end

# Pull day exercises
[
  "Deadlift", "Barbell Row", "Pull-ups", "Lat Pulldown",
  "T-Bar Row", "Face Pulls", "Bicep Curl", "Hammer Curl", "Preacher Curl"
].each do |name|
  DayExercise.create!(day: pull_day, exercise: exercises[name])
end

# Legs day exercises
[
  "Squat", "Front Squat", "Leg Press", "Leg Extension",
  "Leg Curl", "Romanian Deadlift", "Calf Raise", "Lunges"
].each do |name|
  DayExercise.create!(day: legs_day, exercise: exercises[name])
end

puts "Created PPL split with #{ppl.training_days.count} days"

# Create Arnold Split
puts "Creating Arnold split..."
arnold = TrainingSplit.create!(
  name: "Arnold",
  description: "Arnold Schwarzenegger's split: Chest/Back, Shoulders/Arms, Legs"
)

# Arnold Days
chest_back_day = TrainingDay.create!(split: arnold, day_name: "Chest & Back", day_order: 1)
shoulders_arms_day = TrainingDay.create!(split: arnold, day_name: "Shoulders & Arms", day_order: 2)
arnold_legs_day = TrainingDay.create!(split: arnold, day_name: "Legs", day_order: 3)

# Chest & Back day exercises
[
  "Bench Press", "Incline Bench Press", "Dumbbell Flyes", "Cable Flyes", "Chest Dips",
  "Deadlift", "Barbell Row", "Pull-ups", "T-Bar Row", "Seated Cable Row", "One Arm Dumbbell Row"
].each do |name|
  DayExercise.create!(day: chest_back_day, exercise: exercises[name])
end

# Shoulders & Arms day exercises
[
  "Overhead Press", "Arnold Press", "Dumbbell Shoulder Press",
  "Lateral Raise", "Front Raise", "Upright Row", "Shrugs",
  "Bicep Curl", "Hammer Curl", "Concentration Curl",
  "Tricep Extension", "Skull Crushers", "Close Grip Bench Press"
].each do |name|
  DayExercise.create!(day: shoulders_arms_day, exercise: exercises[name])
end

# Arnold Legs day exercises
[
  "Squat", "Front Squat", "Leg Press", "Leg Extension",
  "Leg Curl", "Romanian Deadlift", "Lunges", "Calf Raise"
].each do |name|
  DayExercise.create!(day: arnold_legs_day, exercise: exercises[name])
end

puts "Created Arnold split with #{arnold.training_days.count} days"

# Create demo users
puts "Creating demo users..."

demo_user = User.create!(
  username: "demo_user",
  email: "demo@elogym.com",
  password: "password123",
  password_confirmation: "password123",
  bodyweight: 180.0,
  total_points: 1500
)

demo_user.user_splits.create!(split: ppl)

john = User.create!(
  username: "john_lifter",
  email: "john@example.com",
  password: "password123",
  password_confirmation: "password123",
  bodyweight: 200.0,
  total_points: 3000
)

john.user_splits.create!(split: arnold)

jane = User.create!(
  username: "jane_strong",
  email: "jane@example.com",
  password: "password123",
  password_confirmation: "password123",
  bodyweight: 140.0,
  total_points: 2500
)

jane.user_splits.create!(split: ppl)

puts "Created #{User.count} demo users"

# Create friendships
Friend.create!(user: demo_user, friend: john, status: "accepted")
Friend.create!(user: demo_user, friend: jane, status: "accepted")

puts "Created friendships"

# Create a demo battle
Battle.create!(
  challenger: demo_user,
  opponent: john,
  status: "pending"
)

puts "Created demo battle"

puts "\n✅ Seed data created successfully!"
puts "\nDemo credentials:"
puts "Email: demo@elogym.com"
puts "Password: password123"
puts "\nTraining Splits:"
puts "- PPL: #{ppl.training_days.count} days, #{DayExercise.where(day: ppl.training_days).count} total exercise assignments"
puts "- Arnold: #{arnold.training_days.count} days, #{DayExercise.where(day: arnold.training_days).count} total exercise assignments"
