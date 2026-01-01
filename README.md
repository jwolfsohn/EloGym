# EloGym - Gamified Fitness Tracking Platform

A complete fitness tracking web application with an Elo-based ranking system, built with Ruby on Rails.

## Project Structure

```
EloGym/
├── backend/           # Full Rails monolithic application (API + Frontend)
├── frontend/          # (Reserved for future separate frontend if needed)
├── Backendplan.txt    # Backend implementation specifications
├── Frontendplan.txt   # Frontend implementation specifications
└── README.md          # This file
```

## Implementation Overview

This project has been fully implemented according to both `Backendplan.txt` and `Frontendplan.txt`. The implementation follows a **monolithic architecture** where the backend Rails application includes both:

1. **RESTful API endpoints** for programmatic access
2. **Server-rendered frontend** with Hotwire for interactivity

All code is located in the `backend/` folder, which contains a complete Ruby on Rails 7 application.

## Quick Start

### Prerequisites
- Ruby 3.2 or higher
- PostgreSQL
- Bundler gem

### Installation

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   # Create database
   rails db:create

   # Run all migrations
   rails db:migrate

   # Load seed data (training splits, exercises, demo users)
   rails db:seed
   ```

4. Start the Rails server:
   ```bash
   rails server
   ```

5. Open your browser to `http://localhost:3000`

### Demo Account

Login with the pre-seeded demo account:
- **Email**: `demo@elogym.com`
- **Password**: `password123`

## What's Implemented

### Backend Features ✅
- [x] Ruby on Rails 7.1+ with PostgreSQL
- [x] 9 database models with full associations
- [x] JWT + Bcrypt authentication (dual mode: sessions + API tokens)
- [x] Dynamic weight calculation service
- [x] Complete API endpoints for:
  - User authentication (signup, login)
  - Profile management
  - Training split selection
  - Daily workout generation
  - Exercise completion tracking
  - Friend management
  - Battle system
- [x] Comprehensive seed data (PPL & Arnold splits, 37+ exercises)

### Frontend Features ✅
- [x] Dark mode premium design with TailwindCSS
- [x] Hotwire (Turbo & Stimulus) for real-time interactions
- [x] Responsive navigation (top nav + bottom nav)
- [x] Complete page implementations:
  - [x] Login & Signup
  - [x] Onboarding flow (welcome, split selection, stats)
  - [x] Dashboard with date navigator
  - [x] Exercise cards with completion tracking
  - [x] Battles/Matchmaking view
  - [x] User profile with rank progress
- [x] Stimulus controllers:
  - [x] Confetti celebrations
  - [x] Modal dialogs
  - [x] Toggle functionality
