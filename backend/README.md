# EloGym - Gamified Fitness Tracking Application

A comprehensive Ruby on Rails 7 monolithic web application that gamifies fitness with an Elo rating system.

## Overview

EloGym is a fitness tracking and social workout application featuring:

- **Personalized Workouts**: Daily exercises based on training splits (PPL or Arnold)
- **Elo Rating System**: Users rank from E to S based on total points
- **Social Features**: Friends system and competitive battles
- **Dynamic Weight Calculation**: Personalized target weights based on bodyweight and rank
- **Modern UI**: Dark mode design with purple accents using TailwindCSS
- **Real-time Updates**: Hotwire (Turbo & Stimulus) for smooth interactions

## Tech Stack

### Backend
- **Framework**: Ruby on Rails 7.1+
- **Database**: PostgreSQL
- **Authentication**: JWT + Bcrypt (dual mode: session-based for web, JWT for API)
- **JSON Serialization**: Blueprinter

### Frontend
- **Rendering**: Server-Side ERB templates
- **Interactivity**: Hotwire (Turbo Drive, Turbo Frames, Turbo Streams)
- **JavaScript**: Stimulus controllers
- **Styling**: TailwindCSS with custom dark theme
- **Icons**: Heroicons (inline SVG)

## Database Schema

### Models & Relationships

1. **Users** - User accounts with authentication
   - Fields: username, email, password_digest, total_points, bodyweight, is_admin
   - Has many: training_splits, completed_exercises, friends, battles

2. **TrainingSplits** - Workout programs (PPL, Arnold)
   - Fields: name, description
   - Has many: training_days, users

3. **UserSplits** - Join table linking users to their chosen split
   - Belongs to: user, split

4. **Exercises** - Exercise database
   - Fields: name, muscle_group, equipment, instructions
   - Includes base weight multipliers

5. **TrainingDays** - Days in a training split rotation
   - Fields: day_name, day_order
   - Belongs to: split
   - Has many: exercises

6. **DayExercises** - Join table for exercises in a training day
   - Belongs to: training_day, exercise

7. **CompletedExercises** - User workout history
   - Fields: completed_at
   - Belongs to: user, exercise
   - Triggers point awards on creation

8. **Friends** - Friendship connections
   - Fields: status (pending, accepted, declined)
   - Self-referential User relationship

9. **Battles** - Competitive challenges
   - Fields: status, points_gained, points_lost
   - Belongs to: challenger, opponent, winner (all Users)

## Key Features

### Ranking System

Points-based ranking from E to S:
- **E Rank**: 0-499 points (0.5x weight multiplier)
- **D Rank**: 500-999 points (1.0x)
- **C Rank**: 1000-1999 points (1.25x)
- **B Rank**: 2000-3499 points (1.6x)
- **A Rank**: 3500-5499 points (1.8x)
- **S Rank**: 5500+ points (2.2x)

### Dynamic Weight Calculation

Formula: `Round((UserBodyweight × BaseMultiplier × RankMultiplier) / 5) × 5`

Base multipliers:
- Bench Press: 0.75
- Squat: 0.85
- Deadlift: 1.0
- Overhead Press: 0.45
- Barbell Row: 0.65
- Isolation movements: 0.1-0.2
- Default: 0.3

### API Endpoints

#### Authentication
- `POST /api/users/signup` - Create account
- `POST /api/users/login` - Login with JWT

#### User Management
- `GET /api/users/profile` - Get user profile
- `PATCH /api/users/split` - Update training split
- `POST /api/users/starting-stats` - Set bodyweight
- `GET /api/users/daily-exercises` - Get today's workout
- `POST /api/users/complete-exercise` - Mark exercise complete

#### Social/Matchmaking
- `GET /api/matchmaking/friends` - List friends
- `POST /api/matchmaking/friends/add` - Add friend
- `GET /api/matchmaking/search` - Search users
- `POST /api/matchmaking/battle/challenge` - Challenge to battle

### Frontend Routes

- `/` - Dashboard (requires login)
- `/login` - Login page
- `/signup` - Registration page
- `/onboarding/welcome` - Onboarding intro
- `/onboarding/split` - Choose training split
- `/onboarding/stats` - Set starting stats
- `/battles` - Battles & friends
- `/users/:id` - User profile

## Installation & Setup

### Prerequisites
- Ruby 3.2+
- PostgreSQL
- Bundler

### Steps

1. **Install Dependencies**
   ```bash
   cd backend
   bundle install
   ```

2. **Database Setup**
   ```bash
   # Create database
   rails db:create

   # Run migrations
   rails db:migrate

   # Seed initial data (PPL & Arnold splits, exercises, demo users)
   rails db:seed
   ```

3. **Start Server**
   ```bash
   rails server
   ```

4. **Access Application**
   - Open browser to `http://localhost:3000`
   - Login with demo account:
     - Email: `demo@elogym.com`
     - Password: `password123`

## Project Structure

