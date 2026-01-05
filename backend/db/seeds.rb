# Populate Training Splits
splits = [
  { name: "PPL", description: "Push, Pull, Legs - A balanced 3-day split." },
  { name: "Arnold", description: "Chest/Back, Shoulders/Arms, Legs - Classic bodybuilding split." }
]

splits.each do |split|
  TrainingSplit.find_or_create_by!(name: split[:name]) do |s|
    s.description = split[:description]
  end
end

puts "Seeded #{TrainingSplit.count} training splits."

# Helper to find split
ppl = TrainingSplit.find_by(name: "PPL")
arnold = TrainingSplit.find_by(name: "Arnold")

# Create Training Days for PPL
ppl_days = [
  { name: "Push", order: 1 },
  { name: "Pull", order: 2 },
  { name: "Legs", order: 3 },
  { name: "Rest", order: 4 }
]

ppl_days.each do |day|
  TrainingDay.find_or_create_by!(split: ppl, day_order: day[:order]) do |d|
    d.day_name = day[:name]
  end
end

# Create Training Days for Arnold
arnold_days = [
  { name: "Chest & Back", order: 1 },
  { name: "Shoulders & Arms", order: 2 },
  { name: "Legs & Lower Back", order: 3 },
  { name: "Rest", order: 4 }
]

arnold_days.each do |day|
  TrainingDay.find_or_create_by!(split: arnold, day_order: day[:order]) do |d|
    d.day_name = day[:name]
  end
end

# Exercises Data
exercises_data = {
  "Push" => [
    "Barbell Bench Press", "Incline Dumbbell Press", "Overhead Press", "Lateral Raises", "Tricep Pushdowns", "Skullcrushers"
  ],
  "Pull" => [
    "Barbell Deadlift", "Pull Ups", "Barbell Rows", "Face Pulls", "Barbell Bicep Curls", "Hammer Curls"
  ],
  "Legs" => [
    "Barbell Squat", "Leg Press", "Romanian Deadlift", "Leg Extensions", "Leg Curls", "Standing Calf Raises"
  ],
  "Chest & Back" => [
    "Barbell Bench Press", "Weighted Pull Ups", "Incline Dumbbell Press", "T-Bar Rows", "Dumbbell Flyes", "Lat Pulldowns"
  ],
  "Shoulders & Arms" => [
    "Seated Dumbbell Press", "Barbell Bicep Curls", "Lateral Raises", "Tricep Rope Pushdowns", "Front Raises", "Overhead Tricep Extensions"
  ],
  "Legs & Lower Back" => [
    "Barbell Squat", "Stiff-Legged Deadlift", "Walking Lunges", "Leg Extensions", "Seated Calf Raises"
  ]
}

# Seed Exercises
exercises_data.each do |day_name, exercises|
  # Find days with this name (could be in multiple splits, but names are unique enough here or we loop splits)
  days = TrainingDay.where(day_name: day_name)
  
  days.each do |day|
    exercises.each_with_index do |exercise_name, index|
      # Check if exercise exists globally or just create it linked to the day?
      # Assuming a many-to-many or one-to-many. Let's assume Exercise is a model linked to TrainingDay
      # Wait, schema might be different. Let's check schema/models if needed.
      # Assuming Exercise belongs_to :training_day for simplicity based on previous context or just creates associated records.
      
      exercise = Exercise.find_or_create_by!(name: exercise_name)
      
      # Link exercise to the day via DayExercise
      DayExercise.find_or_create_by!(day: day, exercise: exercise)
    end
  end
end

puts "Seeded Exercises."