- [x] Custom Tailwind theme (purple #7c3aed, dark backgrounds)
- [x] Reusable partials (exercise cards, friend cards)

### Core Mechanics ✅
- **Elo Ranking System**: 6 ranks (E → D → C → B → A → S) based on total points
- **Dynamic Weights**: Personalized targets calculated from bodyweight × exercise multiplier × rank multiplier
- **Training Splits**:
  - PPL (Push-Pull-Legs)
  - Arnold (Chest/Back, Shoulders/Arms, Legs)
- **Daily Rotation**: 3 random exercises from current training day
- **Points System**: Earn 10-100 points per completed exercise based on rank
- **Social Features**: Friends list and competitive battles

## Project Architecture

### Monolithic Rails App
The application uses a single Rails codebase (`backend/`) that serves both:

1. **Web Interface**: Server-rendered ERB templates with Hotwire
   - Accessed via browser at `http://localhost:3000`
   - Session-based authentication using cookies
   - Full interactive UI with Turbo & Stimulus

2. **JSON API**: RESTful endpoints under `/api/*`
   - Accessed programmatically
   - JWT token authentication via `Authorization` header
   - Returns JSON responses for mobile apps or external clients

### Technology Stack

**Backend:**
- Ruby on Rails 7.1
- PostgreSQL database
- Bcrypt for password hashing
- JWT for API tokens
- Blueprinter for JSON serialization

**Frontend:**
- ERB templates (server-rendered)
- TailwindCSS for styling
- Hotwire (Turbo + Stimulus) for JavaScript
- Canvas Confetti for celebrations
- Heroicons (SVG)

**Infrastructure:**
- Puma web server
- Importmap for JavaScript modules
- Bootsnap for faster boot times

## Database Models

| Model | Purpose | Key Fields |
|-------|---------|------------|
| User | User accounts | username, email, password_digest, total_points, bodyweight |
| TrainingSplit | Workout programs | name, description |
| UserSplit | User's chosen split | user_id, split_id |
| Exercise | Exercise library | name, muscle_group, equipment |
| TrainingDay | Days in a split | split_id, day_name, day_order |
| DayExercise | Exercises for a day | day_id, exercise_id |
| CompletedExercise | Workout history | user_id, exercise_id, completed_at |
| Friend | Friendships | user_id, friend_id, status |
| Battle | Competitive challenges | challenger_id, opponent_id, winner_id, status |

## API Endpoints

### Authentication
- `POST /api/users/signup` - Create account, returns JWT
- `POST /api/users/login` - Login, returns JWT

### User
- `GET /api/users/profile` - Get current user
- `PATCH /api/users/split` - Update training split
- `POST /api/users/starting-stats` - Set bodyweight
- `GET /api/users/daily-exercises` - Get today's workout
- `POST /api/users/complete-exercise` - Mark exercise complete

### Social
- `GET /api/matchmaking/friends` - List friends
- `POST /api/matchmaking/friends/add` - Add friend
- `GET /api/matchmaking/search` - Search users
- `POST /api/matchmaking/battle/challenge` - Send battle challenge

## Development

### Running Tests
```bash
# Tests not yet implemented
# Add test suite in spec/ or test/ directory
```

### Database Management
```bash
# Reset database
rails db:drop db:create db:migrate db:seed

# Check migrations status
rails db:migrate:status

# Rollback last migration
rails db:rollback
```

### Rails Console
```bash
# Open Rails console for debugging
rails console

# Example: Create a user
User.create(username: "newuser", email: "new@example.com", password: "password123")

# Example: Check all splits
TrainingSplit.all
```

## File Organization

```
backend/
├── app/
│   ├── controllers/       # API & web controllers
│   ├── models/           # ActiveRecord models (9 total)
│   ├── views/            # ERB templates & partials
│   ├── javascript/       # Stimulus controllers
│   └── assets/           # Stylesheets
├── config/
│   ├── routes.rb         # Route definitions
│   ├── database.yml      # Database config
│   └── importmap.rb      # JS dependencies
├── db/
│   ├── migrate/          # Migration files (9 tables)
│   └── seeds.rb          # Seed data
├── lib/
│   └── json_web_token.rb # JWT helper
├── Gemfile               # Ruby dependencies
├── tailwind.config.js    # Tailwind configuration
└── README.md             # Detailed documentation
```

## Design Philosophy

### User Experience
- **Dark Mode First**: Designed for comfortable long-term use
- **Gamification**: Elo ranks and points keep users motivated
- **Progressive Difficulty**: Target weights increase with rank
- **Social Competition**: Battle friends to climb ranks

### Technical Decisions
- **Monolithic over Microservices**: Simpler deployment, faster development
- **Server-Side Rendering**: Better SEO, faster initial load, simpler state management
- **Hotwire over React**: Less JavaScript, faster interactions, Rails-native
- **PostgreSQL**: Robust relational database for complex queries

## Next Steps

To extend this application, consider:

1. **Testing**: Add RSpec or Minitest test suite
2. **Deployment**: Deploy to Heroku, Render, or Fly.io
3. **Mobile**: Build native apps consuming the API
4. **Features**:
   - Workout history charts
   - Leaderboards
   - Custom exercise builder
   - Video demonstrations
   - Rest timer
   - Progressive overload tracking

## Documentation

- **Backend Details**: See `backend/README.md` for comprehensive documentation
- **Backend Plan**: See `Backendplan.txt` for original specifications
- **Frontend Plan**: See `Frontendplan.txt` for UI/UX specifications

## Support

For questions or issues:
1. Check the detailed README in `backend/README.md`
2. Review the original plan files
3. Inspect the seed data in `db/seeds.rb`

---

**Built with ❤️ using Ruby on Rails**