```
backend/
├── app/
│   ├── controllers/
│   │   ├── api/                    # API endpoints
│   │   │   ├── users_controller.rb
│   │   │   ├── matchmaking_controller.rb
│   │   │   └── matchmaking/
│   │   │       └── battle_controller.rb
│   │   ├── application_controller.rb
│   │   ├── dashboard_controller.rb
│   │   ├── onboarding_controller.rb
│   │   ├── battles_controller.rb
│   │   ├── users_controller.rb
│   │   ├── sessions_controller.rb
│   │   └── registrations_controller.rb
│   ├── models/
│   │   ├── user.rb
│   │   ├── training_split.rb
│   │   ├── exercise.rb
│   │   ├── battle.rb
│   │   └── ... (9 total models)
│   ├── views/
│   │   ├── layouts/
│   │   │   └── application.html.erb  # Main layout with nav
│   │   ├── dashboard/
│   │   │   └── index.html.erb
│   │   ├── onboarding/
│   │   │   ├── welcome.html.erb
│   │   │   ├── split.html.erb
│   │   │   └── stats.html.erb
│   │   ├── battles/
│   │   ├── users/
│   │   ├── sessions/
│   │   ├── exercises/
│   │   │   └── _exercise_card.html.erb
│   │   └── friends/
│   │       └── _friend_card.html.erb
│   ├── javascript/
│   │   ├── application.js
│   │   └── controllers/
│   │       ├── confetti_controller.js
│   │       ├── modal_controller.js
│   │       └── toggle_controller.js
│   └── assets/
│       └── stylesheets/
│           └── application.tailwind.css
├── config/
│   ├── routes.rb
│   ├── database.yml
│   ├── importmap.rb
│   └── ...
├── db/
│   ├── migrate/              # All 9 migrations
│   └── seeds.rb              # PPL & Arnold splits + exercises
├── lib/
│   └── json_web_token.rb     # JWT helper
├── Gemfile
├── tailwind.config.js
└── README.md
```

## Stimulus Controllers

### Confetti Controller
Triggers celebration animations when exercises are completed or ranks increase.

**Actions:**
- `fire()` - Single confetti burst
- `celebration()` - Extended celebration
- `rankUp()` - Rank increase celebration

**Usage:**
```html
<div data-controller="confetti">
  <button data-action="click->confetti#fire">Celebrate!</button>
</div>
```

### Modal Controller
Manages modal dialogs (e.g., battle challenges).

**Actions:**
- `open()` - Show modal
- `close()` - Hide modal
- `closeBackground(event)` - Close when clicking backdrop

**Usage:**
```html
<div data-controller="modal" data-modal-target="container">
  <button data-action="click->modal#open">Open</button>
</div>
```

### Toggle Controller
Shows/hides content with smooth transitions.

**Actions:**
- `toggle()` - Toggle visibility
- `show()` - Show content
- `hide()` - Hide content

## Design System

### Colors
- **Brand Purple**: `#7c3aed` - Primary actions, highlights
- **Dark Background**: `#1e1e1e` - Main background
- **Zinc-900**: `#18181b` - Card backgrounds
- **Zinc-800**: `#27272a` - Secondary backgrounds

### Components
- `.btn-primary` - Purple gradient button
- `.btn-secondary` - Gray button
- `.card` - Standard card container
- `.card-glass` - Glassmorphic card
- `.input-field` - Form input
- `.rank-badge` - Circular rank display
- `.rank-{S|A|B|C|D|E}` - Rank-specific colors

### Rank Colors
- **S**: Gold/Orange gradient
- **A**: Purple/Pink gradient
- **B**: Blue/Cyan gradient
- **C**: Green/Emerald gradient
- **D**: Gray gradient
- **E**: Zinc gradient

## Seed Data

The seed file creates:
- 37 exercises across all muscle groups
- PPL split (3 days: Push, Pull, Legs)
- Arnold split (3 days: Chest/Back, Shoulders/Arms, Legs)
- 3 demo users with different ranks
- Example friendships and battles

## Development Notes

### Authentication
The app supports dual authentication:
1. **Session-based**: For web interface (cookies)
2. **JWT-based**: For API endpoints (Authorization header)

Both are handled in `ApplicationController` with the `current_user` helper.

### Weight Calculation
Target weights are calculated dynamically in the `Exercise` model using the `target_weight_for_user(user)` method. This considers:
- User's bodyweight
- Exercise base multiplier
- User's current rank multiplier

### Points System
Points are awarded automatically via ActiveRecord callback in `CompletedExercise`:
- S Rank: 100 points per exercise
- A Rank: 80 points
- B Rank: 60 points
- C Rank: 40 points
- D Rank: 20 points
- E Rank: 10 points

## Future Enhancements

Potential features to add:
- [ ] Progressive web app (PWA) support
- [ ] Exercise video demonstrations
- [ ] Advanced battle mechanics (lift comparisons)
- [ ] Leaderboards
- [ ] Workout history charts
- [ ] Rest timer during workouts
- [ ] Custom training split builder
- [ ] Push notifications
- [ ] Social feed
- [ ] Achievement badges

## License

This project was created as part of the EloGym fitness tracking platform.

## Credits

Built with:
- Ruby on Rails
- TailwindCSS
- Hotwire (Turbo & Stimulus)
- PostgreSQL
- Canvas Confetti
- Heroicons
